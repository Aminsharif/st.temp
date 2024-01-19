namespace st.temp.Common.Configuration;

public class ActiveDirectoryConfiguration
{
  public string Domain { get; set; }

  public bool OverrideAuthentication { get; set; }

  public string AdUsername { get; set; }

  public string AdPassword { get; set; }

  public string ADReaderRoleName { get; set; }

  public string ADWriterRoleName { get; set; }

  public string ADCalculatorRoleName { get; set; }
}