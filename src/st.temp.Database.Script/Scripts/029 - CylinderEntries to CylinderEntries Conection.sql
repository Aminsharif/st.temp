create table CylinderEntriesToCylinderEntries
(
    Id                    uniqueidentifier not null primary key,
    SourceCylinderEntryId uniqueidentifier not null foreign key references CylinderEntries,
    TargetCylinderEntryId uniqueidentifier not null foreign key references CylinderEntries,
    ConnectionType        int              not null,
    CreatedBy             nvarchar(255)    not null,
    Created               datetime2 default GETUTCDATE()
)

go
Create UNIQUE Index UQ_CylinderEntryId_CylinderEntryId On CylinderEntriesToCylinderEntries (SourceCylinderEntryId, TargetCylinderEntryId)
Go

alter table CylinderEntries
    alter column Created datetime2
Go
ALTER TABLE CylinderEntries
    ADD CONSTRAINT DF_Created_UTCDate DEFAULT GETUTCDATE() FOR Created
Go

alter table CylinderEntries
    alter column LastUpdated datetime2
Go
ALTER TABLE CylinderEntries
    ADD CONSTRAINT DF_LastUpdated_UTCDate DEFAULT GETUTCDATE() FOR LastUpdated
Go

