namespace st.temp.Data.Queries.Users.UserById;

using AutoMapper;

public class UserByUserNameQueryResultMappingProfile : Profile
{
    public UserByUserNameQueryResultMappingProfile()
    {
        CreateMap<AppUser, UserByIdQueryResult>();
    }
}