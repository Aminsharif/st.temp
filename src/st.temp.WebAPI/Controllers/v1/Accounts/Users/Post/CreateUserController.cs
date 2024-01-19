namespace st.temp.WebAPI.Controllers.v1.Accounts.Users.Post;

using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using st.temp.Data.Commands.Users.Create;
using st.temp.WebAPI.Authentication;
using System;
using System.Threading.Tasks;

[ApiController]
[Route("api/v1/Account/Users/")]
[ApiExplorerSettings(GroupName = "User Operations")]
public class CreateUserController : ControllerBase
{
  private readonly IMapper mapper;
  private readonly IMediator mediator;

  public CreateUserController(IMapper mapper, IMediator mediator)
  {
    this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
    this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
  }

  [Authorize(PolicyName.AuthenticatedWriter)]
  [HttpPost]
  [ProducesResponseType(typeof(CreateUserResponseDto), StatusCodes.Status201Created)]
  public async Task<ActionResult<CreateUserResponseDto>> CreateDlzMaintenance(
    CreateUserRequestDto requestDto)
  {
    if (requestDto == null)
    {
      throw new ArgumentNullException(nameof(requestDto));
    }

    var request = new CreateUserCommand();
    var command = this.mapper.Map(requestDto, request);
    var response = await this.mediator.Send(command);
    var responseDto = new CreateUserResponseDto()
    {
      UserId = response,
    };

    return this.Created(string.Empty, responseDto);
  }
}
