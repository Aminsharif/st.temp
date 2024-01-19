namespace st.temp.BusinessLogic.Authentication.UserInfo;

using System.Collections.Generic;

public class UserInfoResponse
{
  public UserInfoResponse(string username)
  {
    this.Username = username;
  }

  public string Username { get; }

  public string DisplayName { get; set; }

  public IEnumerable<string> UserRoles { get; set; }
}