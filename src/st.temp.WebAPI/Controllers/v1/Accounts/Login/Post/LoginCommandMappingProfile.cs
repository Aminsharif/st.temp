namespace st.temp.WebAPI.Controllers.v1.Accounts.Login.Post;

using AutoMapper;
using BusinessLogic.Authentication.Login;

public class LoginCommandMappingProfile : Profile
{
  public LoginCommandMappingProfile()
  {
    this.CreateMap<LoginRequestDto, LoginRequest>();
  }
}
