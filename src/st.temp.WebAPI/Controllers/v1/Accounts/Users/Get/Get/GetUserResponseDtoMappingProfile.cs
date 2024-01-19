namespace st.temp.WebAPI.Controllers.v1.Accounts.User.Get.Get;

using AutoMapper;
using st.temp.Data.Queries.Users.UserById;

public class GetUserResponseDtoMappingProfile : Profile
{
  public GetUserResponseDtoMappingProfile()
  {
    this.CreateMap<UserByIdQueryResult, GetUserResponseDto>();
  }
}
