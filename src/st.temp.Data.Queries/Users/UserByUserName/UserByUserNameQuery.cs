namespace st.temp.Data.Queries.Users.UserByUserName;


using MediatR;

public class UserByUserNameQuery : IRequest<UserByUserNameQueryResult>
{
    public UserByUserNameQuery(string userName)
    {
        Username = userName;
    }

    public string Username { get; }
}
