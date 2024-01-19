Go
declare @name as nvarchar(255);
SELECT @name = name
FROM dbo.sysobjects
WHERE name LIKE 'DF__CylinderE__Addit%'

IF @name IS NOT NULL
    BEGIN
        EXEC ('ALTER TABLE CylinderEntries DROP CONSTRAINT ' + @name);
    END
Go

Alter Table CylinderEntries
    drop column AdditionalEquipment
GO

Create table Classifications
(
    Id      uniqueidentifier primary key not null,
    Caption nvarchar(255)                not null,
)
Go
Create table Characteristics
(
    Id           uniqueidentifier primary key not null,
    Caption      nvarchar(255)                not null,
    DefaultValue nvarchar(255)                null,
)
Go

Create Table CharacteristicClassification
(
    Id                uniqueidentifier not null primary key default NEWID(),
    ClassificationsId uniqueidentifier not null references Classifications on delete cascade,
    CharacteristicsId uniqueidentifier not null references Characteristics on delete cascade,
)
Go

Insert into Classifications (Id, Caption)
Values ('C680E296-16C4-49E8-8268-21383695E300', 'Zylinder')

Go

Insert into Characteristics (Id, Caption, DefaultValue)
Values ('D680E296-16C4-49E8-8268-21383695E300', 'ABH', null),
       ('D680E296-16C4-49E8-8268-21383695E301', 'knauf', null),
       ('D680E296-16C4-49E8-8268-21383695E302', 'kseite', null),
       ('D680E296-16C4-49E8-8268-21383695E303', 'n-lage', null),
       ('D680E296-16C4-49E8-8268-21383695E304', 'nase', null),
       ('D680E296-16C4-49E8-8268-21383695E305', 'pro', null),
       ('D680E296-16C4-49E8-8268-21383695E306', 's-anz', 'Schl. lt.Schließplan'),
       ('D680E296-16C4-49E8-8268-21383695E307', 's-art', 'Neusilber'),
       ('D680E296-16C4-49E8-8268-21383695E308', 'schrau', 'Schraube M5X80'),
       ('D680E296-16C4-49E8-8268-21383695E309', 'spange', null),
       ('D680E296-16C4-49E8-8268-21383695E310', 'z-präg', 'Präge WILKA'),
       ('D680E296-16C4-49E8-8268-21383695E311', 'zas1', null),
       ('D680E296-16C4-49E8-8268-21383695E312', 'zas2', null),
       ('D680E296-16C4-49E8-8268-21383695E313', 'zas3', null)
GO

Insert into CharacteristicClassification (Id, ClassificationsId, CharacteristicsId)
Values (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E300'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E301'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E302'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E303'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E304'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E305'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E306'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E307'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E308'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E309'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E310'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E311'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E312'),
       (NewId(), 'C680E296-16C4-49E8-8268-21383695E300', 'D680E296-16C4-49E8-8268-21383695E313')
Go




