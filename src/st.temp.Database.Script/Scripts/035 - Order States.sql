create table OrderStates
(
    Id        uniqueidentifier not null primary key,
    OrderId   uniqueidentifier not null foreign key references Orders,
    Value     int              not null,
    Created   datetime2        not null default GETUTCDATE(),
    CreatedBy nvarchar(255)    not null
)
GO

-- Migrate orders

insert into OrderStates (Id, OrderId, Value, CreatedBy)
select newid(), o.Id, 0, o.CreatedBy
from Orders o
Go