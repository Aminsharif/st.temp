declare @name as nvarchar(255);
SELECT @name = name
FROM dbo.sysobjects
WHERE name LIKE 'DF__Additiona__IsAct%'

IF @name IS NOT NULL
    BEGIN
        EXEC ('ALTER TABLE AdditionalEquipmentEntries DROP CONSTRAINT ' + @name);
    END
Go

alter Table AdditionalEquipmentEntries
    drop column IsActive, Caption