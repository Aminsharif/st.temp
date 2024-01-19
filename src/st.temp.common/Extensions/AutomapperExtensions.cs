namespace st.temp.Common.Extensions;

using System;
using System.Linq.Expressions;
using AutoMapper;

public static class AutomapperExtensions
{
  public static IMappingExpression<TSource, TDestination> IgnoreOnDestination<TSource, TDestination, TIgnore>(
    this IMappingExpression<TSource, TDestination> mappingExpression,
    Expression<Func<TDestination, TIgnore>> memberExpression)
  {
    if (mappingExpression == null)
    {
      throw new ArgumentNullException(nameof(mappingExpression));
    }

    return mappingExpression.ForMember(memberExpression, e => e.Ignore());
  }
}
