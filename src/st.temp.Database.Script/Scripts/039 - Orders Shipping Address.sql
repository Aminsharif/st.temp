Alter Table Orders
    Add ShippingAddress_HouseNumber nvarchar(50)

GO

drop view vwOrders

Go

create view vwOrders as
select                 ks.KeyingSystemNumber,
                       o.Id,
                       KeyingSystemId,
                       Right('00000' + cast(o.OrderNumber as nvarchar(10)), 6) OrderNumber,
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
GO
alter table KeyingSystems
    drop constraint CHK_KeyNumberingType
Go
alter table KeyingSystems
    add constraint CHK_KeyNumberingType CHECK (KeyingSystems.KeyNumberingType between 0 and 4)