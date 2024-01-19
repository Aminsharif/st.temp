Create TABLE KeyingSystems
(
    Id                   uniqueidentifier not null primary key,
    KeyingSystemKind     nvarchar(255)    not null, -- Anlagenart
    KeyingSystemTypeName nvarchar(255)    not null, -- Anlagensystem
    KeyingSystemNumber   nvarchar(255) unique,      -- Anlagennummer
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
GO
ALTER TABLE Orders
    ADD CONSTRAINT UQ_KeyingSystemId_OrderNumber_Orders UNIQUE (KeyingSystemId, OrderNumber)
GO

GO
Create TABLE CylinderEntries
(
    Id             uniqueidentifier not null primary key,
    OrderId        uniqueidentifier not null foreign key references Orders,
    KeyingSystemId uniqueidentifier not null foreign key references KeyingSystems,
    LockingNumber  nvarchar(255),
    DoorNumber     nvarchar(255),
    Description    nvarchar(255),
    CylindersCount int,
    KeysCount      int,
    BackSet        int,
    ProductNumber  nvarchar(255),
    LengthA        int,
    LengthB        int,
    Color          nvarchar(255),
    CreatedBy      nvarchar(255)    not null,
    Created        datetime2        not null,
    UpdatedBy      nvarchar(255),
    LastUpdated    datetime2,
    Price          decimal(10, 2)   not null default 0
)