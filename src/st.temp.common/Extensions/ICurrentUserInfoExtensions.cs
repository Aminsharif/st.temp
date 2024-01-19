namespace st.temp.Common.Extensions;

using st.temp.common;
using System;

public static class ICurrentUserInfoExtensions
{
  public static void SetUpdated(this ICurrentUserInfo currentUserInfo, object o)
  {
    if (currentUserInfo == null)
    {
      throw new ArgumentNullException(nameof(currentUserInfo));
    }

    if (o == null)
    {
      throw new ArgumentNullException(nameof(o));
    }

    var d = (dynamic)o;

    var lastUpdatedMemberName = "LastUpdated";
    var updatedByMemberName = "UpdatedBy";

    if (!HasMember(d, lastUpdatedMemberName) || !HasMember(d, updatedByMemberName))
    {
      throw new NotSupportedException(
        $"To set Updated values the target object must supply the member names {lastUpdatedMemberName} and {updatedByMemberName}");
    }

    d.LastUpdated = DateTime.UtcNow;
    d.UpdatedBy = currentUserInfo.Username;
  }

  public static void SetCreated(this ICurrentUserInfo currentUserInfo, object o, bool setCreatedDate = false)
  {
    if (currentUserInfo == null)
    {
      throw new ArgumentNullException(nameof(currentUserInfo));
    }

    if (o == null)
    {
      throw new ArgumentNullException(nameof(o));
    }

    var d = (dynamic)o;

    var createdMemberName = "Created";
    var createdbyMemberName = "CreatedBy";

    if (!HasMember(d, createdMemberName) || !HasMember(d, createdbyMemberName))
    {
      throw new NotSupportedException(
        $"To set Updated values the target object must supply the member names {createdMemberName} and {createdbyMemberName}");
    }

    if (setCreatedDate)
    {
      d.Created = DateTime.UtcNow;
    }

    d.CreatedBy = currentUserInfo.Username;
  }


  private static bool HasMember(object o, string propertyName)
  {
    if (o == null)
    {
      throw new ArgumentNullException(nameof(o));
    }

    return o.GetType().GetProperty(propertyName) != null;
  }
}
