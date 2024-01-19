Alter table dbo.SuperordinateKeys
    add LockwizId int
Go
CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_SuperordinateKeys_KeyingSystemId_LockwizId_NotNull
    ON dbo.SuperordinateKeys (KeyingSystemId, LockwizId)
    WHERE LockwizId IS NOT NULL;
GO
Alter table dbo.CylinderEntries
    add LockwizId int
Go
CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_CylinderEntries_KeyingSystemId_LockwizId_NotNull
    ON dbo.CylinderEntries (KeyingSystemId, LockwizId)
    WHERE LockwizId IS NOT NULL;
GO