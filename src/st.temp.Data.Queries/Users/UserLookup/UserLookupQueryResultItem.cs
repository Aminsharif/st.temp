namespace st.temp.Data.Queries.Users.UserLookup;

using System;

public class UserLookupQueryResultItem
{
    public Guid Id { get; set; }

    public string UserName { get; set; }

    public string Password { get; set; }

    public string UserRole { get; set; }

    public string CreatedBy { get; set; }

    public DateTime Created { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? LastUpdated { get; set; }
}
