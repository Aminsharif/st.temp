Alter table DomainEvents.ProcessedEvents
    drop column EventId, EventUnixSeconds
GO

Alter table DomainEvents.ProcessedEvents
    add
        Domain nvarchar(255) not null default 'Unknown',
        ReferenceId UNIQUEIDENTIFIER not null default '00000000-0000-0000-0000-000000000000'

Go

EXEC sp_rename 'DomainEvents.ProcessedEvents.WorkerName', 'HandlerName', 'COLUMN';

Go

alter view vwLoggedEvents as
    With LoggedEvents as (SELECT pe.Id          ProcessedEventId,
                                 pe.HandlerName,
                                 pe.EventName,
                                 pe.ReferenceId OrderId,
                                 pe.ProcessingAt,
                                 pe.ProcessedAt,
                                 pe.OperationResult,
                                 le.Id          LogEntryId,
                                 le.Created     LogEntryCreated,
                                 le.Message     LogEntryMessage
                          From DomainEvents.ProcessedEvents pe
                                   left outer join [ProductConfigurator].[Logs] le on pe.Id = le.ProcessedEventId
                          where pe.Domain = 'Order')
    select LoggedEvents.*, o.OrderNumber, ks.Id KeyingSystemId, ks.KeyingSystemNumber
    from LoggedEvents
             left outer join Orders o on LoggedEvents.OrderId = o.Id
             left outer join KeyingSystems ks on o.KeyingSystemId = ks.Id
Go
Drop Table EventFeed.EventFeedEntries

GO
Drop SCHEMA EventFeed