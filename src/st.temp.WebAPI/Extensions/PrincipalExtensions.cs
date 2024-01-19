namespace st.temp.WebAPI.Extensions;

using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;

public static class PrincipalExtensions
{
  public static string GetUsername(this IPrincipal principal)
  {
    return principal.FindFirstValue(ClaimTypes.Name);
  }

  public static IEnumerable<string> GetUserRoles(this IPrincipal principal)
  {
    return principal.FindValues(ClaimTypes.Role);
  }

  /// <summary>
  /// Get the first value of a claim of the specified <paramref name="claimType"/>.
  /// </summary>
  /// <param name="principal">Claims principal.</param>
  /// <param name="claimType">Claim type.</param>
  /// <returns>The first claim value or <c>null</c> if there is no such claim.</returns>
  public static string FindFirstValue(this IPrincipal principal, string claimType)
    => (principal as ClaimsPrincipal)?.FindFirst(claimType)?.Value;

  public static IEnumerable<string> FindValues(this IPrincipal principal, string claimType)
    => (principal as ClaimsPrincipal)?.FindAll(claimType).Select(c => c.Value);
}