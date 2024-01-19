namespace st.temp.Common.Exceptions;

using System;

public class InvalidQueryException : Exception
{
  public InvalidQueryException(string message)
    : base(message)
  {
  }

  public InvalidQueryException()
  {
  }

  public InvalidQueryException(string message, Exception innerException)
    : base(message, innerException)
  {
  }
}