namespace st.temp.WebAPI.Controllers.v1.Accounts.Login.Post;

using AutoMapper;
using BusinessLogic.Authentication.Login;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using st.temp.WebAPI.Authentication;
using System;
using System.Threading.Tasks;

[ApiController]
[Route("api/v1/accounts")]
[ApiExplorerSettings(GroupName = "Account Operations")]
public class LoginController : ControllerBase
{
  private readonly IMediator mediator;
  private readonly IMapper mapper;

  public LoginController(IMediator mediator, IMapper mapper)
  {
    this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
    this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
  }

  [HttpPost("login")]
  [AllowAnonymous]
  [ProducesResponseType(StatusCodes.Status200OK)]
  [ProducesResponseType(StatusCodes.Status401Unauthorized)]
  public async Task<ActionResult<LoginResponseDto>> Login(LoginRequestDto loginRequestDto)
  {
    var loginRequest = this.mapper.Map<LoginRequest>(loginRequestDto);
    var loginResponse = await this.mediator.Send(loginRequest);

    if (!loginResponse.WasSuccess)
    {
      return this.Unauthorized();
    }

    return this.mapper.Map<LoginResponseDto>(loginResponse);
  }
}
