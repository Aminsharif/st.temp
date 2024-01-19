namespace st.temp.DependencyInjection.FileStorage.Extensions;

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Foundatio.Storage;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using st.temp.common;

public static class IServiceCollectionExtensions
{
  private static Dictionary<string, (string source, IFileStorage fileStorage)> fileStorages;

  static IServiceCollectionExtensions()
  {
    fileStorages = new Dictionary<string, (string source, IFileStorage fileStorage)>();
  }

  public static IServiceCollection AddFileStorage(this IServiceCollection services)
  {
    if (services == null)
    {
      throw new ArgumentNullException(nameof(services));
    }

    services.AddSingleton<FileStorageFactory>(provider =>
    {
      var configuration = provider.GetRequiredService<IConfiguration>();

      // Lockwiz Share
      var lockwizFolder = configuration.GetValue<string>("FileShares:Lockwiz");
      fileStorages[FileShareNames.Lockwiz] = (lockwizFolder, new FolderFileStorage(
        new FolderFileStorageOptions
        {
          Folder = lockwizFolder,
        }));

      // Excel Share
      var excelFolder = configuration.GetValue<string>("FileShares:LockingPlanExcel");
      fileStorages[FileShareNames.Excel] = (excelFolder, new FolderFileStorage(
        new FolderFileStorageOptions
        {
          Folder = excelFolder,
        }));

      //Pdf  Share
      var pdfFolder = configuration.GetValue<string>("FileShares:LockingPlanPdf");
      fileStorages[FileShareNames.Pdf] = (pdfFolder, new FolderFileStorage(
        new FolderFileStorageOptions
        {
          Folder = pdfFolder,
        }));

      return name =>
      {
        if (!fileStorages.TryGetValue(name, out var fileStorageEntry))
        {
          throw new ArgumentException($"Storage with name {name} is not registered");
        }

        return Task.FromResult(fileStorageEntry);
      };
    });

    return services;
  }
}
