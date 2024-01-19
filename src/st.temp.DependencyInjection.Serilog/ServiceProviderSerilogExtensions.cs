namespace st.temp.DependencyInjection.Serilog;

using System;
using global::Serilog;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

public static class ServiceProviderSerilogExtensions
{
    public static IServiceCollection ConfigureSerilog(
      this IServiceCollection serviceCollection,
      IConfiguration configuration)
    {
        if (serviceCollection == null)
        {
            throw new ArgumentNullException(nameof(serviceCollection));
        }

        if (configuration == null)
        {
            throw new ArgumentNullException(nameof(configuration));
        }

        Log.Logger = new LoggerConfiguration()
          .ReadFrom.Configuration(configuration)
          .Enrich.WithCorrelationId()
          .CreateLogger();

        return serviceCollection;
    }
}
