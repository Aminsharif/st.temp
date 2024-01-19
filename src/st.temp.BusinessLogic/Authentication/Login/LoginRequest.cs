namespace st.temp.BusinessLogic.Authentication.Login;

using MediatR;

public class LoginRequest : IRequest<LoginResponse>
{
  public string Username { get; set; }

  public string Password { get; set; }
}