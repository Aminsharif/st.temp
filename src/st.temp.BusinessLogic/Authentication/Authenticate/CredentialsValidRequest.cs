namespace st.temp.BusinessLogic.Authentication.Authenticate;

using MediatR;

public class CredentialsValidRequest : IRequest<bool>
{
  public string Username { get; set; }

  public string Password { get; set; }
}