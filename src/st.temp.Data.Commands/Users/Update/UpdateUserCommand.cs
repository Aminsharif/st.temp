namespace st.temp.Data.Commands.Users.Update;

using System;
using System.ComponentModel.DataAnnotations;
using MediatR;

public class UpdateUserCommand : IRequest
{
  public UpdateUserCommand(Guid id)
  {
    this.Id = id;
  }
    public Guid Id { get; set; }

    public string UserName { get; set; }

    public string UserRole { get; set; }

    public string CreatedBy { get; set; }

    public DateTime Created { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? LastUpdated { get; set; }
}
