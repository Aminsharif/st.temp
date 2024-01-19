namespace st.temp.WebAPI.Controllers.v1.Accounts.Users.Post;

using FluentValidation;

public class CreateUserRequestDtoValidator : AbstractValidator<CreateUserRequestDto>
{
  public CreateUserRequestDtoValidator()
  {
    this.RuleFor(dto => dto.UserName)
      .NotEmpty()
      .WithMessage("UserName is required");
    this.RuleFor(dto => dto.Password)
     .NotEmpty()
     .WithMessage("Password is required");
    this.RuleFor(dto => dto.UserRole)
     .NotEmpty()
     .WithMessage("UserRole is required");
  }
}
