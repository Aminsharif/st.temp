alter table AdditionalEquipments
    drop constraint UQ_AdditionalEquipments_Classification
Go

alter table AdditionalEquipments
    drop column Classification
GO

alter table AdditionalEquipments
    add ClassificationId uniqueidentifier not null
        constraint FK_AdditionalEquipments_Classifications references Classifications default 'C680E296-16C4-49E8-8268-21383695E300'
Go

alter table AdditionalEquipmentEntries
    drop column Characteristic
Go

alter table AdditionalEquipmentEntries
    add CharacteristicId uniqueidentifier not null
        constraint FK_AdditionalEquipments_Characteristics references Characteristics
Go

CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_AdditionalEquipmentEntries
    ON AdditionalEquipmentEntries (AdditionalEquipmentId, CharacteristicId)
GO

alter table Characteristics
    drop column DefaultValue
Go

alter table Characteristics
    add
        CreatedBy nvarchar(255) not null default 'Script',
        Created datetime2 not null default GETUTCDATE(),
        UpdatedBy nvarchar(255),
        LastUpdated datetime2,
        IsDeleted bit not null default 0
Go
drop table CharacteristicClassification
Go
Create Table CharacteristicClassifications
(
    Id                 uniqueidentifier not null primary key default NEWID(),
    ClassificationId   uniqueidentifier not null
        constraint FK_CharacteristicsClassification_Classifications references Classifications on delete cascade,
    CharacteristicId   uniqueidentifier not null
        constraint FK_CharacteristicsClassification_Characteristics references Characteristics on delete cascade,
    KeyingSystemTypeId uniqueidentifier not null
        constraint FK_CharacteristicsClassification_KeyingSystemTypes references KeyingSystemTypes on delete cascade,
    ArticleId          nvarchar(255),
    CustomerId         nvarchar(255),
    DefaultValue       nvarchar(255)    not null
)
Go

CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_CharacteristicClassifications
    ON CharacteristicClassifications (ClassificationId, CharacteristicId, KeyingSystemTypeId, ArticleId, CustomerId)
GO

Insert into Classifications (Id, Caption)
Values ('C680E296-16C4-49E8-8268-21383695E301', N'VKSchlü'),
       ('C680E296-16C4-49E8-8268-21383695E302', N'E-easy'),
       ('C680E296-16C4-49E8-8268-21383695E303', N'E-Zyl'),
       ('C680E296-16C4-49E8-8268-21383695E304', N'E-Beschl')
Go

drop view vwOrders

Go

create view vwOrders as
select ks.KeyingSystemNumber,
       o.Id,
       KeyingSystemId,
       OrderNumber,
       OrderNumberProAlpha,
       CustomerIdProAlpha,
       Note,
       ShipmentDate,
       DesiredShipmentDate,
       OrderType,
       o.CreatedBy,
       o.Created,
       o.UpdatedBy,
       o.LastUpdated,
       o.IsCalculation,
       o.IsFunctionRequest,
       OrderKind,
       OrderDate,
       ShippingAddress_Name1,
       ShippingAddress_Name2,
       ShippingAddress_Street,
       ShippingAddress_HouseNumber,
       ShippingAddress_Country,
       ShippingAddress_City,
       ShippingAddress_PostalCode,
       ShipmentTermsIdProAlpha,
       ShippingMethodIdProAlpha,
       KeyNumberingPrice,
       KeyNumberingType = Case ks.KeyNumberingType
                              When 0 Then 'None'
                              When 1 Then 'Sequential'
                              When 2 Then 'SequentialSuperordinateKey'
                              When 3 Then 'Manual'
           End
from Orders o
         inner join KeyingSystems ks on o.KeyingSystemId = ks.Id

GO

declare @name as nvarchar(255);
SELECT @name = name
FROM dbo.sysobjects
WHERE name LIKE 'FK__CylinderE__Addit%'

IF @name IS NOT NULL
    BEGIN
        EXEC ('ALTER TABLE CylinderEntries DROP CONSTRAINT ' + @name);
    END
Go

Alter table CylinderEntries
    drop column AdditionalEquipmentId

Create Table AdditionalEquipmentCylinderEntry
(
    Id                     uniqueidentifier not null primary key default NEWID(),
    AdditionalEquipmentsId uniqueidentifier not null references AdditionalEquipments on delete cascade,
    CylinderEntriesId      uniqueidentifier not null references CylinderEntries on delete cascade,
)

GO

Alter view vwCylinderEntries as
    select ks.KeyingSystemNumber,
           Locking,
           LengthA,
           LengthB,
           BackSet,
           Color,
           DoorNumber,
           OrderNumber,
           LockwizId,
           KeysCount,
           CylindersCount,
           Price,
           Description,
           PartVariantNumber =
               case ce.PartVariantNumber
                   When 'None' then ce.PartNumber
                   else ce.PartVariantNumber
                   end,
           ae.AdditionalEquipments
    from CylinderEntries ce
             inner join Orders o on ce.OrderId = o.Id
             inner join KeyingSystems ks on ce.KeyingSystemId = ks.Id
             Outer Apply (
        select String_Agg(ae.Caption, N',') AdditionalEquipments
        from AdditionalEquipmentCylinderEntry aec
                 inner join AdditionalEquipments ae on aec.AdditionalEquipmentsId = ae.Id
        where aec.CylinderEntriesId = ce.Id
    ) AE
    where LockwizId is not null
Go

declare @name as nvarchar(255);
SELECT @name = name
FROM dbo.sysobjects
WHERE name LIKE 'UQ__KeyingSy__8CE%'

IF @name IS NOT NULL
    BEGIN
        EXEC ('ALTER TABLE KeyingSystemTypes DROP CONSTRAINT ' + @name);
    END
Go

Alter table KeyingSystemTypes
    add IsLegacy bit not null default 0;
go

insert into KeyingSystemTypes(Id,
                              ProAlphaReferenceForCylinders,
                              ProAlphaReferenceForSuperordinateKeys,
                              Caption,
                              SequenceName,
                              CardCaption)
VALUES (N'08E53D25-D843-4F60-BB56-448E0C16D09B', N'Carat P2-Profil(SKG)', N'Carat P2-Profil(SKG)', N'Carat P2 (SKG)',
        N'Carat_P2', N'Carat P2'),
       (N'08E53D25-D843-4F60-BB56-448E0C16D09C', N'Carat P3-Profil(SKG)', N'Carat P3-Profil(SKG)', N'Carat P3 (SKG)',
        N'Carat_P3', N'Carat P3'),
       (N'08E53D25-D843-4F60-BB56-448E0C16D09D', N'SO - Profil', N'SO Profil', N'SO', N'Standard', N'SO'),
       (N'08E53D25-D843-4F60-BB56-448E0C16D09E', N'System 3VE(SKG)', N'System 3VE(SKG)', N'3VE (SKG)', N'3VE',
        N'3VE-SYSTEM'),
       (N'08E53D25-D843-4F60-BB56-448E0C16D09F', N'ZL - Profil', N'ZL Profil', N'ZL', N'Standard', N'ZL')
Go

insert into KeyingSystemTypes(Id,
                              ProAlphaReferenceForCylinders,
                              ProAlphaReferenceForSuperordinateKeys,
                              Caption,
                              SequenceName,
                              CardCaption, IsLegacy)
Values ('08E53D25-D843-4F60-BB56-448E0C16D190', N'System 3VE(VDS-B)', N'System 3VE(VDS-B)', N'System 3VE(VDS-B)', '3VE',
        '3VE-SYSTEM', 1)


-- 3ve
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD940',
        '08E53D25-D843-4F60-BB56-448E0C16D09E', -- 3VE SKG
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD970', -- GHS
        '3ve SKG GHS')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD940',
        '08E53D25-D843-4F60-BB56-448E0C16D09E', -- 3VE SKG
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD975', -- Sonderprofil
        '3ve SKG Soprof.')
GO

Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD944',
        '08E53D25-D843-4F60-BB56-448E0C16D09E', -- 3VE SKG
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD974', -- Z
        '3ve SKG Z')
GO