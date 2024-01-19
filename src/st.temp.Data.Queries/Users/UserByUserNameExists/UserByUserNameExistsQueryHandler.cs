namespace st.temp.Data.Queries.Users.UserByUserNameExists;

using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.EntityFrameworkCore;

public class UserByUserNameExistsQueryHandler : IRequestHandler<UserByUserNameExistsQuery, bool>
{
    private readonly DemoDbContext dbContextType;

    public UserByUserNameExistsQueryHandler(DemoDbContext dbContextType)
    {
        this.dbContextType = dbContextType ?? throw new ArgumentNullException(nameof(dbContextType));
    }

    public async Task<bool> Handle(UserByUserNameExistsQuery request, CancellationToken cancellationToken)
    {
        if (request == null)
        {
            throw new ArgumentNullException(nameof(request));
        }

        var itemExists = await dbContextType.AppUsers
            .AsNoTracking()
            .AnyAsync(m => m.UserName == request.NameProperty, cancellationToken);

        return itemExists;
    }
}
