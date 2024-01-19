namespace st.temp.DependencyInjection.FileStorage.Extensions;

using System;
using System.Threading.Tasks;
using Common;
using Foundatio.Storage;
using st.temp.common;

public static class FileStorageFactoryExtensions
{
  public static Task<(string source, IFileStorage fileStorage)> Excel(this FileStorageFactory factory)
  {
    if (factory == null)
    {
      throw new ArgumentNullException(nameof(factory));
    }

    return factory(FileShareNames.Excel);
  }

  public static Task<(string source, IFileStorage fileStorage)> Lockwiz(this FileStorageFactory factory)
  {
    if (factory == null)
    {
      throw new ArgumentNullException(nameof(factory));
    }

    return factory(FileShareNames.Lockwiz);
  }

  public static Task<(string source, IFileStorage fileStorage)> Pdf(this FileStorageFactory factory)
  {
    if (factory == null)
    {
      throw new ArgumentNullException(nameof(factory));
    }

    return factory(FileShareNames.Pdf);
  }

}
