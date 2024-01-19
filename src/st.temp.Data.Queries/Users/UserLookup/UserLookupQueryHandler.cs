namespace st.temp.Data.Queries.Users.UserLookup;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using MediatR;
using Microsoft.EntityFrameworkCore;

public class
  UserLookupQueryHandler : IRequestHandler<UserLookupQuery,
    UserLookupQueryResult>
{
    private readonly IMapper mapper;
    private readonly DemoDbContext dbContextType;

    public UserLookupQueryHandler(DemoDbContext dbContextType, IMapper mapper)
    {
        this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
        this.dbContextType = dbContextType ?? throw new ArgumentNullException(nameof(dbContextType));
    }

    public async Task<UserLookupQueryResult> Handle(
      UserLookupQuery query,
      CancellationToken cancellationToken)
    {
        if (query == null)
        {
            throw new ArgumentNullException(nameof(query));
        }

        var result = await dbContextType.AppUsers
            .AsNoTracking()
            .OrderBy(o => o.Created)
            .Skip(query.Offset * query.Limit)
            .Take(query.Limit)
            .ToListAsync(cancellationToken: cancellationToken);
        var user = new UserLookupQueryResult
        {
            Items = mapper.Map<IList<UserLookupQueryResultItem>>(result),
        };

        return user;
    }
}
