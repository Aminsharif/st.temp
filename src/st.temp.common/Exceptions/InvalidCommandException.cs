namespace st.temp.Common.Exceptions;

using System;

public class InvalidCommandException : Exception
{
  public InvalidCommandException(string message)
    : base(message)
  {
  }

  public InvalidCommandException(string message, Exception innerException)
    : base(message, innerException)
  {
  }

  public InvalidCommandException()
  {
  }
}