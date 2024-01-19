namespace st.temp.BusinessLogic.Authentication.Login;

public class LoginResponse
{
  public bool WasSuccess { get; set; }

  public string JwtToken { get; set; }
}