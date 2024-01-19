ALTER view [dbo].[vwOrders] as
    select                      ks.KeyingSystemNumberId                   KeyingSystemNumber,
                                o.Id,
                                KeyingSystemId,
                                kst.ProAlphaReferenceForCylinders         KeyingSystemTypeCaptionForCylinders,
                                kst.ProAlphaReferenceForSuperordinateKeys KeyingSystemTypeCaptionForSuperordinateKeys,
                                ksk.Name                                  KeyingSystemKindName,
                                ksk.ProAlphaReference                     KeyingSystemKindNameProAlpha,
                                OrderNumber,
                                OrderNumberProAlpha,
                                CustomerIdProAlpha,
                                o.Note,
                                ShipmentDate,
                                ot.Name                                   OrderType,
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
                                ke.Value                                  KeyEmbossing,
        KeyNumberingType      = Case ks.KeyNumberingType
                                    When 0 Then 'None'
                                    When 1 Then 'Sequential'
                                    When 2 Then 'SequentialSuperordinateKey'
                                    When 3 Then 'Manual'
                                    End,
        KeyingSystemShortname = Case kst.Id
                                    When '08E53D25-D843-4F60-BB56-448E0C16D080' Then 'STD'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D081' Then 'WZ'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D082' Then '2VE'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D083' Then 'HSR'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D084' Then '3VE'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D09E' Then '3VE' -- 3VE SKG
                                    When '08E53D25-D843-4F60-BB56-448E0C16D085' Then 'STR' -- STR
                                    When '08E53D25-D843-4F60-BB56-448E0C16D086' Then 'TH6' -- ??
                                    When '08E53D25-D843-4F60-BB56-448E0C16D087' Then 'SI6'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D088' Then '2VS'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D089' Then '3VS'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D08A'
                                        Then 'STR' -- Primus VL                                    
                                    When '08E53D25-D843-4F60-BB56-448E0C16D090' Then 'STR' -- Primus VX
                                    When '08E53D25-D843-4F60-BB56-448E0C16D091' Then '3VE' -- Primus HX
                                    When '08E53D25-D843-4F60-BB56-448E0C16D092' Then 'S1'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D093' Then 'S3'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D094' Then 'S4'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D095' Then 'S5'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D096' Then 'CARAT' -- Carat CSS
                                    When '08E53D25-D843-4F60-BB56-448E0C16D097' Then 'CS1' -- Carat CSS manuell
                                    When '08E53D25-D843-4F60-BB56-448E0C16D098' Then 'TH6' -- Carat P1
                                    When '08E53D25-D843-4F60-BB56-448E0C16D099' Then '2VE' -- Carat P2

                                    End,
                                m.LockwizName                             KeyingSystemLockwizName
    from Orders o
             inner join KeyingSystems ks on o.KeyingSystemId = ks.Id
             inner join KeyingSystemNumbers ksn on ksn.Id = ks.KeyingSystemNumberId
             inner join KeyingSystemTypes kst on ksn.KeyingSystemTypeId = kst.Id
             inner join KeyingSystemKinds ksk on ks.KeyingSystemKindId = ksk.Id
             inner join OrderTypes ot on o.OrderTypeId = ot.Id
             left outer join KeyEmbossings ke on ke.Id = o.KeyEmbossingId
             left outer join Lockwiz.KeyingSystemKindMappings m on ks.KeyingSystemKindId = m.KeyingSystemKindId and
                                                                   ksn.KeyingSystemTypeId = m.KeyingSystemTypeId
Go

