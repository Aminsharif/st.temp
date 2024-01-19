namespace st.temp.Data.Commands.Users.Update;

using System;
using AutoMapper;
using st.temp.Common.Extensions;

public class UpdateUserMappingProfile : Profile
{
  public UpdateUserMappingProfile()
  {
    this.CreateMap<UpdateUserCommand, AppUser>()
      .IgnoreOnDestination(d => d.CreatedBy)
      .IgnoreOnDestination(d => d.Password)
      .IgnoreOnDestination(d => d.Created)
      .IgnoreOnDestination(d => d.UpdatedBy)
      .ForMember(d => d.Id, e => e.Ignore())
      .ForMember(d => d.LastUpdated, e => e.MapFrom(t => DateTime.UtcNow));
  }
}
