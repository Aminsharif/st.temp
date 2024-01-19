namespace st.temp.WebAPI.Controllers.v1.v1.Accounts.Users.Get;

using System.Collections.Generic;

public class LookupUserResponseDto
{
  public IEnumerable<LookupUserResponseItemDto> Items { get; set; }
}
