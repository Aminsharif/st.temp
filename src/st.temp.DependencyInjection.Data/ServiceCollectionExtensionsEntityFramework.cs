using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using st.temp.Data;

namespace st.temp.DependencyInjection.Data;

    public static class ServiceCollectionExtensionsEntityFramework
    {
        public static IServiceCollection AddDatabase(this IServiceCollection serviceCollection)
        {
        serviceCollection
          .AddDbContext<DemoDbContext>(
            (sp, options) =>
            {
                var configuration = sp.GetRequiredService<IConfiguration>();
                options.UseSqlServer(configuration.GetConnectionString("DefaultConnection"));
            },
            ServiceLifetime.Transient);
              

            return serviceCollection;
        }
    }

