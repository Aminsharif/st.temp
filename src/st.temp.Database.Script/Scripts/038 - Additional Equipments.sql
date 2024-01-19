Create Table AdditionalEquipments
(
    Id             uniqueidentifier not null primary key,
    Caption        nvarchar(255)    not null,
    Classification nvarchar(255)    not null,
    Created        DATETIME2        not null default GETUTCDATE(),
    CreatedBy      nvarchar(255)    not null,
    LastUpdated    DATETIME2,
    UpdatedBy      nvarchar(255),
)

Create Table AdditionalEquipmentKeyingSystemType
(
    Id                     uniqueidentifier not null primary key default NEWID(),
    AdditionalEquipmentsId uniqueidentifier not null references AdditionalEquipments on delete cascade,
    KeyingSystemTypesId    uniqueidentifier not null references KeyingSystemTypes on delete cascade,
)

ALTER TABLE AdditionalEquipmentKeyingSystemType
    ADD CONSTRAINT UQ_KeyingSystemId_AdditionalEquipmentId_AdditionalEquipmentsToKeyingSystems UNIQUE (AdditionalEquipmentsId, KeyingSystemTypesId)
GO

Create TABLE AdditionalEquipmentEntries
(
    Id                    uniqueidentifier not null primary key,
    AdditionalEquipmentId uniqueidentifier not null foreign key references AdditionalEquipments on delete cascade,
    Caption               nvarchar(255)    not null,
    Characteristic        nvarchar(255)    not null,
    CharacteristicValue   nvarchar(255)    not null,
    IsActive              bit              not null default 1,
    Created               DATETIME2        not null default GETUTCDATE(),
    CreatedBy             nvarchar(255)    not null,
    LastUpdated           DATETIME2,
    UpdatedBy             nvarchar(255),
)

Go

Alter Table CylinderEntries
    add AdditionalEquipmentId uniqueidentifier foreign key references AdditionalEquipments
GO