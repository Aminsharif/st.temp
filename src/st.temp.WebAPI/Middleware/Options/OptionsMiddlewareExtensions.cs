namespace st.temp.WebAPI.Middleware.Options;

using Microsoft.AspNetCore.Builder;

public static class OptionsMiddlewareExtensions
{
  public static IApplicationBuilder UseOptions(this IApplicationBuilder builder)
  {
    return builder.UseMiddleware<OptionsMiddleware>();
  }
}
