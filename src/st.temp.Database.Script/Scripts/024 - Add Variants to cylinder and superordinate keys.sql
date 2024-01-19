alter table CylinderEntries
    add PartVariantNumber nvarchar(255)
GO
alter table SuperordinateKeys
    add PartVariantNumber nvarchar(255)
GO
sp_rename 'SuperordinateKeys.ProductNumber', 'PartNumber', 'COLUMN'
GO
sp_rename 'CylinderEntries.ProductNumber', 'PartNumber', 'COLUMN'