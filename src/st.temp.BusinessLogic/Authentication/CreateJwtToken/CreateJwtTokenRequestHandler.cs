namespace st.temp.BusinessLogic.Authentication.CreateJwtToken;

using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using Common.Exceptions;
using MediatR;
using Microsoft.IdentityModel.Tokens;

public class CreateJwtTokenRequestHandler : IRequestHandler<CreateJwtTokenRequest, CreateJwtTokenResponse>
{
  private readonly SecurityKey securityKey;

  public CreateJwtTokenRequestHandler(SecurityKey securityKey)
  {
    this.securityKey = securityKey ?? throw new ArgumentNullException(nameof(securityKey));
  }

  public Task<CreateJwtTokenResponse> Handle(CreateJwtTokenRequest request, CancellationToken cancellationToken)
  {
    if (request == null)
    {
      throw new ArgumentNullException(nameof(request));
    }

    if (string.IsNullOrEmpty(request.Username))
    {
      throw new RequestHandlerException();
    }

    var claims = new List<Claim>
    {
      new Claim(ClaimTypes.Name, request.Username),
    };

    claims.AddRange(request.UserRoles?.Select(userRole => new Claim(ClaimTypes.Role, userRole)) ??
                    Enumerable.Empty<Claim>());

    var token = new JwtSecurityToken(
      claims: claims,
      expires: request.ExpiresOn,
      signingCredentials: new SigningCredentials(this.securityKey, SecurityAlgorithms.HmacSha256));

    var jwtToken = new JwtSecurityTokenHandler().WriteToken(token);
    var response = new CreateJwtTokenResponse(jwtToken);

    return Task.FromResult(response);
  }
}