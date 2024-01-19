namespace st.temp.Data.Queries.Users.UserByUserName;

using AutoMapper;
using MediatR;
using Microsoft.EntityFrameworkCore;
using st.temp.Common.Exceptions;
using System;
using System.Threading;
using System.Threading.Tasks;

public class UserByUserNameQueryHandler : IRequestHandler<UserByUserNameQuery, UserByUserNameQueryResult>
{
    private readonly DemoDbContext dbContext;
    private readonly IMapper mapper;

    public UserByUserNameQueryHandler(DemoDbContext dbContextType, IMapper mapper)
    {
        this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
        dbContext = dbContextType ?? throw new ArgumentNullException(nameof(dbContextType));
    }

    public async Task<UserByUserNameQueryResult> Handle(
      UserByUserNameQuery query,
      CancellationToken cancellationToken)
    {
        if (query == null)
        {
            throw new ArgumentNullException(nameof(query));
        }

        var result = await dbContext.AppUsers
            .AsNoTracking()
            .SingleOrDefaultAsync(ls => ls.UserName == query.Username, cancellationToken);

        if (result == null)
        {
            throw new InvalidQueryException();
        }

        return mapper.Map<UserByUserNameQueryResult>(result);
    }
}
