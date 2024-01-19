namespace st.temp.BusinessLogic.Authentication.Login;

using Authenticate;
using AutoMapper;

public class CredentialsValidRequestMappingProfile : Profile
{
  public CredentialsValidRequestMappingProfile()
  {
    this.CreateMap<LoginRequest, CredentialsValidRequest>();
  }
}