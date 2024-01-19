namespace st.temp.WebAPI.Controllers.v1.v1.Accounts.Users.Get;

using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using st.temp.Data.Queries.Users.UserLookup;
using st.temp.WebAPI.Authentication;
using System;
using System.Threading.Tasks;

[ApiController]
[Route("api/v1/Account/Users/")]
[ApiExplorerSettings(GroupName = "User Operations")]
public class LookupUserController : ControllerBase
{
  private readonly IMediator mediator;
  private readonly IMapper mapper;

  public LookupUserController(IMediator mediator, IMapper mapper)
  {
    this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
    this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
  }

  [Authorize(Policy = PolicyName.AuthenticatedReader)]
  [HttpGet]
  [ProducesResponseType(typeof(LookupUserResponseDto), StatusCodes.Status200OK)]
  [ProducesResponseType(StatusCodes.Status200OK)]
  [ProducesResponseType(StatusCodes.Status404NotFound)]
  [ProducesResponseType(StatusCodes.Status401Unauthorized)]
  [ProducesResponseType(StatusCodes.Status403Forbidden)]
  public async Task<ActionResult<LookupUserResponseDto>> LookupDlzMaintenances(
    [FromQuery] int offset = 0,
    [FromQuery] int limit = 25)
  {
    if (limit <= 0)
    {
      return this.BadRequest();
    }

    var request = new UserLookupQuery
    {
      Offset = offset,
      Limit = limit,
    };
    var response = await this.mediator.Send(request);
    var responseDto = this.mapper.Map<LookupUserResponseDto>(response);
    return this.Ok(responseDto);
  }
}
