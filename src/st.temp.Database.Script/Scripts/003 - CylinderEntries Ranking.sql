Alter TABLE CylinderEntries
    ADD
        ParentCylinderEntryId uniqueidentifier foreign key references CylinderEntries
GO
CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_ParentCylinderEntry_NotNull
    ON CylinderEntries (ParentCylinderEntryId)
    WHERE ParentCylinderEntryId IS NOT NULL;
GO