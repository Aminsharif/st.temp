namespace st.temp.Data;

using System;

public class KeyingSystem
{
  public KeyingSystem()
  {
 
  }

  public string KeyingSystemKind { get; set; }

  public Guid Id { get; set; }

  public string KeyingSystemNumber { get; set; }

  public string KeyingSystemTypeName { get; set; }

  public string CreatedBy { get; set; }

  public DateTime Created { get; set; }

  public string UpdatedBy { get; set; }

  public DateTime? LastUpdated { get; set; }

}
