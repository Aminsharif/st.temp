namespace st.temp.Data.Commands.Users.Delete;

using System;
using MediatR;

public class DeleteUserCommand : IRequest
{
  public DeleteUserCommand(Guid id)
  {
    this.Id = id;
  }

  public Guid Id { get; }
}
