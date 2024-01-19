namespace st.temp.WebAPI.Middleware.AuthenticateAlways;

using System;
using System.Threading.Tasks;
using BusinessLogic.Authentication.CreateJwtToken;
using BusinessLogic.Authentication.Login;
using Common;
using MediatR;
using Microsoft.AspNetCore.Http;
using st.temp.common;

public class AuthenticateAlwaysMiddleware : IMiddleware
{
  private readonly IMediator mediator;

  public AuthenticateAlwaysMiddleware(IMediator mediator)
  {
    this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
  }

  public async Task InvokeAsync(HttpContext context, RequestDelegate next)
  {
    if (context == null)
    {
      throw new ArgumentNullException(nameof(context));
    }

    if (context.Request.Path.HasValue
      && context.Request.Path.ToString().ToUpper().EndsWith("/LOGIN"))
    {
        var loginRequest = await context.Request.ReadFromJsonAsync<LoginRequest>();

        var jwtTokenResponse = await this.mediator.Send(
          new CreateJwtTokenRequest(loginRequest?.Username ?? "developer@test.de")
          {
            ExpiresOn = DateTime.Now.AddHours(24),
            UserRoles = new[] { UserRoleNames.AMReader, UserRoleNames.AMWriter },
          });

        var loginResponse = new LoginResponse
        {
          WasSuccess = true,
          JwtToken = jwtTokenResponse.JwtToken,
        };

        context.Response.Headers.Add("Access-Control-Allow-Origin", new[] { (string)context.Request.Headers["Origin"] });
        context.Response.Headers.Add("Access-Control-Allow-Headers", new[] { "Origin, X-Requested-With, Content-Type, Accept" });
        context.Response.Headers.Add("Access-Control-Allow-Methods", new[] { "GET, POST, PUT, DELETE, PATCH, OPTIONS" });
        context.Response.Headers.Add("Access-Control-Allow-Credentials", new[] { "true" });
        context.Response.StatusCode = 200;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(loginResponse);
        return;
    }

    await next!?.Invoke(context);
  }
}
