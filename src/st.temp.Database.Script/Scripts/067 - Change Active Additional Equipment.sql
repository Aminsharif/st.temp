sp_rename 'AdditionalEquipments.Inactive', 'IsActive', 'COLUMN'
GO

Update AdditionalEquipments
set IsActive = Case When IsActive = 1 Then 0 Else 1 END
Go
;
With AdditionalEquipmentIdsWithoutKeyingSystem as (select ae.Id  AdditionalEquipmentId,
                                                          aet.Id EntryId
                                                   from AdditionalEquipments ae
                                                            left outer join AdditionalEquipmentKeyingSystemType aet
                                                                            on aet.AdditionalEquipmentsId = ae.Id
                                                   where aet.Id is null)
Insert
into AdditionalEquipmentKeyingSystemType (Id, AdditionalEquipmentsId, KeyingSystemTypesId)
select NEWID() Id, AdditionalEquipmentId AdditionalEquipmentsId, k.Id KeyingSystemTypeId
from AdditionalEquipmentIdsWithoutKeyingSystem
         cross join KeyingSystemTypes k
where k.Caption in ('HSR', 'STR', 'TH6', 'SI6', '2VS', '3VS', '3VE')