Alter Table dbo.KeyingSystems
    add KeyingSystemKindId uniqueidentifier not null references KeyingSystemKinds default '00000000-0000-0000-0000-000000000001'
Go

-- Migrate Keying Systems
Update KeyingSystems
set KeyingSystemKindId = IsNull(kk.Id, '00000000-0000-0000-0000-000000000001')
from KeyingSystems k
         left outer join KeyingSystemKinds kk
                         on k.KeyingSystemKind = kk.Name

Alter TABLE KeyingSystems
    drop column KeyingSystemKind
GO

Drop PROCEDURE CreateKeyingSystem;

Go
Create Procedure CreateKeyingSystem(
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKindId uniqueidentifier,
    @createdBy nvarchar(255),
    @keyingSystemId uniqueidentifier OUTPUT)
As
BEGIN
    Declare @keyingSystemNumber int
    exec GenerateKeyingSystemNumber @keyingSystemTypeId,
         @calculatedKeyingSystemNumber = @keyingSystemNumber OUTPUT

    SELECT @keyingSystemId = NEWID();

    Insert into KeyingSystems (Id, KeyingSystemTypeId, KeyingSystemKindId, KeyingSystemNumber, CreatedBy, Created)
    VALUES (@keyingSystemId, @keyingSystemTypeId, @keyingSystemKindId, @keyingSystemNumber, @createdBy, GETUTCDATE())
END
GO
Drop PROCEDURE UpdateKeyingSystem;
Go
Create Procedure UpdateKeyingSystem(
    @keyingSystemId uniqueidentifier,
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKindId uniqueidentifier,
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
    set KeyingSystemKindId = @keyingSystemKindId,
        KeyingSystemTypeId = @keyingSystemTypeId,
        KeyingSystemNumber = @keyingSystemNumber,
        UpdatedBy          = @updatedBy,
        LastUpdated        = GETUTCDATE()
    where Id = @keyingSystemId
END
Go