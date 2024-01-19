Create TABLE CylinderEntriesToSuperordinateKeys
(
    Id                 uniqueidentifier not null primary key,
    CylinderEntryId    uniqueidentifier not null foreign key references CylinderEntries,
    SuperordinateKeyId uniqueidentifier not null foreign key references SuperordinateKeys,
    CreatedBy          nvarchar(255)    not null,
    Created            datetime2        not null
)

Create UNIQUE Index UQ_CylinderEntryId_SuperordinateKey On CylinderEntriesToSuperordinateKeys (CylinderEntryId, SuperordinateKeyId)