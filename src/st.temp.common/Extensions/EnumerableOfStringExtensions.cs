namespace st.temp.Common.Extensions;

using System;
using System.Collections.Generic;
using System.Linq;

public static class EnumerableOfStringExtensions
{
  public static string ConcatToString(this IEnumerable<string> values, string delimiter = ",")
  {
    return values.ConcatToString(s => s, delimiter: delimiter);
  }

  public static string ConcatToString<TSource>(
    this IEnumerable<TSource> values,
    Func<TSource, string> modifier,
    string initialValue = "",
    string delimiter = " ")
  {
    if (values == null)
    {
      throw new ArgumentNullException(nameof(values));
    }

    if (modifier == null)
    {
      throw new ArgumentNullException(nameof(modifier));
    }

    return values.Aggregate(
      initialValue,
      (current, next) => current + (current == initialValue ? null : delimiter) + modifier(next));
  }

  public static string ToPascalCase(this string s)
  {
    if (s == null)
    {
      throw new ArgumentNullException(nameof(s));
    }

    return s[..1].ToUpper() + s[1..];
  }
}
