create schema EventFeed
GO

Create table EventFeed.EventFeedEntries
(
    Id               int           not null primary key identity,
    EventName        nvarchar(255) not null,
    EventArgs        nvarchar(max) not null,
    EventUnixSeconds bigint    default DATEDIFF(SECOND, '1970-01-01', GETUTCDATE()),
    EventDateTime    datetime2 default GETUTCDATE(),
)
Go

Alter Table EventFeed.EventFeedEntries
    add CONSTRAINT Constraint_EventFeed_Events_Is_Json Check (ISJSON(EventArgs) = 1)
Go