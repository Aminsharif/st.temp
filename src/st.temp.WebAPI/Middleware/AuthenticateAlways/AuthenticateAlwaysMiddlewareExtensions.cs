namespace st.temp.WebAPI.Middleware.AuthenticateAlways;

using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

public static class AuthenticateAlwaysMiddlewareExtensions
{
  public static IServiceCollection AddAuthenticateAlwaysMiddleware(this IServiceCollection serviceCollection)
  {
    if (serviceCollection == null)
    {
      throw new ArgumentNullException(nameof(serviceCollection));
    }

    serviceCollection.AddTransient<AuthenticateAlwaysMiddleware>();

    return serviceCollection;
  }

  public static IApplicationBuilder UseAuthenticateAlways(this IApplicationBuilder app)
  {
    if (app == null)
    {
      throw new ArgumentNullException(nameof(app));
    }

    return app.Use(next =>
    {
      return async context =>
      {
        var middlewareFactory = (IMiddlewareFactory)context.RequestServices.GetService(typeof(IMiddlewareFactory));
        if (middlewareFactory == null)
        {
          throw new ArgumentException("IMiddlewareFactory");
        }

        var middleware = middlewareFactory.Create(typeof(AuthenticateAlwaysMiddleware));
        if (middleware == null)
        {
          throw new ArgumentException($"{nameof(AuthenticateAlwaysMiddleware)} could not be generated");
        }

        try
        {
          await middleware.InvokeAsync(context, next);
        }
        finally
        {
          middlewareFactory.Release(middleware);
        }
      };
    });
  }
}