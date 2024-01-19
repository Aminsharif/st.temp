namespace st.temp.WebAPI.Controllers.v1.Accounts.Users.Patch;
using FluentValidation;

public class UpdateUserRequestDtoValidator : AbstractValidator<UpdateUserRequestDto>
{
  public UpdateUserRequestDtoValidator()
  {
    this.RuleFor(dto => dto.UserName)
      .NotEmpty()
      .WithMessage("UserName is required");
    this.RuleFor(dto => dto.UserRole)
     .NotEmpty()
     .WithMessage("UserRole is required");
  }
}
