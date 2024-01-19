Create view vwCylinderEntries as
select ks.KeyingSystemNumber,
       Locking,
       LengthA,
       LengthB,
       BackSet,
       Color,
       DoorNumber,
       OrderNumber,
       LockwizId,
       KeysCount,
       CylindersCount,
       Price,
       PartVariantNumber =
           case ce.PartVariantNumber
               When 'None' then ce.PartNumber
               else ce.PartVariantNumber
               end
from CylinderEntries ce
         inner join Orders o on ce.OrderId = o.Id
         inner join KeyingSystems ks on ce.KeyingSystemId = ks.Id
where LockwizId is not null

Go
Create view vwSuperordinateKeys as
select ks.KeyingSystemNumber,
       OrderNumber,
       LockwizId,
       PartVariantNumber,
       Locking,
       KeysCount,
       Price
from SuperordinateKeys sks
         inner join Orders o on sks.OrderId = o.Id
         inner join KeyingSystems ks on sks.KeyingSystemId = ks.Id
where LockwizId is not null
Go

create schema ProductConfigurator
go

create table ProductConfigurator.Logs
(
    Id               int              not null primary key identity,
    ProcessedEventId uniqueidentifier not null,
    Message          nvarchar(max),
    Created          datetime2        not null default GETUTCDATE()
)

GO

Create PROCEDURE ProductConfigurator.spLogProductConfiguratorMessage(@processedEventId uniqueidentifier, @logMessage nvarchar(max)) as
Begin
    insert into ProductConfigurator.Logs (ProcessedEventId, Message) values (@processedEventId, @logMessage)
end
Go

GO

drop view vwOrders

Go

create view vwOrders as
select ks.KeyingSystemNumber,
       o.Id,
       KeyingSystemId,
       OrderNumber,
       OrderNumberProAlpha,
       CustomerIdProAlpha,
       Note,
       ShipmentDate,
       DesiredShipmentDate,
       OrderType,
       o.CreatedBy,
       o.Created,
       o.UpdatedBy,
       o.LastUpdated,
       OrderKind,
       OrderDate,
       ShippingAddress_Name1,
       ShippingAddress_Name2,
       ShippingAddress_Street,
       ShippingAddress_HouseNumber,
       ShippingAddress_Country,
       ShippingAddress_City,
       ShippingAddress_PostalCode,
       ShipmentTermsIdProAlpha,
       ShippingMethodIdProAlpha,
       KeyNumberingPrice,
       KeyNumberingType = Case ks.KeyNumberingType
                              When 0 Then 'None'
                              When 1 Then 'Sequential'
                              When 2 Then 'SequentialSuperordinateKey'
                              When 3 Then 'Manual'
           End
from Orders o
         inner join KeyingSystems ks on o.KeyingSystemId = ks.Id

Go

drop view KeyLabels
Go

Create View vwKeyLabels as
select ks.KeyingSystemNumber,
       OrderNumber,
       ces.LockwizId,
       ces.Locking,
       ckl.Label,
       'Cylinder' Type
from KeyingSystems ks
         inner join Orders o on ks.Id = o.KeyingSystemId
         inner join CylinderEntries ces on o.Id = ces.OrderId
         inner join CylinderEntryKeyLabels ckl on ces.Id = ckl.CylinderEntryId
union
select ks.KeyingSystemNumber,
       OrderNumber,
       sks.LockwizId,
       sks.Locking,
       skl.Label,
       'SuperordinateKey' Type
from KeyingSystems ks
         inner join Orders o on ks.Id = o.KeyingSystemId
         inner join SuperordinateKeys sks on o.Id = sks.OrderId
         inner join SuperordinateKeyLabels skl on sks.Id = skl.SuperordinateKeyId
Go

EXEC sp_rename
     @objname = 'dbo.Ausrechnung',
     @newname = 'vwAusrechnung'
Go