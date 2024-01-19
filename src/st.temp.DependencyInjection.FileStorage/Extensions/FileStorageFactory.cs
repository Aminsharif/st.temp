namespace st.temp.DependencyInjection.FileStorage.Extensions;

using System.Threading.Tasks;
using Foundatio.Storage;

public delegate Task<(string source, IFileStorage fileStorage)> FileStorageFactory(string storageName);
