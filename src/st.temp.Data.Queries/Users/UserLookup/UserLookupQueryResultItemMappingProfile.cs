namespace st.temp.Data.Queries.Users.UserLookup;

using AutoMapper;

public class UserLookupQueryResultItemMappingProfile : Profile
{
    public UserLookupQueryResultItemMappingProfile()
    {
        CreateMap<AppUser, UserLookupQueryResultItem>();
    }
}
