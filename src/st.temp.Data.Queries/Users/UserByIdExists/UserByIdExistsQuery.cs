namespace st.temp.Data.Queries.Users.UserByIdExists;

using System;
using MediatR;

public class UserByIdExistsQuery : IRequest<bool>
{
    public UserByIdExistsQuery(Guid idProperty)
    {
        UserId = idProperty;
    }

    public Guid UserId { get; }
}
