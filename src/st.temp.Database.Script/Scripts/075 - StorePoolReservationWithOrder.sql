CREATE TABLE StorePoolReservationWithOrders
(
    Id                       uniqueidentifier not null primary key,
    OrderId                  uniqueidentifier NOT NULL references Orders,
    DeliveryDateTypeId       uniqueidentifier NOT NULL references DeliveryDateTypes,
    PoolReservationRangeId   uniqueidentifier NOT NULL foreign key REFERENCES dbo.PoolReservationRanges (Id),
    DailyPoolReservationId   uniqueidentifier NOT NULL foreign key REFERENCES dbo.DailyPoolReservations (Id),
    CalenderDay              date NOT NULL,
    DailyCapacity            decimal(10, 2),
    Booked                   decimal(10, 2),
    OrderWiseBooked          decimal(10, 2),
    CreatedBy                nvarchar(255)    not null,
    Created                  datetime2        not null default GETUTCDATE(),
    UpdatedBy                nvarchar(255),
    LastUpdated              datetime2,
)
GO
