Create View vwOrdersAggregated as
(
select o.Id OrderId, C.CylinderEntriesCount, S.SuperordinateKeysCount
from Orders o
         outer Apply (select count(*) CylinderEntriesCount from CylinderEntries ce where ce.OrderId = o.Id) C
         outer Apply (select count(*) SuperordinateKeysCount from SuperordinateKeys sk where sk.OrderId = o.Id) S)