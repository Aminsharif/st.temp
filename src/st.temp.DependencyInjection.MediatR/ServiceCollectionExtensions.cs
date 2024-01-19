namespace st.temp.DependencyInjection.MediatR;

using System;
using System.Collections.Generic;
using System.Linq;
using global::MediatR;
using Microsoft.Extensions.DependencyInjection;

using st.temp.BusinessLogic.Authentication.Login;
using st.temp.Data.Commands.Users.Create;
using st.temp.Data.Queries.Users.UserLookup;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddMediatrAndAutomapper(
      this IServiceCollection services,
      IEnumerable<Type> additionalMarkerTypes = null)
    {
        return services.AddMediatrAndAutomapper<Mediator>(additionalMarkerTypes);
    }

    public static IServiceCollection AddMediatrAndAutomapper<TMediator>(
      this IServiceCollection services,
      IEnumerable<Type> additionalMarkerTypes = null,
      ServiceLifetime serviceLifetime = ServiceLifetime.Transient)
      where TMediator : IMediator
    {
        var markerTypes = new List<Type>
    {
      typeof(LoginRequest),
      typeof(CreateUserCommand),
      typeof(UserLookupQuery),
    }.Union(additionalMarkerTypes ?? Enumerable.Empty<Type>()).ToArray();

        services.AddAutoMapper(markerTypes);

        services.AddMediatR(markerTypes, configuration =>
        {
            configuration.Using<TMediator>();
            switch (serviceLifetime)
            {
                case ServiceLifetime.Singleton:
                    configuration.AsSingleton();
                    break;
                case ServiceLifetime.Scoped:
                    configuration.AsScoped();
                    break;
                case ServiceLifetime.Transient:
                    configuration.AsTransient();
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(serviceLifetime), serviceLifetime, null);
            }
        });

        return services;
    }
}
