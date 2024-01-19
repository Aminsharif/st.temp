Alter view vwCylinderEntries as
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
           Description,
        PartVariantNumber =
           case ce.PartVariantNumber
               When 'None' then ce.PartNumber
               else ce.PartVariantNumber
               end,
           ae.Caption AdditionalEquipment
    from CylinderEntries ce
             inner join Orders o on ce.OrderId = o.Id
             inner join KeyingSystems ks on ce.KeyingSystemId = ks.Id
             left outer join AdditionalEquipments ae on ce.AdditionalEquipmentId = ae.Id
    where LockwizId is not null

Go
Alter view vwSuperordinateKeys as
    select ks.KeyingSystemNumber,
           OrderNumber,
           LockwizId,
           PartVariantNumber,
           Locking,
           KeysCount,
           Price,
           Description
    from SuperordinateKeys sks
             inner join Orders o on sks.OrderId = o.Id
             inner join KeyingSystems ks on sks.KeyingSystemId = ks.Id
    where LockwizId is not null
Go