namespace st.temp.Data.Commands.Users.Delete;

using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.EntityFrameworkCore;
using st.temp.Common.Exceptions;

public class DeletUserCommandHandler : IRequestHandler<DeleteUserCommand>
{
  private readonly DemoDbContext dbContext;

  public DeletUserCommandHandler(DemoDbContext dbContext)
  {
    this.dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
  }

  public async Task<Unit> Handle(DeleteUserCommand command, CancellationToken cancellationToken)
  {
    if (command == null)
    {
      throw new ArgumentNullException(nameof(command));
    }

    var target =
      await this.dbContext.AppUsers.SingleOrDefaultAsync(
        c => c.Id == command.Id,
        cancellationToken: cancellationToken);
    if (target == null)
    {
      throw new InvalidCommandException();
    }

    this.dbContext.AppUsers.Remove(target);

    await this.dbContext.SaveChangesAsync(cancellationToken);

    return Unit.Value;
  }
}
