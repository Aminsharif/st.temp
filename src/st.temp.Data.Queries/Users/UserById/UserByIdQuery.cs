namespace st.temp.Data.Queries.Users.UserById;


using System;
using MediatR;

public class UserByIdQuery : IRequest<UserByIdQueryResult>
{
    public UserByIdQuery(Guid userId)
    {
        UserId = userId;
    }

    public Guid UserId { get; }
}
