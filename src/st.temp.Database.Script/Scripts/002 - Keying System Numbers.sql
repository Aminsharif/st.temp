CREATE SEQUENCE [dbo].[Standard] INCREMENT BY 1 START WITH 0 MAXVALUE 199999 NO CYCLE
CREATE SEQUENCE [dbo].[WZ] INCREMENT BY 1 START WITH 200000 MAXVALUE 249999 NO CYCLE
CREATE SEQUENCE [dbo].[2VE] INCREMENT BY 1 START WITH 250000 MAXVALUE 299999 NO CYCLE
CREATE SEQUENCE [dbo].[HSR] INCREMENT BY 1 START WITH 300000 MAXVALUE 349999 NO CYCLE
CREATE SEQUENCE [dbo].[3VE] INCREMENT BY 1 START WITH 350000 MAXVALUE 399999 NO CYCLE
CREATE SEQUENCE [dbo].[STR] INCREMENT BY 1 START WITH 400000 MAXVALUE 499999 NO CYCLE
CREATE SEQUENCE [dbo].[TH6] INCREMENT BY 1 START WITH 500000 MAXVALUE 549999 NO CYCLE
CREATE SEQUENCE [dbo].[SI6] INCREMENT BY 1 START WITH 550000 MAXVALUE 599999 NO CYCLE
CREATE SEQUENCE [dbo].[2VS] INCREMENT BY 1 START WITH 600000 MAXVALUE 649999 NO CYCLE
CREATE SEQUENCE [dbo].[3VS] INCREMENT BY 1 START WITH 650000 MAXVALUE 699999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_S1] INCREMENT BY 1 START WITH 800000 MAXVALUE 829999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_S3] INCREMENT BY 1 START WITH 830000 MAXVALUE 859999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_S4] INCREMENT BY 1 START WITH 860000 MAXVALUE 879999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_S5] INCREMENT BY 1 START WITH 880000 MAXVALUE 899999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_Css] INCREMENT BY 1 START WITH 900000 MAXVALUE 919999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_Css_Manual] INCREMENT BY 1 START WITH 950000 MAXVALUE 959999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_P1] INCREMENT BY 1 START WITH 920000 MAXVALUE 949999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_P2] INCREMENT BY 1 START WITH 960000 MAXVALUE 969999 NO CYCLE
CREATE SEQUENCE [dbo].[Carat_P3] INCREMENT BY 1 START WITH 970000 MAXVALUE 989999 NO CYCLE
CREATE SEQUENCE [dbo].[Primus_Vl] INCREMENT BY 1 START WITH 702000 MAXVALUE 729999 NO CYCLE
CREATE SEQUENCE [dbo].[Primus_Vx] INCREMENT BY 1 START WITH 750000 MAXVALUE 779999 NO CYCLE
CREATE SEQUENCE [dbo].[Primus_Hx] INCREMENT BY 1 START WITH 780000 MAXVALUE 799999 NO CYCLE

Create TABLE KeyingSystemTypes
(
    Id                uniqueidentifier primary key,
    ProAlphaReference nvarchar(255),
    Caption           nvarchar(255) not null,
    SequenceName      nvarchar(255) not null unique
)

Alter TABLE KeyingSystems
    drop column KeyingSystemTypeName

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D080',
        N'',
        N'Standard',
        N'Standard')

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D081',
        N'',
        N'WZ',
        N'WZ')
Go
insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D082',
        N'',
        N'2VE',
        N'2VE')
Go
insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D083',
        N'',
        N'HSR',
        N'HSR')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D084',
        N'',
        N'3VE',
        N'3VE')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D085',
        N'',
        N'STR',
        N'STR')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D086',
        N'',
        N'TH6',
        N'TH6')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D087',
        N'',
        N'SI6',
        N'SI6')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D088',
        N'',
        N'2VS',
        N'2VS')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D089',
        N'',
        N'3VS',
        N'3VS')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D08A',
        N'',
        N'Primus VL',
        N'Primus_Vl')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D090',
        N'',
        N'Primus VX',
        N'Primus_Vx')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D091',
        N'',
        N'Primus HX',
        N'Primus_Hx')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D092',
        N'',
        N'Carat S1',
        N'Carat_S1')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D093',
        N'',
        N'Carat S3',
        N'Carat_S3')
Go
insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D094',
        N'',
        N'Carat S4',
        N'Carat_S4')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D095',
        N'',
        N'Carat S5',
        N'Carat_S5')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D096',
        N'',
        N'Carat CSS',
        N'Carat_Css')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D097',
        N'',
        N'Carat CSS (manuell gerechnet)',
        N'Carat_Css_Manual')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D098',
        N'',
        N'Carat P1',
        N'Carat_P1')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D099',
        N'',
        N'Carat P2',
        N'Carat_P2')
Go

insert into KeyingSystemTypes(Id, ProAlphaReference, Caption, SequenceName)
values ('08E53D25-D843-4F60-BB56-448E0C16D09A',
        N'',
        N'Carat P3',
        N'Carat_P3')
Go

--         "Primus VH (H400)",


Alter TABLE KeyingSystems
    add KeyingSystemTypeId uniqueidentifier not null foreign key references KeyingSystemTypes default '08E53D25-D843-4F60-BB56-448E0C16D080'
Go
Create Procedure GenerateKeyingSystemNumber(
    @keyingSystemTypeId uniqueidentifier,
    @calculatedKeyingSystemNumber int OUTPUT)
As
Begin

    Declare @keyingSystemSequenceName as nvarchar(255)

    Select @keyingSystemSequenceName = SequenceName from KeyingSystemTypes where Id = @keyingSystemTypeId

    If not Exists(SELECT *
                  FROM sys.sequences
                  WHERE name = @keyingSystemSequenceName)
        BEGIN
            Rollback Transaction
            RAISERROR ('Sequence does not exist.', 11, 1)
        END

    DECLARE @s NVARCHAR(100) = 'Set @sequence = NEXT VALUE FOR [' + @keyingSystemSequenceName + ']'
    EXEC sp_executesql @s, N'@sequence int output', @calculatedKeyingSystemNumber OUTPUT
    Return
End

Go
Create Procedure CreateKeyingSystem(
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKind nvarchar(255),
    @createdBy nvarchar(255),
    @keyingSystemId uniqueidentifier OUTPUT)
As
BEGIN
    Declare @keyingSystemNumber int
    exec GenerateKeyingSystemNumber @keyingSystemTypeId,
         @calculatedKeyingSystemNumber = @keyingSystemNumber OUTPUT

    SELECT @keyingSystemId = NEWID();

    Insert into KeyingSystems (Id, KeyingSystemTypeId, KeyingSystemKind, KeyingSystemNumber, CreatedBy, Created)
    VALUES (@keyingSystemId, @keyingSystemTypeId, @keyingSystemKind, @keyingSystemNumber, @createdBy, GETUTCDATE())
END

Go

Create Procedure UpdateKeyingSystem(
    @keyingSystemId uniqueidentifier,
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKind nvarchar(255),
    @updatedBy nvarchar(255))
As
BEGIN
    Declare @keyingSystemNumber nvarchar(255)
    Declare @originalKeyingSystemTypeId uniqueidentifier

    Select @originalKeyingSystemTypeId = KeyingSystemTypeId,
           @keyingSystemNumber = KeyingSystemNumber
    from KeyingSystems
    where Id = @keyingSystemId

    If @originalKeyingSystemTypeId <> @keyingSystemTypeId
        exec GenerateKeyingSystemNumber @keyingSystemTypeId,
             @calculatedKeyingSystemNumber = @keyingSystemNumber OUTPUT

    UPDATE KeyingSystems
    set KeyingSystemKind   = @keyingSystemKind,
        KeyingSystemTypeId = @keyingSystemTypeId,
        KeyingSystemNumber = @keyingSystemNumber,
        UpdatedBy          = @updatedBy,
        LastUpdated        = GETUTCDATE()
    where Id = @keyingSystemId
END