namespace Extensions;

using System;
using JetBrains.Annotations;
using Microsoft.Data.SqlClient;

public static class SqlConnectionStringBuilderExt
{
    public static SqlConnectionStringBuilder GetConnectionTo()
    {
        return new SqlConnectionStringBuilder();
    }

    private static SqlConnectionStringBuilder IntegrationEnvironment([NotNull] this SqlConnectionStringBuilder cb)
    {
        if (cb == null)
        {
            throw new ArgumentNullException(nameof(cb));
        }

        cb.DataSource = @"apps\SQLEXPRESS01";
        cb.UserID = "UserId";
        cb.Password = "Password";

        return cb;
    }

    private static SqlConnectionStringBuilder ProductionEnvironment([NotNull] this SqlConnectionStringBuilder cb)
    {
        if (cb == null)
        {
            throw new ArgumentNullException(nameof(cb));
        }

        cb.DataSource = @"app\SQLEXPRESS";
        cb.UserID = @"usrid";
        cb.Password = "Corona-Covid-19";

        return cb;
    }

    public static SqlConnectionStringBuilder LocalDatabase([NotNull] this SqlConnectionStringBuilder cb)
    {
        if (cb == null)
        {
            throw new ArgumentNullException(nameof(cb));
        }

        cb.DataSource = @"(localdb)\MSSQLLocalDB";
        cb.IntegratedSecurity = true;
        cb.InitialCatalog = "OrderProcessing";
        cb.ConnectTimeout = 30;

        return cb;
    }

    public static SqlConnectionStringBuilder DevelopmentDatabase([NotNull] this SqlConnectionStringBuilder cb)
    {
        if (cb == null)
        {
            throw new ArgumentNullException(nameof(cb));
        }

        cb
            .IntegrationEnvironment()
            .InitialCatalog = "OrderProcessing-dev";

        return cb;
    }

    public static SqlConnectionStringBuilder UatDatabase([NotNull] this SqlConnectionStringBuilder cb)
    {
        if (cb == null)
        {
            throw new ArgumentNullException(nameof(cb));
        }

        cb
            .IntegrationEnvironment()
            .InitialCatalog = "OrderProcessing-uat";

        return cb;
    }

    public static SqlConnectionStringBuilder ProductionDatabase([NotNull] this SqlConnectionStringBuilder cb)
    {
        if (cb == null)
        {
            throw new ArgumentNullException(nameof(cb));
        }

        cb
            .IntegrationEnvironment()
            .InitialCatalog = "OrderProcessing-uat";

        return cb;
    }
}