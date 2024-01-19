namespace st.temp.WebAPI.Controllers.v1.Accounts.Users.Patch;

using AutoMapper;
using FluentValidation;
using FluentValidation.AspNetCore;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc;
using st.temp.Data.Commands.Users.Update;
using st.temp.Data.Queries.Users.UserById;
using st.temp.Data.Queries.Users.UserByIdExists;
using st.temp.WebAPI.Authentication;
using System;
using System.Threading.Tasks;

[ApiController]
[Route("api/v1/Account/Users/")]
[ApiExplorerSettings(GroupName = "User Operations")]
public class UpdateUserController : ControllerBase
{
  private readonly IMapper mapper;
  private readonly IValidator<UpdateUserRequestDto> validator;
  private readonly IMediator mediator;

  public UpdateUserController(
    IMediator mediator,
    IMapper mapper,
    IValidator<UpdateUserRequestDto> validator)
  {
    this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
    this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
    this.validator = validator;
  }

  [Authorize(Policy = PolicyName.AuthenticatedWriter)]
  [HttpPatch("{userId:guid}")]
  [ProducesResponseType(StatusCodes.Status204NoContent)]
  [ProducesResponseType(StatusCodes.Status404NotFound)]
  [ProducesResponseType(StatusCodes.Status401Unauthorized)]
  [ProducesResponseType(StatusCodes.Status403Forbidden)]
  public async Task<IActionResult> UpdateDlzMaintenance(
    [FromRoute] Guid userId,
    [FromBody] JsonPatchDocument<UpdateUserRequestDto> patchDocument)
  {
    if (patchDocument == null)
    {
      throw new ArgumentNullException(nameof(patchDocument));
    }

    if (!await this.mediator.Send(new UserByIdExistsQuery(userId)))
    {
      return this.NotFound();
    }

    var originalItem = await this.mediator.Send(new UserByIdQuery(userId));
    var requestDto = this.mapper.Map<UpdateUserRequestDto>(originalItem);
    patchDocument.ApplyTo(requestDto);

    var validationResult = await this.validator.ValidateAsync(requestDto);
    validationResult.AddToModelState(this.ModelState, string.Empty);
    if (!this.ModelState.IsValid)
    {
      return this.BadRequest(this.ModelState);
    }

    var request = new UpdateUserCommand(userId);
    this.mapper.Map(requestDto, request);
    await this.mediator.Send(request);
    return this.NoContent();
  }
}
