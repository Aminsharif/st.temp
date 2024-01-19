namespace st.temp.Data.Commands.Users.Update;

using System;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using MediatR;
using Microsoft.EntityFrameworkCore;
using st.temp.common;
using st.temp.Common;
using st.temp.Common.Exceptions;
using st.temp.Common.Extensions;

public class UpdateUserCommandHandler : IRequestHandler<UpdateUserCommand>
{
  private readonly IMapper mapper;
  private readonly DemoDbContext dbContext;
  private readonly ICurrentUserInfo currentUserInfo;

  public UpdateUserCommandHandler(DemoDbContext dbContext, IMapper mapper, ICurrentUserInfo currentUserInfo)
  {
    this.dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
    this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
    this.currentUserInfo = currentUserInfo ?? throw new ArgumentNullException(nameof(currentUserInfo));
  }

  public async Task<Unit> Handle(UpdateUserCommand command, CancellationToken cancellationToken)
  {
    if (command == null)
    {
      throw new ArgumentNullException(nameof(command));
    }

    var target =
      await this.dbContext.AppUsers
        .SingleOrDefaultAsync(
          c => c.Id == command.Id,
          cancellationToken: cancellationToken);
    if (target == null)
    {
      throw new InvalidCommandException();
    }

    this.mapper.Map(command, target);
    this.currentUserInfo.SetUpdated(target);
    await this.dbContext.SaveChangesAsync(cancellationToken);

    return Unit.Value;
  }
}
