namespace st.temp.Data.Commands.Users.Create;

using AutoMapper;
using MediatR;
using st.temp.common;
using System;
using System.Threading;
using System.Threading.Tasks;

public class CreateUserCommandHandler : IRequestHandler<CreateUserCommand, Guid>
{
  private readonly DemoDbContext dbContext;
  private readonly IMapper mapper;
  private readonly ICurrentUserInfo currentUserInfo;

  public CreateUserCommandHandler(
    DemoDbContext dbContext,
    IMapper mapper,
    ICurrentUserInfo currentUserInfo)
  {
    this.dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
    this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
    this.currentUserInfo = currentUserInfo ?? throw new ArgumentNullException(nameof(currentUserInfo));
  }

  public async Task<Guid> Handle(CreateUserCommand command, CancellationToken cancellationToken)
  {
    if (command == null)
    {
      throw new ArgumentNullException(nameof(command));
    }

    var newItem = this.mapper.Map<AppUser>(command);
    newItem.CreatedBy = this.currentUserInfo.Username;
    this.dbContext.AppUsers.Add(newItem);
    await this.dbContext.SaveChangesAsync(cancellationToken);
    return newItem.Id;
  }
}
