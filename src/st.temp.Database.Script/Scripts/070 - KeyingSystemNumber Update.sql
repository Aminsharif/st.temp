declare @name as nvarchar(255);

select @name = name
from sys.objects
where parent_object_id = OBJECT_ID('dbo.KeyingSystems')
  and name like 'UQ%'

IF @name IS NOT NULL
    BEGIN
        EXEC ('ALTER TABLE KeyingSystems DROP CONSTRAINT ' + @name);
    END
Go

CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_KeyingSystemNumber_NotNull
    ON KeyingSystems (KeyingSystemNumber)
    WHERE KeyingSystemNumber IS NOT NULL;
GO

Alter Procedure CreateKeyingSystem(
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKindId uniqueidentifier,
    @createdBy nvarchar(255),
    @keyNumberingType int,
    @keyingSystemId uniqueidentifier OUTPUT)
As
BEGIN
    Declare @keyingSystemNumber int = null

    SELECT @keyingSystemId = NEWID();

    Insert into KeyingSystems (Id, KeyingSystemTypeId, KeyingSystemKindId, KeyingSystemNumber, CreatedBy,
                               KeyNumberingType, Created)
    VALUES (@keyingSystemId, @keyingSystemTypeId, @keyingSystemKindId, @keyingSystemNumber, @createdBy,
            @keyNumberingType, GETUTCDATE())
END
GO
Drop PROCEDURE UpdateKeyingSystem;
Go
Create Procedure UpdateKeyingSystem(
    @keyingSystemId uniqueidentifier,
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKindId uniqueidentifier,
    @keyNumberingType int,
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
        KeyNumberingType   = @keyNumberingType,
        LastUpdated        = GETUTCDATE()
    where Id = @keyingSystemId
END
