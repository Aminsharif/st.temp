namespace st.temp.WebAPI;

using st.temp.common;
using st.temp.WebAPI.Extensions;
using System;
using System.Collections.Generic;
using System.Security.Claims;

public sealed class ClaimsPrincipalCurrentUserInfo : ICurrentUserInfo
{
  private readonly ClaimsPrincipal claimsPrincipal;

  public ClaimsPrincipalCurrentUserInfo(ClaimsPrincipal claimsPrincipal)
  {
    this.claimsPrincipal = claimsPrincipal ?? throw new ArgumentNullException(nameof(claimsPrincipal));
  }

  public string Username => this.claimsPrincipal.GetUsername();

  public IEnumerable<string> UserRoles => this.claimsPrincipal.GetUserRoles();
}
