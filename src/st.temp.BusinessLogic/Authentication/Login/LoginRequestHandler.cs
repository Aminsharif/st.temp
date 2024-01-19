namespace st.temp.BusinessLogic.Authentication.Login;

using Authenticate;
using AutoMapper;
using Common.Configuration;
using CreateJwtToken;
using MediatR;
using Microsoft.Extensions.Options;
using st.temp.common;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using UserInfo;

public class LoginRequestHandler : IRequestHandler<LoginRequest, LoginResponse>
{
  private readonly IMapper mapper;
  private readonly IOptions<SessionConfiguration> sessionConfiguration;
  private readonly IMediator mediator;

  public LoginRequestHandler(IMediator mediator, IMapper mapper, IOptions<SessionConfiguration> sessionConfiguration)
  {
    this.mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
    this.mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
    this.sessionConfiguration = sessionConfiguration;
  }

  public async Task<LoginResponse> Handle(LoginRequest request, CancellationToken cancellationToken)
  {
    if (request == null)
    {
      throw new ArgumentNullException(nameof(request));
    }

    var loginResponse = new LoginResponse();

    var credentialsValidRequest = this.mapper.Map<CredentialsValidRequest>(request);

    if (await this.mediator.Send(credentialsValidRequest, cancellationToken))
    {
      var userInfo = await this.mediator.Send(new UserInfoRequest(request.Username), cancellationToken);

      // If either Reader nor Writer Group has been configure for user authentication fails
      if (
        userInfo.UserRoles == null ||
        (!userInfo.UserRoles.Contains(UserRoleNames.AMReader)
         && !userInfo.UserRoles.Contains(UserRoleNames.AMWriter)))
      {
        return loginResponse;
      }

      var createTokenRequest = new CreateJwtTokenRequest(userInfo.Username)
      {
        UserRoles = userInfo.UserRoles,
        ExpiresOn = DateTime.Now.AddMinutes(this.sessionConfiguration.Value.SessionLengthInMinutes),
      };
      var createTokenResponse = await this.mediator.Send(createTokenRequest, cancellationToken);

      loginResponse.WasSuccess = true;
      loginResponse.JwtToken = createTokenResponse.JwtToken;
    }

    return loginResponse;
  }
}