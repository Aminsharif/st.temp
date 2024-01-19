namespace st.temp.Common.Exceptions;

using System;

public class WorkflowException : Exception
{
  public WorkflowException(string message)
    : base(message)
  {
  }

  public WorkflowException(string message, Exception innerException)
    : base(message, innerException)
  {
  }

  public WorkflowException()
  {
  }
}