Create table OrderComments
(
    Id             uniqueidentifier not null primary key,
    KeyingSystemId uniqueidentifier not null constraint FK_OrderComments_KeyingSystems references KeyingSystems,
    OrderId        uniqueidentifier constraint FK_OrderComments_Orders references Orders,
    CommentText    nvarchar(max),
    CommentType    int              not null,
    PrintType      int              not null,
    CreatedBy      nvarchar(255)    not null,
    Created        datetime2        not null default GETUTCDATE(),
    UpdatedBy      nvarchar(255),
    LastUpdated    datetime2,
    PeriodStart    datetime2        not null default '9999-12-31T23:59:59.9999999',
    PeriodEnd      datetime2        NOT NULL DEFAULT '0001-01-01T00:00:00.0000000',
)

GO

ALTER TABLE [OrderComments] ADD PERIOD FOR SYSTEM_TIME ([PeriodStart], [PeriodEnd])

ALTER TABLE OrderComments ALTER COLUMN [PeriodStart] ADD HIDDEN
ALTER TABLE OrderComments ALTER COLUMN [PeriodEnd] ADD HIDDEN

Go 
DECLARE @historyTableSchema sysname = SCHEMA_NAME()
EXEC(N'ALTER TABLE [OrderComments] SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [' + @historyTableSchema + '].[OrderCommentsHistory]))')