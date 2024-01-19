namespace st.temp.Data.Queries.Users.UserByUserNameExists;

using System;
using MediatR;

public class UserByUserNameExistsQuery : IRequest<bool>
{
    public UserByUserNameExistsQuery(string nameProperty)
    {
        NameProperty = nameProperty;
    }

    public string NameProperty { get; }
}
