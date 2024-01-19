namespace st.temp.BusinessLogic.Authentication.UserInfo;

using Common.Exceptions;
using MediatR;
using st.temp.Data.Queries.Users.UserByUserName;
using st.temp.Data.Queries.Users.UserByUserNameExists;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

public class UserInfoRequestHandler : IRequestHandler<UserInfoRequest, UserInfoResponse>
{
    private readonly IMediator mediator;

    public UserInfoRequestHandler(IMediator mediator)
    {
        this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
    }

  public async Task<UserInfoResponse> Handle(UserInfoRequest request, CancellationToken cancellationToken)
  {
    if (request == null)
    {
      throw new ArgumentNullException(nameof(request));
    }

    if (!await this.mediator.Send(new UserByUserNameExistsQuery(request.Username), cancellationToken))
    {
       throw new RequestHandlerException("user Name does not exit");
    }

    var user = await this.mediator.Send(new UserByUserNameQuery(request.Username), cancellationToken);

    //find user role then add this in userRoles property, In current case user roll exist in user table
    //current case uses single role but we can use multiple role
    var userRoles = new HashSet<string>
    {
      user.UserRole
    };
    var userInfoResponse = new UserInfoResponse(user.UserName)
    {
       UserRoles = userRoles,
      DisplayName = user.UserName,
    };

    return await Task.FromResult(userInfoResponse);
  }
}
