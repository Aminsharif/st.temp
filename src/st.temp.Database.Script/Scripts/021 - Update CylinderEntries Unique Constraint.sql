drop index idx_UQ_CylinderEntries_KeyingSystemId_Locking on CylinderEntries
Go
update CylinderEntries
set Locking = 'Empty'
where locking is null
Go
alter table CylinderEntries
    alter column Locking nvarchar(255) not null
Go