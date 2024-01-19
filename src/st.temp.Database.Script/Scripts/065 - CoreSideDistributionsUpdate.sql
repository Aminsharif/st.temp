CREATE TABLE CoreSideDistributions
(
    Id                       uniqueidentifier not null primary key,
    OrderId                  uniqueidentifier NOT NULL references Orders,
    DeliveryDateTypeId       uniqueidentifier NOT NULL references DeliveryDateTypes,
    DeliveryDate             date             not null default GETUTCDATE(),
    CoreSide                 decimal(10, 2)   not null default 0,
    PoolReservationStartDate date             not null,
    PoolReservationEndDate   date             not null,
    TotalDlz                 decimal(10, 2)   not null default 0,
    FactorValue              decimal(10, 2)   not null default 1,
    StartDateCoreSide        decimal(10, 2)   not null default 0,
    EndDateCoreSide          decimal(10, 2)   not null default 0,
    CreatedBy                nvarchar(255)    not null,
    Created                  datetime2        not null default GETUTCDATE(),
    UpdatedBy                nvarchar(255),
    LastUpdated              datetime2,
)
GO
