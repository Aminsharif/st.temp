namespace st.temp.WebAPI.Controllers.v1.Accounts.Login.Post;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Http;

public class LoginRequestDtoValidator : AbstractValidator<LoginRequestDto>
{
  public LoginRequestDtoValidator(IHttpContextAccessor httpContextAccessor)
  {
    this
      .RuleFor(c => c.Username)
      .NotEmpty();

    this
      .RuleFor(c => c.Password)
      .NotEmpty();
  }
}
