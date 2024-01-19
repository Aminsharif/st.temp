ALTER TABLE ArtikelXlsInfos DROP COLUMN [System];
ALTER TABLE ArtikelXlsInfos ADD KeyingSystemTypesId uniqueidentifier;
ALTER TABLE ArtikelXlsInfos ADD CONSTRAINT FK_ArtikelXlsInfosKeyingSystemTypesId FOREIGN KEY (KeyingSystemTypesId) REFERENCES KeyingSystemTypes(Id);

ALTER TABLE ZasXlsInfos DROP COLUMN ZasNumber;
ALTER TABLE ZasXlsInfos DROP COLUMN [System];
ALTER TABLE ZasXlsInfos ADD AdditionalEquipmentsId uniqueidentifier;
ALTER TABLE ZasXlsInfos ADD CONSTRAINT FK_AdditionalEquipmentsId FOREIGN KEY (AdditionalEquipmentsId) REFERENCES AdditionalEquipments(Id);
ALTER TABLE ZasXlsInfos ADD KeyingSystemTypesId uniqueidentifier;
ALTER TABLE ZasXlsInfos ADD CONSTRAINT FK_ZasXlsInfosKeyingSystemTypesId FOREIGN KEY (KeyingSystemTypesId) REFERENCES KeyingSystemTypes(Id);