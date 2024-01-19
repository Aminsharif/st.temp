Create TABLE KeyingSystemKinds
(
    Id                 uniqueidentifier primary key not null,
    Name               nvarchar(255) not null unique,
    ProAlphaReference nvarchar(255) not null unique
) Go
    
Insert into KeyingSystemKinds
    (Id, Name, ProAlphaReference)
VALUES ('00000000-0000-0000-0000-000000000001', 'None', 'None')
GO

Insert into KeyingSystemKinds
    (Id, Name, ProAlphaReference)
VALUES ('C6C9ED24-07BB-40CB-A60F-E910CD7CD970', 'GHS', 'GHS-Einr.')
GO


Insert into KeyingSystemKinds
    (Id, Name, ProAlphaReference)
VALUES ('C6C9ED24-07BB-40CB-A60F-E910CD7CD971', 'HS', 'HS-Einr.')
GO

Insert into KeyingSystemKinds
    (Id, Name, ProAlphaReference)
VALUES ('C6C9ED24-07BB-40CB-A60F-E910CD7CD972', 'HS/Z', 'HS/Z-Einr.')
GO

Insert into KeyingSystemKinds
    (Id, Name, ProAlphaReference)
VALUES ('C6C9ED24-07BB-40CB-A60F-E910CD7CD973', 'Z/HS', 'Z/HS-Einr.')
GO

Insert into KeyingSystemKinds
    (Id, Name, ProAlphaReference)
VALUES ('C6C9ED24-07BB-40CB-A60F-E910CD7CD974', 'Z', 'Zentral-Einr.')
GO

Insert into KeyingSystemKinds
    (Id, Name, ProAlphaReference)
VALUES ('C6C9ED24-07BB-40CB-A60F-E910CD7CD975', 'SP', 'Sonderpr.-Einr.')
GO

Create Table Lockwiz.KeyingSystemKindMappings
(
    Id                 uniqueidentifier not null,
    KeyingSystemTypeId uniqueidentifier not null references dbo.KeyingSystemTypes,
    KeyingSystemKindId uniqueidentifier not null references dbo.KeyingSystemKinds,
    LockwizName        nvarchar(255) not null
) GO

-- GHS
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD910',
        '08E53D25-D843-4F60-BB56-448E0C16D087', -- SI6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD970', -- GHS
        'Si6 GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD911',
        '08E53D25-D843-4F60-BB56-448E0C16D087', -- SI6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD971', -- HS
        'Si6 GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD912',
        '08E53D25-D843-4F60-BB56-448E0C16D087', -- SI6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD972', -- HS/Z
        'Si6 GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD913',
        '08E53D25-D843-4F60-BB56-448E0C16D087', -- SI6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD973', -- Z/HS
        'Si6 Z')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD914',
        '08E53D25-D843-4F60-BB56-448E0C16D087', -- SI6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD974', -- Z
        'Si6 Z')
GO

-- TH6
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD920',
        '08E53D25-D843-4F60-BB56-448E0C16D086', -- TH6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD970', -- GHS
        'Thales6GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD921',
        '08E53D25-D843-4F60-BB56-448E0C16D086', -- TH6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD971', -- HS
        'Thales6GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD922',
        '08E53D25-D843-4F60-BB56-448E0C16D086', -- TH6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD972', -- HS/Z
        'Thales6GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD923',
        '08E53D25-D843-4F60-BB56-448E0C16D086', -- TH6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD973', -- Z/HS
        'Thales6Z')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD924',
        '08E53D25-D843-4F60-BB56-448E0C16D086', -- TH6
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD974', -- Z
        'Thales6Z')
GO

-- 2ve
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD930',
        '08E53D25-D843-4F60-BB56-448E0C16D082', -- 2VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD970', -- GHS
        '2veGHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD931',
        '08E53D25-D843-4F60-BB56-448E0C16D082', -- 2VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD971', -- HS
        '2veGHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD932',
        '08E53D25-D843-4F60-BB56-448E0C16D082', -- 2VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD972', -- HS/Z
        '2veGHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD933',
        '08E53D25-D843-4F60-BB56-448E0C16D082', -- 2VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD973', -- Z/HS
        '2veZ5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD934',
        '08E53D25-D843-4F60-BB56-448E0C16D082', -- 2VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD974', -- Z
        '2veZ5')
GO

-- 3ve
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD940',
        '08E53D25-D843-4F60-BB56-448E0C16D084', -- 3VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD970', -- GHS
        '3veGHS5E5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD941',
        '08E53D25-D843-4F60-BB56-448E0C16D084', -- 3VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD971', -- HS
        '3veGHS5E5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD942',
        '08E53D25-D843-4F60-BB56-448E0C16D084', -- 3VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD972', -- HS/Z
        '3veGHS5E5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD943',
        '08E53D25-D843-4F60-BB56-448E0C16D084', -- 3VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD973', -- Z/HS
        '3veZ5E5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD944',
        '08E53D25-D843-4F60-BB56-448E0C16D084', -- 3VE
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD974', -- Z
        '3veZ5E5')
GO

-- 2vs
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD950',
        '08E53D25-D843-4F60-BB56-448E0C16D088', -- 2Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD970', -- GHS
        '2VS GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD951',
        '08E53D25-D843-4F60-BB56-448E0C16D088', -- 2Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD971', -- HS
        '2VS GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD952',
        '08E53D25-D843-4F60-BB56-448E0C16D088', -- 2Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD972', -- HS/Z
        '2VS GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD953',
        '08E53D25-D843-4F60-BB56-448E0C16D088', -- 2Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD973', -- Z/HS
        '2VS Z5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD954',
        '08E53D25-D843-4F60-BB56-448E0C16D088', -- 2Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD974', -- Z
        '2VS Z5')
GO

-- 3vs
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD960',
        '08E53D25-D843-4F60-BB56-448E0C16D089', -- 3Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD970', -- GHS
        '3VS GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD961',
        '08E53D25-D843-4F60-BB56-448E0C16D089', -- 3Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD971', -- HS
        '3VS GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD962',
        '08E53D25-D843-4F60-BB56-448E0C16D089', -- 3Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD972', -- HS/Z
        '3VS GHS5')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD963',
        '08E53D25-D843-4F60-BB56-448E0C16D089', -- 3Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD973', -- Z/HS
        '3VS Z')
GO
Insert into Lockwiz.KeyingSystemKindMappings
    (Id, KeyingSystemTypeId, KeyingSystemKindId, LockwizName)
values ('C6C9ED24-07BB-40CB-A60F-E910CD7CD964',
        '08E53D25-D843-4F60-BB56-448E0C16D089', -- 3Vs
        'C6C9ED24-07BB-40CB-A60F-E910CD7CD974', -- Z
        '3VS Z')
GO
Create
UNIQUE Index UQ_KeyingSystemTypeId_KeyingSystemKindId On Lockwiz.KeyingSystemKindMappings (KeyingSystemTypeId, KeyingSystemKindId) 