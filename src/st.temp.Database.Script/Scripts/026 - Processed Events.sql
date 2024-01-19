Create SCHEMA DomainEvents
Go
Create table DomainEvents.ProcessedEvents
(
    Id               uniqueidentifier not null primary key,
    EventName        nvarchar(255)    not null,
    WorkerName       nvarchar(255)    not null,
    EventId          int              not null,
    EventUnixSeconds bigint           not null,
    OperationResult  nvarchar(255),
    ProcessingAt     datetime2 default GETUTCDATE(),
    ProcessedAt      datetime2,
    Message          nvarchar(max)
)
Go