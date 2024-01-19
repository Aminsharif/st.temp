alter view vwOrders as
    select                 ks.KeyingSystemNumber,
                           o.Id,
                           KeyingSystemId,
                           OrderNumber,
                           OrderNumberProAlpha,
                           CustomerIdProAlpha,
                           o.Note,
                           ShipmentDate,
                           DesiredShipmentDate,
                           OrderType,
                           kst.IsCarat,
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
                           ke.Value KeyEmbossing,
        KeyNumberingType = Case ks.KeyNumberingType
                               When 0 Then 'None'
                               When 1 Then 'Sequential'
                               When 2 Then 'SequentialSuperordinateKey'
                               When 3 Then 'Manual'
                               End
    from Orders o
             inner join KeyingSystems ks on o.KeyingSystemId = ks.Id
             inner join KeyingSystemTypes kst on ks.KeyingSystemTypeId = kst.Id
             left outer join KeyEmbossings ke on ke.Id = o.KeyEmbossingId