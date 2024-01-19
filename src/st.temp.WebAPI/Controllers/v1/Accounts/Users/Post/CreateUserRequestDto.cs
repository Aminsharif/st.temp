namespace st.temp.WebAPI.Controllers.v1.Accounts.Users.Post;
public class CreateUserRequestDto
{
  public string UserName { get; set; }

  public string Password { get; set; }

  public string UserRole { get; set; }
}
