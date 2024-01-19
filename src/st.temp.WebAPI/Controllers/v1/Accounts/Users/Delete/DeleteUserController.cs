namespace st.temp.WebAPI.Controllers.v1.DeliveryDateDetermination.DlzMaintenances.Delete;

using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using st.temp.Data.Commands.Users.Delete;
using st.temp.Data.Queries.Users.UserByIdExists;
using st.temp.WebAPI.Authentication;
using System;
using System.Threading.Tasks;

[ApiController]
[Route("api/v1/Account/Users/")]
[ApiExplorerSettings(GroupName = "User Operations")]
public class DeleteUserController : ControllerBase
{
  private readonly IMediator mediator;

  public DeleteUserController(IMediator mediator)
  {
    this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
  }

  [Authorize(Policy = PolicyName.AuthenticatedWriter)]
  [HttpDelete("{userId:guid}")]
  [ProducesResponseType(StatusCodes.Status204NoContent)]
  [ProducesResponseType(StatusCodes.Status404NotFound)]
  public async Task<IActionResult> DeleteDlzMaintenance([FromRoute] Guid userId)
  {
    if (!await this.mediator.Send(new UserByIdExistsQuery(userId)))
    {
      return this.NotFound();
    }

    var request = new DeleteUserCommand(userId);
    await this.mediator.Send(request);
    return this.NoContent();
  }
}
