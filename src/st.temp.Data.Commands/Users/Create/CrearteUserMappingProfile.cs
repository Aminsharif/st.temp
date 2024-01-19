namespace st.temp.Data.Commands.Users.Create;

using AutoMapper;
using st.temp.Common.Extensions;

public class CrearteUserMappingProfile : Profile
{
  public CrearteUserMappingProfile()
  {
    this.CreateMap<CreateUserCommand, AppUser>()
      .IgnoreOnDestination(d => d.UpdatedBy)
      .IgnoreOnDestination(d => d.CreatedBy)
      .IgnoreOnDestination(d => d.Created)
      .IgnoreOnDestination(d => d.LastUpdated)
      .IgnoreOnDestination(d => d.Id);
  }
}

