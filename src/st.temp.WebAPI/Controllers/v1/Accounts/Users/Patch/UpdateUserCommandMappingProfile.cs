namespace st.temp.WebAPI.Controllers.v1.Accounts.Users.Patch;

using AutoMapper;
using st.temp.Data.Commands.Users.Update;

public class UpdateUserCommandMappingProfile : Profile
{
  public UpdateUserCommandMappingProfile()
  {
    this.CreateMap<UpdateUserRequestDto, UpdateUserCommand>()
      .ForMember(d => d.Id, e => e.Ignore());
  }
}
