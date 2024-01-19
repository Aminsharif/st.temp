alter table Orders
    add KeyNumberingPrice decimal(10, 2) not null default 0
GO

alter table Orders
    add constraint CHK_Order_NumberingPrice CHECK (Orders.KeyNumberingPrice >= 0)
GO
create view vwOrders as
select ks.KeyingSystemNumber,
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
       ShippingAddress_Country,
       ShippingAddress_City,       
       ShippingAddress_PostalCode,
       ShipmentTermsIdProAlpha,
       ShippingMethodIdProAlpha,
       KeyNumberingPrice
from Orders o
         inner join KeyingSystems ks on o.KeyingSystemId = ks.Id
GO