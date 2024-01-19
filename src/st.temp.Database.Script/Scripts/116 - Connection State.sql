Update CharacteristicClassifications
set CustomerId = null

Update CharacteristicClassifications
set DefaultValue = '07-2'
where DefaultValue = '07. Feb'
Update CharacteristicClassifications
set DefaultValue = '07-3'
where DefaultValue = '07. Mrz'
Update CharacteristicClassifications
set DefaultValue = '07-4'
where DefaultValue = '07. Apr'
Update CharacteristicClassifications
set DefaultValue = '07-6'
where DefaultValue = '07. Jun'
Update CharacteristicClassifications
set DefaultValue = '07-7'
where DefaultValue = '07. Jul'
Update CharacteristicClassifications
set DefaultValue = '07-9'
where DefaultValue = '07. Sep'

select Id, DefaultValue
from CharacteristicClassifications
where DefaultValue <> '-'
order by DefaultValue

Go
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
           CASE
               WHEN NumberOfCylindersThatUseThisCylinderAsCentral > 0 THEN 'Z'
               WHEN NumberOfCylindersThatUseThisCylinderAsSynchronized > 0 THEN 'G'
               WHEN NumberOfCylindersThatUseThisCylinderAsIncluding > 0 THEN 'M'
               ELSE null
               END as                                                           ConnectionType,
           IIF(AB.NumberOfCylindersThatUseThisCylinderAsCentral > 0, 1, 0)      IsCentral,
           IIF(AC.NumberOfCylindersThatUseThisCylinderAsSynchronized > 0, 1, 0) IsSynchronized,
           IIF(AD.NumberOfCylindersThatUseThisCylinderAsIncluding > 0, 1, 0)    IsIncluding,
        PartVariantNumber =
           case ce.PartVariantNumber
               When 'None' then ce.PartNumber
               else
                   ce.PartVariantNumber
               end,
           ae.AdditionalEquipments
    from CylinderEntries ce
             inner join Orders o on ce.OrderId = o.Id
             inner join KeyingSystems ks on ce.KeyingSystemId = ks.Id
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsCentral
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 1) AB
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsSynchronized
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 2) AC
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsIncluding
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 3) AD
             Outer Apply (select String_Agg(ae.Caption, N',') AdditionalEquipments
                          from AdditionalEquipmentCylinderEntry aec
                                   inner join AdditionalEquipments ae on aec.AdditionalEquipmentsId = ae.Id
                          where aec.CylinderEntriesId = ce.Id) AE
    where LockwizId is not null
Go

