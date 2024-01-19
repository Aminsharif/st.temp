using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO.Compression;
using System.Linq;
using System.Text;
using DbUp;
using Microsoft.Data.SqlClient;
using Nuke.Common;
using Nuke.Common.CI;
using Nuke.Common.Execution;
using Nuke.Common.Git;
using Nuke.Common.IO;
using Nuke.Common.ProjectModel;
using Nuke.Common.Tooling;
using Nuke.Common.Tools.Coverlet;
using Nuke.Common.Tools.Docker;
using Nuke.Common.Tools.DotNet;
using Nuke.Common.Tools.GitVersion;
using Nuke.Common.Utilities.Collections;
using static Nuke.Common.Tools.Docker.DockerTasks;
using static Nuke.Common.IO.FileSystemTasks;
using static Nuke.Common.Tools.DotNet.DotNetTasks;
using static Extensions.SqlConnectionStringBuilderExt;
using st.temp.Database.Scripts;

[CheckPathEnvironmentVariable]
[ShutdownDotNetAfterServerBuild]
class Build : NukeBuild
{
    // Support plugins are available for:
    ///   - JetBrains ReSharper        https://nuke.build/resharper
    ///   - JetBrains Rider            https://nuke.build/rider
    ///   - Microsoft VisualStudio     https://nuke.build/visualstudio
    ///   - Microsoft VSCode           https://nuke.build/vscode
    public static int Main() => Execute<Build>(x => x.Compile);

    [Parameter("Configuration to build - Default is 'Debug' (local) or 'Release' (server)")]
    readonly Configuration Configuration = IsLocalBuild ? Configuration.Debug : Configuration.Release;

    [Parameter("Sets the ASPNETCORE_ENVIRONMENT used in the web.config after publish")]
    WebApiEnvironment WebApiEnvironment { get; } = WebApiEnvironment.Local;

    [Parameter("Run Pro Alpha Unit Tests or not")]
    private int RunProAlphaUnitTests { get; } = 1;

    [Parameter("Version Tag uses for docker push")]
    readonly string dockerVersionTag;

    [Parameter]
    int TestPartitionSkip { get; } = 0;

    [Parameter]
    int? TestPartitionTake { get; } = null;

    [Solution] readonly Solution Solution;

    [GitRepository] readonly GitRepository GitRepository;

    [GitVersion] readonly GitVersion GitVersion;

    AbsolutePath SourceDirectory => RootDirectory / "src";

    AbsolutePath OutputDirectory => RootDirectory / "output";

    AbsolutePath ArtifactsDirectory => RootDirectory / "artifacts";

    IEnumerable<Project> TestProjects
    {
        get
        {
            var allTestProjects = this.Solution.GetProjects("*Tests*");
            if (this.RunProAlphaUnitTests <= 0)
            {
                Logger.Warn("Excluding Pro Alpha Queries in Unit Tets");

                return allTestProjects.Where(project =>
                    !project.Name.Contains("ProAlpha", StringComparison.CurrentCultureIgnoreCase));
            }

            return allTestProjects;
        }
    }

    AbsolutePath TestResultDirectory => ArtifactsDirectory / "test-results";

    Target Dockerize => _ => _
        .Executes(() =>
        {
            DockerBuild(x => x
                .SetPath(".")
                .SetFile("st.temp.WebAPI/Dockerfile")
                .SetTag(this.GetVersionsForImage("st.temp.webapi", true))
            );
        });

    Target PublishWebApi => _ =>
    {
        return _
            .DependsOn(this.Compile)
            .Executes(() =>
            {
                DotNetPublish(o => o
                    .SetConfiguration(this.Configuration)
                    .SetAssemblyVersion(GitVersion.AssemblySemVer)
                    .SetFileVersion(GitVersion.AssemblySemFileVer)
                    .SetInformationalVersion(GitVersion.InformationalVersion)
                    .SetPlatform("x64")
                    .SetOutput(this.OutputDirectory + "/WebApi")
                    .SetProject(this.Solution.GetProject("st.temp.WebAPI")));
            });
    };

    Target PublishDatabaseTool => _ => _
        .Executes(() =>
        {
            DotNetPublish(o => o
                .SetConfiguration(this.Configuration)
                .SetOutput(this.OutputDirectory + "/DatabaseConfigurationTool")
                .SetAssemblyVersion(GitVersion.AssemblySemVer)
                .SetFileVersion(GitVersion.AssemblySemFileVer)
                .SetInformationalVersion(GitVersion.InformationalVersion)
                .SetProject(this.Solution.GetProject("st.temp.Database")));
        });

    Target PublishAzureFunctions => _ => _
        .Executes(() =>
        {
            var azureFunctionsOutputDirectory = this.OutputDirectory + "/AzureFunctions";
            var azureFunctionsTempOutputDirectory = azureFunctionsOutputDirectory + "/temp";

            DeleteDirectory(azureFunctionsOutputDirectory);

            DotNetPublish(o => o
                .SetConfiguration(this.Configuration)
                .SetOutput(azureFunctionsTempOutputDirectory)
                .SetAssemblyVersion(GitVersion.AssemblySemVer)
                .SetFileVersion(GitVersion.AssemblySemFileVer)
                .SetInformationalVersion(GitVersion.InformationalVersion)
                .SetProject(this.Solution.GetProject("st.temp.Messaging.AzureFunctions.Net7")));

            ZipFile.CreateFromDirectory(
                azureFunctionsTempOutputDirectory,
                azureFunctionsOutputDirectory + "/azureFunctions.zip");

            DeleteDirectory(azureFunctionsTempOutputDirectory);
        });

    Target PublishCli => _ =>
    {
        return _
            .Executes(() =>
            {
                DotNetPublish(o => o
                    .SetConfiguration(this.Configuration)
                    .SetAssemblyVersion(GitVersion.AssemblySemVer)
                    .SetFileVersion(GitVersion.AssemblySemFileVer)
                    .SetInformationalVersion(GitVersion.InformationalVersion)
                    .SetOutput(this.OutputDirectory + "/Cli")
                    .SetProject(this.Solution.GetProject("st.temp.Cli")));
            });
    };

    Target BackupDatabase => _ =>
    {
        return _
            .Executes(() =>
            {
                if (this.WebApiEnvironment == WebApiEnvironment.Local)
                {
                    throw new NotSupportedException("Local Backups not supported");
                }

                var csb = this.GetDatabaseConnection();

                var backupCommand = @$"
                BACKUP DATABASE [{csb.InitialCatalog}]
                TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\Backup\{csb.InitialCatalog}' 
                WITH NOFORMAT, NOINIT,  NAME = N'{csb.InitialCatalog}-Full Database Backup {DateTime.UtcNow:yyyy-MM-dd HHmmss}', SKIP, NOREWIND, NOUNLOAD,  STATS = 10";

                using (var sqlConnection = new SqlConnection(csb.ConnectionString))
                {
                    sqlConnection.Open();
                    using var command = new SqlCommand(backupCommand, sqlConnection);
                    command.ExecuteNonQuery();
                    sqlConnection.Close();
                }
            });
    };

    Target UpdateDatabase => _ => _
        .Executes(() =>
        {
            Console.WriteLine($"Processing DBUpdate for Environment {this.WebApiEnvironment}");

            var connectionString = this.GetDatabaseConnection().ConnectionString;

            EnsureDatabase
                .For
                .SqlDatabase(connectionString);

            var upgrader =
                DeployChanges.To
                    .SqlDatabase(connectionString)
                    .WithTransactionPerScript()
                    .WithScriptsEmbeddedInAssembly(typeof(DatabaseScripts).Assembly)
                    .LogToConsole()
                    .Build();

            var result = upgrader.PerformUpgrade();

            if (!result.Successful)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(result.Error);
                Console.ResetColor();
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Success!");
                Console.ResetColor();
            }
        });

    Target TestPartitioned => _ => _
        .DependsOn(this.Compile)
        .ProceedAfterFailure()
        .Produces(TestResultDirectory / "*.trx")
        .Produces(TestResultDirectory / "*.xml")
        .Executes(() =>
        {
            var testAssemblyPartition = this.TestProjects.OrderBy(p => p.Name)
                .Skip(this.TestPartitionSkip);

            testAssemblyPartition = this.TestPartitionTake.HasValue
                ? testAssemblyPartition.Take(this.TestPartitionTake.Value).ToList()
                : testAssemblyPartition.ToList();

            var sb = new StringBuilder();
            sb.Append("Testing Assemblies: ");
            foreach (var testAssembly in testAssemblyPartition)
            {
                sb.Append($"{testAssembly.Name} ");
            }

            Logger.Info(sb.ToString());

            DotNetTest(
                _ => _
                    .SetConfiguration(this.Configuration)
                    .SetNoBuild(this.InvokedTargets.Contains(this.Compile))
                    .ResetVerbosity()
                    .SetVerbosity(DotNetVerbosity.Normal)
                    .SetResultsDirectory(this.TestResultDirectory)
                    .SetDataCollector("XPlat Code Coverage")
                    .SetExcludeByFile("*.Generated.cs")
                    .CombineWith(testAssemblyPartition, (_, v) => _
                        .SetProjectFile(v)
                        .SetLoggers(
                            $@"junit;LogFilePath=..\..\artifacts\{v.Name}-test-result.xml;MethodFormat=Class;FailureBodyFormat=Verbose")
                        .SetCoverletOutput(this.TestResultDirectory / $"{v.Name}.xml")),
                completeOnFailure: true);
        });

    Target Test => _ => _
        .DependsOn(this.Compile)
        .ProceedAfterFailure()
        .Produces(TestResultDirectory / "*.junit")
        .Executes(() =>
        {
            DotNetTest(
                _ => _
                    .SetConfiguration(this.Configuration)
                    .SetNoBuild(this.InvokedTargets.Contains(this.Compile))
                    .ResetVerbosity()
                    .SetResultsDirectory(this.TestResultDirectory)
                    .SetDataCollector("XPlat Code Coverage")
                    .SetExcludeByFile("*.Generated.cs")
                    .CombineWith(this.TestProjects, (_, v) => _
                        .SetProjectFile(v)
                        .SetLoggers(
                            $@"junit;LogFilePath=..\..\artifacts\{v.Name}-test-result.xml;MethodFormat=Class;FailureBodyFormat=Verbose")
                        .SetCoverletOutput(this.TestResultDirectory / $"{v.Name}.xml")),
                completeOnFailure: true);
        });

    Target Clean => _ => _
        .Before(Restore)
        .Executes(() =>
        {
            SourceDirectory.GlobDirectories("**/bin", "**/obj").ForEach(DeleteDirectory);
            EnsureCleanDirectory(OutputDirectory);
        });

    Target Restore => _ => _
        .Executes(() =>
        {
            DotNetRestore(s => s
                .SetProjectFile(Solution));
        });

    Target Compile => _ => _
        .DependsOn(Restore)
        .Executes(() =>
        {
            DotNetBuild(s => s
                .SetProjectFile(this.Solution)
                .SetConfiguration(this.Configuration)
                .SetAssemblyVersion(GitVersion.AssemblySemVer)
                .SetFileVersion(GitVersion.AssemblySemFileVer)
                .SetInformationalVersion(GitVersion.InformationalVersion)
                .SetPlatform("x64")
                .EnableNoRestore());

            Logger.Warn($"Current Version: {this.GitVersion.SemVer}");
        });

    Target ShowVersion => _ => _
        .Executes(() =>
        {
            var version = GitVersion.AssemblySemVer;
            Logger.Warn($"Current Version: {version}");
        });

    List<string> GetVersionsForImage(string imageName, bool includeLatest)
    {
        var tagVersions = new List<string>();
        if (includeLatest)
        {
            tagVersions.Add("latest");
        }

        var version = this.dockerVersionTag ?? this.GitRepository.Commit;
        tagVersions.Add(version);

        return tagVersions.Select(s => $"{imageName}:{s}").Distinct().ToList();
    }

    SqlConnectionStringBuilder GetDatabaseConnection() => this.WebApiEnvironment switch
    {
        // Local Local
        WebApiEnvironment.Local => GetConnectionTo().LocalDatabase(),


        // When deployed to dev environment
        WebApiEnvironment.Development => GetConnectionTo().DevelopmentDatabase(),

        // When deployed to UAD
        WebApiEnvironment.Integration => GetConnectionTo().UatDatabase(),


        // When deployed to production
        WebApiEnvironment.Production => GetConnectionTo().ProductionDatabase(),


        _ => throw new NotSupportedException($"Configuration {this.WebApiEnvironment} is not supported")
    };
}