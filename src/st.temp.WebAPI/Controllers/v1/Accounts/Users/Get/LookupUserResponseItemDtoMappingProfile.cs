namespace st.temp.WebAPI.Controllers.v1.v1.Accounts.Users.Get;

using AutoMapper;
using st.temp.Data.Queries.Users.UserLookup;

public class LookupUserResponseItemDtoMappingProfile : Profile
{
  public LookupUserResponseItemDtoMappingProfile()
  {
    this.CreateMap<UserLookupQueryResultItem, LookupUserResponseItemDto>();
  }
}
