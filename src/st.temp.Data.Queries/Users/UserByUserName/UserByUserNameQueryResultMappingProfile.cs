namespace st.temp.Data.Queries.Users.UserByUserName;

using AutoMapper;

public class UserByUserNameQueryResultMappingProfile : Profile
{
    public UserByUserNameQueryResultMappingProfile()
    {
        CreateMap<AppUser, UserByUserNameQueryResult>();
    }
}