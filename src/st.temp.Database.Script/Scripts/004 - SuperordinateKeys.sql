Create TABLE SuperordinateKeys
(
    Id             uniqueidentifier not null primary key,
    OrderId        uniqueidentifier not null foreign key references Orders,
    KeyingSystemId uniqueidentifier not null foreign key references KeyingSystems,
    [Key]          nvarchar(255)    not null,
    KeysCount      int              not null,
    Position       int              not null,
    ProductNumber  nvarchar(255),
    [Description]  nvarchar(255),
    Price          decimal(10, 2)   not null default 0,
    CreatedBy      nvarchar(255)    not null,
    Created        datetime2        not null,
    UpdatedBy      nvarchar(255),
    LastUpdated    datetime2,
)



