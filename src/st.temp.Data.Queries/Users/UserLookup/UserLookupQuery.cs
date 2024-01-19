namespace st.temp.Data.Queries.Users.UserLookup;

using MediatR;

public class UserLookupQuery : IRequest<UserLookupQueryResult>
{
    public int Limit { get; set; } = 25;

    public int Offset { get; set; }
}
