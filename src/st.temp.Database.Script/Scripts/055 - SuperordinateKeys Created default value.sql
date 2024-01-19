Alter table SuperordinateKeys
    ADD CONSTRAINT DF_SuperordinateKeys_Created DEFAULT GETDATE() FOR Created