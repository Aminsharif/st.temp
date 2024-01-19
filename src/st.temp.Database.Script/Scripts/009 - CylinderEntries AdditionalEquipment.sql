Alter Table dbo.CylinderEntries
    add AdditionalEquipment nvarchar(255) not null default '1'

ALTER TABLE dbo.CylinderEntries
    alter column Color nvarchar(255) not null