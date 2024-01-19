alter table KeyingSystems
    drop constraint CHK_KeyNumberingType
Go
alter table KeyingSystems
    add constraint CHK_KeyNumberingType CHECK (KeyingSystems.KeyNumberingType between 0 and 4)
GO