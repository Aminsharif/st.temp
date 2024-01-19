Create view vwLoggedEvents as
With LoggedEvents as (SELECT evt.Id                                                       EventId,
                             evt.EventName                                                EventName,
                             cast(JSON_Value(EventArgs, '$.OrderId') as uniqueidentifier) OrderId,
                             evt.EventDateTime,
                             pe.WorkerName                                                ProcessingWorkerName,
                             pe.ProcessingAt,
                             pe.ProcessedAt,
                             pe.OperationResult,
                             le.Id                                                        LogEntryId,
                             le.Created                                                   LogEntryCreated,
                             le.Message                                                   LogEntryMessage
                      From DomainEvents.ProcessedEvents pe
                               left outer join EventFeed.EventFeedEntries evt on pe.EventId = evt.Id
                               left outer join [ProductConfigurator].[Logs] le on pe.Id = le.ProcessedEventId)
select LoggedEvents.*, o.OrderNumber, ks.Id KeyingSystemId, ks.KeyingSystemNumber
from LoggedEvents
         left outer join Orders o on LoggedEvents.OrderId = o.Id
         left outer join KeyingSystems ks on o.KeyingSystemId = ks.Id
Go