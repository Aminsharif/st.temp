Go
declare @name as nvarchar(255);
SELECT @name = name
FROM dbo.sysobjects
WHERE name LIKE 'DF__Orders__OrderFla%'

IF @name IS NOT NULL
    BEGIN
        EXEC ('ALTER TABLE Orders DROP CONSTRAINT ' + @name);
    END
Go
Alter Table Orders
    drop column OrderFlag
GO

Alter Table Orders
    add IsFunctionRequest bit not null default 0

GO

Alter Table Orders
    add IsCalculation bit not null default 0
Go