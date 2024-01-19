namespace st.temp.WebAPI.Extensions;

using System;
using Microsoft.AspNetCore.Http;

public static class IHttpContextAccessorExtensions
{
  public static bool TryGetRouteValueAsGuid(
    this IHttpContextAccessor httpContextAccessor,
    string key,
    out Guid? response)
  {
    if (httpContextAccessor == null)
    {
      throw new ArgumentNullException(nameof(httpContextAccessor));
    }

    if (string.IsNullOrEmpty(key))
    {
      throw new ArgumentException("Value cannot be null or empty.", nameof(key));
    }

    var value = httpContextAccessor.HttpContext.Request.RouteValues[key]?.ToString();

    var r = default(Guid);
    if (string.IsNullOrEmpty(value) || !Guid.TryParse(value, out r))
    {
      response = null;
      return false;
    }

    response = r;
    return true;
  }

  public static bool TryGetRouteValue(this IHttpContextAccessor httpContextAccessor, string key, out string response)
  {
    if (httpContextAccessor == null)
    {
      throw new ArgumentNullException(nameof(httpContextAccessor));
    }

    if (string.IsNullOrEmpty(key))
    {
      throw new ArgumentException("Value cannot be null or empty.", nameof(key));
    }

    response = httpContextAccessor.HttpContext.Request.RouteValues[key]?.ToString();

    return !string.IsNullOrEmpty(response);
  }
}
