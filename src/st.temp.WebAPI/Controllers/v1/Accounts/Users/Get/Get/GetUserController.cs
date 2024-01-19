namespace st.temp.WebAPI.Controllers.v1.Accounts.User.Get.Get;

using Authentication;
using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using st.temp.Data.Queries.Users.UserById;
using st.temp.Data.Queries.Users.UserByIdExists;
using System;
using System.Threading.Tasks;

[ApiController]
[Route("api/v1/Account/Users/")]
[ApiExplorerSettings(GroupName = "User Operations")]
public class GetUserController : ControllerBase
{
  private readonly IMapper mapper;
  private readonly IMediator mediator;

  public GetUserController(IMediator mediator, IMapper mapper)
  {
    this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
    this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
  }

  [Authorize(Policy = PolicyName.AuthenticatedReader)]
  [HttpGet("{userId:guid}")]
  [ProducesResponseType(typeof(GetUserResponseDto), StatusCodes.Status200OK)]
  [ProducesResponseType(StatusCodes.Status404NotFound)]
  [ProducesResponseType(StatusCodes.Status401Unauthorized)]
  [ProducesResponseType(StatusCodes.Status403Forbidden)]
  public async Task<ActionResult<GetUserResponseDto>> GetDlzMaintenance([FromRoute] Guid userId)
  {
    if (!await this.mediator.Send(new UserByIdExistsQuery(userId)))
    {
      return this.NotFound();
    }

    var dlzMaintenanceQuery = new UserByIdQuery(userId);
    var dlzMaintenanceResponse = await this.mediator.Send(dlzMaintenanceQuery);
    var responseDto = this.mapper.Map<GetUserResponseDto>(dlzMaintenanceResponse);

    return this.Ok(responseDto);
  }
}
