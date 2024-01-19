namespace st.temp.WebAPI.Controllers.v1.Accounts.Users.Post;

using AutoMapper;
using Common.Extensions;
using st.temp.Data.Commands.Users.Create;

public class CreateUserCommandMappingProfile : Profile
{
  public CreateUserCommandMappingProfile()
  {
    this.CreateMap<CreateUserRequestDto, CreateUserCommand>()
    .IgnoreOnDestination(d => d.Created)
    .IgnoreOnDestination(d => d.LastUpdated);
  }
}
