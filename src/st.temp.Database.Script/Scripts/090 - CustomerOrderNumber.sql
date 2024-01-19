alter view vwOrders as
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
           o.IsCalculation,
           o.IsFunctionRequest,
           o.AdditionalKeyCost,
           o.CustomerOrderNumber,
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