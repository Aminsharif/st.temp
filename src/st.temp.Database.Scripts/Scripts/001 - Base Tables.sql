Create TABLE KeyingSystems
(
    Id                   uniqueidentifier not null primary key,
    KeyingSystemKind     nvarchar(255)    not null, 
    KeyingSystemTypeName nvarchar(255)    not null, 
    KeyingSystemNumber   nvarchar(255) unique,      
    CreatedBy            nvarchar(255)    not null,
    Created              datetime2        not null,
    UpdatedBy            nvarchar(255),
    LastUpdated          datetime2,
)

Create TABLE Orders
(
    Id                  uniqueidentifier not null primary key,
    KeyingSystemId      uniqueidentifier not null foreign key references KeyingSystems,
    OrderNumber         int              not null default 0,
    OrderNumberProAlpha nvarchar(255),
    CustomerIdProAlpha  nvarchar(255),
    Note                nvarchar(max),
    ShipmentDate        datetime2,
    DesiredShipmentDate datetime2,
    OrderType           nvarchar(255)    not null,
    CreatedBy           nvarchar(255)    not null,
    Created             datetime2        not null,
    UpdatedBy           nvarchar(255),
    LastUpdated         datetime2,
)