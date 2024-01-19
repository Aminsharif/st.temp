CREATE TABLE DlzMaintenances
(
    Id                    uniqueidentifier not null primary key,
    KeyingSystemTypeId    uniqueidentifier NOT NULL foreign key REFERENCES dbo.KeyingSystemTypes (Id),
    MinKeyQuantity        int              NOT NULL DEFAULT 0,
    MaxKeyQuantity        int              NOT NULL DEFAULT 0,
    MinCylinderQuantity   int              NOT NULL DEFAULT 0,
    MaxCylinderQuantity   int              NOT NULL DEFAULT 0,
    Dlz                   decimal(10, 2)   not null default 0,
    CreatedBy             nvarchar(255)    not null,
    Created               datetime2        not null default GETUTCDATE(),
    UpdatedBy             nvarchar(255),
    LastUpdated           datetime2, 
    )
GO
