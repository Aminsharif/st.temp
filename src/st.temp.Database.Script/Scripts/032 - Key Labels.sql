Alter table CylinderEntries
    add KeyLabel nvarchar(255)
GO
Alter table SuperordinateKeys
    add KeyLabel nvarchar(255)
Go
Create table CylinderEntryKeyLabels
(
    Id              uniqueidentifier not null primary key,
    CylinderEntryId uniqueidentifier not null foreign key references CylinderEntries on delete cascade,
    Label           nvarchar(255),
    Created         datetime2 default GETUTCDATE(),
)
go
Create table SuperordinateKeyLabels
(
    Id                 uniqueidentifier not null primary key,
    SuperordinateKeyId uniqueidentifier not null foreign key references SuperordinateKeys on delete cascade,
    Label              nvarchar(255),
    Created            datetime2 default GETUTCDATE(),
)
go

Create View KeyLabels as
select ks.KeyingSystemNumber,
       Right('00000' + cast(o.OrderNumber as nvarchar(10)), 6) OrderNumber,
       ces.LockwizId,
       ces.Locking,
       ckl.Label,
       'Cylinder'                                              Type
from KeyingSystems ks
         inner join Orders o on ks.Id = o.KeyingSystemId
         inner join CylinderEntries ces on o.Id = ces.OrderId
         inner join CylinderEntryKeyLabels ckl on ces.Id = ckl.CylinderEntryId
where o.OrderNumberProAlpha is not null
union
select ks.KeyingSystemNumber,
       Right('00000' + cast(o.OrderNumber as nvarchar(10)), 6) OrderNumber,
       sks.LockwizId,
       sks.Locking,
       skl.Label,
       'SuperordinateKey'                                      Type
from KeyingSystems ks
         inner join Orders o on ks.Id = o.KeyingSystemId
         inner join SuperordinateKeys sks on o.Id = sks.OrderId
         inner join SuperordinateKeyLabels skl on sks.Id = skl.SuperordinateKeyId
Go