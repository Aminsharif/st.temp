namespace st.temp.BusinessLogic.Authentication.UserInfo;

using MediatR;

public class UserInfoRequest : IRequest<UserInfoResponse>
{
  public UserInfoRequest(string username)
  {
    this.Username = username;
  }

  public string Username { get; }
}