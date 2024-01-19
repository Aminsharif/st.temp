namespace st.temp.WebAPI.Controllers.v1.Accounts.Login.Post;
using AutoMapper;
using BusinessLogic.Authentication.Login;

public class LoginResponseDtoMappingProfile : Profile
{
  public LoginResponseDtoMappingProfile()
  {
    this.CreateMap<LoginResponse, LoginResponseDto>();
  }
}
