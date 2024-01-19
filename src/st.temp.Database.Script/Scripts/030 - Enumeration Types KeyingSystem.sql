alter table KeyingSystems
    add KeyEnumerationType int not null default 0
Go
alter table KeyingSystems
    add constraint CHK_KeyEnumeration CHECK (KeyingSystems.KeyEnumerationType between 0 and 3)
GO
Drop PROCEDURE CreateKeyingSystem;

Go
Create Procedure CreateKeyingSystem(
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKindId uniqueidentifier,
    @createdBy nvarchar(255),
    @keyEnumerationType int,
    @keyingSystemId uniqueidentifier OUTPUT)
As
BEGIN
    Declare @keyingSystemNumber int
    exec GenerateKeyingSystemNumber @keyingSystemTypeId,
         @calculatedKeyingSystemNumber = @keyingSystemNumber OUTPUT

    SELECT @keyingSystemId = NEWID();

    Insert into KeyingSystems (Id, KeyingSystemTypeId, KeyingSystemKindId, KeyingSystemNumber, CreatedBy,
                               KeyEnumerationType, Created)
    VALUES (@keyingSystemId, @keyingSystemTypeId, @keyingSystemKindId, @keyingSystemNumber, @createdBy,
            @keyEnumerationType, GETUTCDATE())
END
GO
Drop PROCEDURE UpdateKeyingSystem;
Go
Create Procedure UpdateKeyingSystem(
    @keyingSystemId uniqueidentifier,
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKindId uniqueidentifier,
    @keyEnumerationType int,
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
        KeyEnumerationType = @keyEnumerationType,
        LastUpdated        = GETUTCDATE()
    where Id = @keyingSystemId
END
Go
