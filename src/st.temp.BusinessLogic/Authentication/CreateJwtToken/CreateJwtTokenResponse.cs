namespace st.temp.BusinessLogic.Authentication.CreateJwtToken;

public class CreateJwtTokenResponse
{
  public CreateJwtTokenResponse(string jwtToken)
  {
    this.JwtToken = jwtToken;
  }

  public string JwtToken { get; }
}