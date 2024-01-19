Create View vwCylinderEntriesWithFunction as
With CylinderEntriesWithFunctionCount
         as
         (select *
          from CylinderEntries ce
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
                                 and ConnectionType = 3) AD),
     CylinderEntriesWithFunction as
         (select c.*,
                 CASE
                     WHEN NumberOfCylindersThatUseThisCylinderAsCentral > 0 THEN 1 -- Central
                     WHEN NumberOfCylindersThatUseThisCylinderAsSynchronized > 0 THEN 2 -- Gleich       
                     WHEN NumberOfCylindersThatUseThisCylinderAsIncluding > 0 THEN 3 -- Mitschließung

                     ELSE 0 -- No Function
                     END as FunctionType
          from CylinderEntriesWithFunctionCount cc
                   inner join CylinderEntries c on cc.Id = c.Id)
select *
from CylinderEntriesWithFunction
Go