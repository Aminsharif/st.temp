alter table SuperordinateKeys
    add CONSTRAINT ck_Id_ParentSuperordinateKeyId check (Id <> ParentSuperordinateKeyId)

alter table CylinderEntries
    add CONSTRAINT ck_Id_ParentCylinderEntryId check (Id <> ParentCylinderEntryId)

