namespace st.temp.WebAPI.Controllers.v1.Accounts.Login.Post;
public class LoginResponseDto
{
  public bool WasSuccess { get; set; }

  public string JwtToken { get; set; }
}
