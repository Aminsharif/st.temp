namespace st.temp.Data.Commands.Users.Create;

using System;
using System.ComponentModel.DataAnnotations;
using MediatR;

public class CreateUserCommand : IRequest<Guid>
{
  public CreateUserCommand()
  {
  }
    public string UserName { get; set; }

    [DataType(DataType.Password)]
    public string Password { get; set; }

    public string UserRole { get; set; }

    public string CreatedBy { get; set; }

    public DateTime Created { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? LastUpdated { get; set; }
}

