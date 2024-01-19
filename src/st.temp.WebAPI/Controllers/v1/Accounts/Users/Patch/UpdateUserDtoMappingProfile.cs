namespace st.temp.WebAPI.Controllers.v1.Accounts.Users.Patch;

using AutoMapper;
using st.temp.Data.Queries.Users.UserById;

public class UpdateUserDtoMappingProfile : Profile
{
  public UpdateUserDtoMappingProfile()
  {
    this.CreateMap<UserByIdQueryResult, UpdateUserRequestDto>();
  }
}
