namespace st.temp.Data.Queries.Users.UserById;

using AutoMapper;
using MediatR;
using Microsoft.EntityFrameworkCore;
using st.temp.Common.Exceptions;
using System;
using System.Threading;
using System.Threading.Tasks;

public class UserByIdQueryHandler : IRequestHandler<UserByIdQuery, UserByIdQueryResult>
{
    private readonly DemoDbContext dbContext;
    private readonly IMapper mapper;

    public UserByIdQueryHandler(DemoDbContext dbContextType, IMapper mapper)
    {
        this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
        dbContext = dbContextType ?? throw new ArgumentNullException(nameof(dbContextType));
    }

    public async Task<UserByIdQueryResult> Handle(
      UserByIdQuery query,
      CancellationToken cancellationToken)
    {
        if (query == null)
        {
            throw new ArgumentNullException(nameof(query));
        }

        var result = await dbContext.AppUsers
            .SingleOrDefaultAsync(ls => ls.Id == query.UserId, cancellationToken);

        if (result == null)
        {
            throw new InvalidQueryException();
        }

        return mapper.Map<UserByIdQueryResult>(result);
    }
}
