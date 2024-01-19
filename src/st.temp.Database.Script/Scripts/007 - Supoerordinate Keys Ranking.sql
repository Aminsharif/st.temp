Alter TABLE dbo.SuperordinateKeys
    ADD
        ParentSuperordinateKeyId uniqueidentifier foreign key references dbo.SuperordinateKeys
GO
CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_ParentSuperordinateKey_NotNull
    ON dbo.SuperordinateKeys (ParentSuperordinateKeyId)
    WHERE ParentSuperordinateKeyId IS NOT NULL;
GO