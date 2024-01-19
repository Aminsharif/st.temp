namespace st.temp.Data.Queries.Users.UserByIdExists;

using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.EntityFrameworkCore;

public class UserByIdExistsQueryHandler : IRequestHandler<UserByIdExistsQuery, bool>
{
    private readonly DemoDbContext dbContextType;

    public UserByIdExistsQueryHandler(DemoDbContext dbContextType)
    {
        this.dbContextType = dbContextType ?? throw new ArgumentNullException(nameof(dbContextType));
    }

    public async Task<bool> Handle(UserByIdExistsQuery request, CancellationToken cancellationToken)
    {
        if (request == null)
        {
            throw new ArgumentNullException(nameof(request));
        }

        var itemExists = await dbContextType.AppUsers
            .AsNoTracking()
            .AnyAsync(m => m.Id == request.UserId, cancellationToken);

        return itemExists;
    }
}
