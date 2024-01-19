using DbUp;
using Microsoft.Data.SqlClient;
using st.temp.Database.Scripts;

namespace st.temp.Database
{
    public static class Program
    {
        public static int Main(string[] args)
        {
            var connectionString =
              @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=DemoProcessing-dev;Integrated Security=True;Connect Timeout=30;";

            var backupDirectory = Path.GetTempPath();

            if (args.Any() && args.Length >= 2)
            {
                connectionString = args[0];
                backupDirectory = args[1];
            }

            Console.WriteLine($"Conection String: {connectionString}");
            Console.WriteLine($"Backup Directory: {backupDirectory}");

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

            if (upgrader.IsUpgradeRequired())
            {
                Console.WriteLine("Upgrade of Database required. Creating Backup");
                UpdateDatabase(connectionString, backupDirectory);
            }

            var result = upgrader.PerformUpgrade();

            if (!result.Successful)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(result.Error);
                Console.ResetColor();
#if DEBUG
                Console.ReadLine();
#endif
                return -1;
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Success!");
            Console.ResetColor();
            return 0;
        }
        private static void UpdateDatabase(string connectionString, string backupDiretory)
        {
            if (string.IsNullOrEmpty(connectionString))
            {
                throw new ArgumentException("Value cannot be null or empty.", nameof(connectionString));
            }

            var csb = new SqlConnectionStringBuilder(connectionString);

            if (string.IsNullOrEmpty(csb.InitialCatalog))
            {
                throw new ArgumentException("Cannot backup database because initial catalog is missing in the connection string");
            }

            Console.WriteLine($"Backing Up database {csb.InitialCatalog}");

            var backupPath = Path.Combine(backupDiretory, csb.InitialCatalog);

            var backupCommand = @$"
                BACKUP DATABASE [{csb.InitialCatalog}]
                TO  DISK = N'{backupPath}'
                WITH NOFORMAT, NOINIT,  NAME = N'{csb.InitialCatalog}-Full Database Backup {DateTime.UtcNow:yyyy-MM-dd HHmmss}', SKIP, NOREWIND, NOUNLOAD,  STATS = 10";

            using (var sqlConnection = new SqlConnection(csb.ConnectionString))
            {
                sqlConnection.Open();
                using var command = new SqlCommand(backupCommand, sqlConnection);
                command.ExecuteNonQuery();
                sqlConnection.Close();
            }
        }
    }
}


