namespace st.temp.Common;

using st.temp.common;
using System.Collections.Generic;

public class StaticCurrentUserInfo : ICurrentUserInfo
{
    public StaticCurrentUserInfo(string username, params string[] userRole)
    {
        this.UserRoles = userRole;
        this.Username = username;
    }

    public string Username { get; set; }
    public IEnumerable<string> UserRoles { get; set; }
}
