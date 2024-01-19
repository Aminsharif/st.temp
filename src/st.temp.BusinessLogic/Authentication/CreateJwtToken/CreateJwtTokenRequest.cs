namespace st.temp.BusinessLogic.Authentication.CreateJwtToken;

using System;
using System.Collections.Generic;
using MediatR;

public class CreateJwtTokenRequest : IRequest<CreateJwtTokenResponse>
{
  public CreateJwtTokenRequest(string username)
  {
    this.Username = username;
  }

  public string Username { get; set; }

  public IEnumerable<string> UserRoles { get; set; }

  public DateTime? ExpiresOn { get; set; }
}