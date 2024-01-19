namespace st.temp.Common.Exceptions;

using System;

public class RequestHandlerException : Exception
{
  public RequestHandlerException(string message)
    : base(message)
  {
  }

  public RequestHandlerException(string message, Exception innerException)
    : base(message, innerException)
  {
  }

  public RequestHandlerException()
  {
  }
}


