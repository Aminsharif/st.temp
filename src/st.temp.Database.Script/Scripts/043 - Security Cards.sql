-- additional caption of security card
ALTER TABLE dbo.KeyingSystemTypes
    ADD CardCaption nvarchar(122) default '' not null
GO

UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'STD-SYSTEM'
WHERE SequenceName = 'Standard'; -- 1
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'WZ-SYSTEM'
WHERE SequenceName = 'WZ'; -- 2
UPDATE dbo.KeyingSystemTypes
SET CardCaption = '2VE-SYSTEM'
WHERE SequenceName = '2VE'; -- 3
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'HSR-SYSTEM'
WHERE SequenceName = 'HSR'; -- 4
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'STR-SYSTEM'
WHERE SequenceName = 'STR'; -- 5
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'TH6-SYSTEM'
WHERE SequenceName = 'TH6'; -- 6
UPDATE dbo.KeyingSystemTypes
SET CardCaption = '3VE-SYSTEM'
WHERE SequenceName = '3VE'; -- 7
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'SI6-SYSTEM'
WHERE SequenceName = 'SI6'; -- 8
UPDATE dbo.KeyingSystemTypes
SET CardCaption = '2VS-SYSTEM'
WHERE SequenceName = '2VS'; -- 9
UPDATE dbo.KeyingSystemTypes
SET CardCaption = '3VS-SYSTEM'
WHERE SequenceName = '3VS'; -- 10
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'VL-PRIMUS'
WHERE SequenceName = 'Primus_Vl'; -- 11
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'VH-PRIMUS'
WHERE SequenceName = 'Primus_Vh'; -- 12 nicht mehr vorhanden?
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'VX-PRIMUS'
WHERE SequenceName = 'Primus_Vx'; -- 13
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'HX-PRIMUS'
WHERE SequenceName = 'Primus_Hx'; -- 14
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CARAT S1'
WHERE SequenceName = 'Carat_S1'; -- 15
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CARAT S3'
WHERE SequenceName = 'Carat_S3'; -- 16
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CARAT S4'
WHERE SequenceName = 'Carat_S4'; -- 17
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CARAT S5'
WHERE SequenceName = 'Carat_S5'; -- 18
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CSS-SYSTEM'
WHERE SequenceName = 'Carat_Css'; -- 19
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CSS-SYSTEM'
WHERE SequenceName = 'Carat_Css_Manual'; -- 20
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CARAT P1'
WHERE SequenceName = 'Carat_P1';-- 21
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CARAT P2'
WHERE SequenceName = 'Carat_P2';-- 22
UPDATE dbo.KeyingSystemTypes
SET CardCaption = 'CARAT P3'
WHERE SequenceName = 'Carat_P3';-- 23
GO

-- mappings of keying system types aka cylinder profiles and system sequences displaying current system number in keying system sequences
-- keying system numbers are limited to sequences according to cylinder profile used by keying system.
CREATE OR ALTER VIEW dbo.KeyingSystemSequences AS
SELECT DISTINCT kst.Id,
                kst.SequenceName,
                kst.Caption,
                kst.CardCaption CardCaption,
                s.start_value   First,
                s.maximum_value Last,
                s.current_value Currently
FROM sys.sequences s
         JOIN dbo.KeyingSystemTypes kst ON kst.SequenceName = s.name
GO

-- mappings of brand to customers, keying system sequences
CREATE TABLE SecurityCardBrands
(
    Id             uniqueidentifier
        constraint SecurityCardBrands_pk
            primary key,
    Name           nvarchar(122) not null,           -- name of brand on security card
    CustomerNumber nvarchar(22)  not null,           -- customer number of dealer
    HasCard        bit           not null default 0, -- brand or customer has no printed card
    HasAddress     bit           not null default 0, -- no dealer address on card printed
    Text1          nvarchar(122),                    -- name or else
    Text2          nvarchar(122),                    -- street or else
    Text3          nvarchar(122),                    -- postal code with place or else
    Profile        nvarchar(122),                    -- profile name
    Commission     nvarchar(122)                     -- commission or name of sub-dealer
)
GO

-- security card brands´ primary keys
DECLARE @santens uniqueidentifier = newid();
DECLARE @superKljuc uniqueidentifier = newid();
DECLARE @steinbach uniqueidentifier = newid();
DECLARE @boerkey uniqueidentifier = newid();
DECLARE @bst uniqueidentifier = newid();
DECLARE @carat11571 uniqueidentifier = newid();
DECLARE @caratEmler uniqueidentifier = newid();
DECLARE @petersCarat uniqueidentifier = newid();
DECLARE @petersWilka uniqueidentifier = newid();
DECLARE @wilkaCarat uniqueidentifier = newid();
DECLARE @wilkaWilka uniqueidentifier = newid();
INSERT INTO dbo.SecurityCardBrands (Id, CustomerNumber, Name, HasCard, HasAddress, Commission)
VALUES (@santens, '50063', N'Santens', 0, 0, null),     -- 1 Santens Groep
       (@superKljuc, '55902', N'Kljuc', 1, 1, null),    -- 2 Super Klujc Croatia
       (@steinbach, '33005', N'Steinbach', 1, 0, null), -- 3 Steinbach
       (@boerkey, '20473', N'Börkey', 1, 1, null),      -- 4 Börkey
       (@bst, '57804', N'BST', 1, 0, null),             -- 5 BST
       (@carat11571, '11571', N'Carat', 1, 1, null),    -- 6 unbekannt
       (@caratEmler, '15612', N'Carat', 1, 1, 'Emler'), -- 7 Joseph Peters with Emler
       (@petersCarat, '15612', N'Carat', 1, 1, null),   -- 8 Joseph Peters
       (@petersWilka, '15612', N'Wilka', 1, 0, null),   -- 9
       (@wilkaWilka, '', N'Wilka', 1, 0, null),         -- 10 all other customers with Wilka card
       (@wilkaCarat, '', N'Carat', 1, 1, null) -- 11 all other customers with Carat card

CREATE TABLE #secCardBrandKeys
(
    id   uniqueidentifier not null,
    name nvarchar(122)
)
INSERT #secCardBrandKeys(id, name)
VALUES (@santens, '@santens'),
       (@superKljuc, '@superKljuc'),
       (@steinbach, '@steinbach'),
       (@boerkey, '@boerkey'),
       (@bst, '@bst'),
       (@carat11571, '@carat11571'),
       (@caratEmler, '@caratEmler'),
       (@petersCarat, '@petersCarat'),
       (@petersWilka, '@petersWilka'),
       (@wilkaCarat, '@wilkaCarat'),
       (@wilkaWilka, '@wilkaWilka')
GO

-- mappings of SecurityCardBrands to KeyingSystemTypes
CREATE TABLE SecurityCardBrandsToSequenceInfos
(
    Id         int identity
        constraint SecurityCardBrandToSequenceInfo_pk
            primary key,
    BrandId    uniqueidentifier not null
        constraint SecurityCardBrandToSequenceInfo_SecurityCardBrands_Id_fk
            references dbo.SecurityCardBrands
            on update cascade on delete cascade,
    SequenceId uniqueidentifier not null
        constraint SecurityCardBrandToSequenceInfo_SecurityCardSequenceInfo_Id_fk
            references dbo.KeyingSystemTypes
            on update cascade on delete cascade
)
GO

CREATE UNIQUE INDEX SecurityCardBrandsToSequenceInfos_BrandId_SequenceIdId_uindex
    on SecurityCardBrandsToSequenceInfos (BrandId, SequenceId)
GO

-- keying system sequences primary keys 
DECLARE @caratS1 uniqueidentifier = (SELECT Id
                                     FROM dbo.KeyingSystemSequences
                                     WHERE SequenceName = 'Carat_S1');
DECLARE @caratS3 uniqueidentifier = (SELECT Id
                                     FROM dbo.KeyingSystemSequences
                                     WHERE SequenceName = 'Carat_S3');
DECLARE @caratS4 uniqueidentifier = (SELECT Id
                                     FROM dbo.KeyingSystemSequences
                                     WHERE SequenceName = 'Carat_S4');
DECLARE @caratS5 uniqueidentifier = (SELECT Id
                                     FROM dbo.KeyingSystemSequences
                                     WHERE SequenceName = 'Carat_S5');
DECLARE @caratCSS uniqueidentifier =(SELECT Id
                                     FROM dbo.KeyingSystemSequences
                                     WHERE SequenceName = 'Carat_CSS');
DECLARE @caratCSS_manual uniqueidentifier = (SELECT Id
                                             FROM dbo.KeyingSystemSequences
                                             WHERE SequenceName = 'Carat_Css_Manual');
DECLARE @caratP1 uniqueidentifier = (SELECT Id
                                     FROM dbo.KeyingSystemSequences
                                     WHERE SequenceName = 'Carat_P1');
DECLARE @caratP2 uniqueidentifier = (SELECT Id
                                     FROM dbo.KeyingSystemSequences
                                     WHERE SequenceName = 'Carat_P2');
DECLARE @caratP3 uniqueidentifier = (SELECT Id
                                     FROM dbo.KeyingSystemSequences
                                     WHERE SequenceName = 'Carat_P3');

INSERT INTO SecurityCardBrandsToSequenceInfos(BrandId, SequenceId)
VALUES ((SELECT id FROM #secCardBrandKeys WHERE name = '@santens'), @caratS3),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@santens'), @caratS5),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@santens'), @caratP2),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@santens'), @caratP3),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@superKljuc'), @caratS1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@superKljuc'), @caratP1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@superKljuc'), @caratP3),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@boerkey'), @caratS1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@boerkey'), @caratP1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@carat11571'), @caratP1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@carat11571'), @caratP3),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@caratEmler'), @caratS1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@caratEmler'), @caratP1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@caratEmler'), @caratCSS),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@caratEmler'), @caratCSS_manual),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@petersCarat'), @caratS1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@petersCarat'), @caratP1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@petersCarat'), @caratCSS),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@petersCarat'), @caratCSS_manual),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratS1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratS3),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratS4),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratS5),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratCSS),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratCSS_manual),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratP1),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratP2),
       ((SELECT id FROM #secCardBrandKeys WHERE name = '@wilkaCarat'), @caratP3)
GO

-- Corresponds to enum SecurityCardStates, Id must be integer!
create table dbo.SecurityCardStates
(
    Id   int
        constraint SecurityCardState_pk
            primary key nonclustered,
    Name nvarchar(122) not null
)
GO

INSERT into dbo.SecurityCardStates (Id, Name)
Values (1, 'Created'),
       (2, 'ReadyForPrinting'),
       (3, 'Printed'),
       (4, 'Exchanged'),
       (5, 'Replaced'),
       (256, 'Archived');
GO

-- replaces SL508000 Sicherungskarten
create table dbo.SecurityCards
(
    Id                  uniqueidentifier                               not null
        constraint SecurityCards_pk
            primary key nonclustered,
    KeyingSystemId      uniqueidentifier                               null
        constraint SecurityCards___fk_KeyingSystems
            references dbo.KeyingSystems (Id),                              -- SFANL new systems
    KeyingSystemKind    varchar(122),                                       -- SKANA alternative old AS400
    KeyingSystemType    varchar(122),                                       -- SKASY alternative old AS400
    KeyingSystemNumber  varchar(122),                                       -- SFANL alternative old AS400
    OrderNumber         varchar(122),                                       -- SFAUF
    CreatedBy           varchar(122),                                       -- SFBEA
    CustomerNumber      varchar(22),                                        -- SSKDN
    CustomerName        varchar(122),                                       -- SSTX1
    CustomerStreet      varchar(122),                                       -- SSTX2
    CustomerPlace       varchar(122),                                       -- SSTX3
    CardBrandName       varchar(122),                                       -- SKKAR alternative old AS400
    CardBrandId         uniqueidentifier                               null -- SKKAR new systems
        constraint SecurityCards_SecurityCardBrands__fk
            references SecurityCardBrands,
    CopyNumber          int,
    CopyCounter         int,
    DateOfOrder         datetime2,
    Marker              nvarchar(122),
    CopyText            nvarchar(255),                                      -- SKCPY
    LogEmboss           int default 0                                  not null,
    SplitId             nvarchar(122),
    LogProductionDate   datetime2,
    LogProductionResult int,
    Marked              int,
    CardStateId         int default 1                                  not null
        constraint SecurityCards_SecurityCardStates__fk
            references SecurityCardStates (Id),
    PrintSort           int,
    PeriodStart         DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    PeriodEnd           DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    PERIOD FOR SYSTEM_TIME (PeriodStart, PeriodEnd)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.SecurityCardsHistory));
GO

-- Compatibility view for card printer replacing its Access database
CREATE OR ALTER VIEW dbo.CardPrinter AS
SELECT TOP 1000 bc.Id                                                               ID,
                COALESCE(ks.KeyingSystemNumber, bc.KeyingSystemNumber)              SKANL,
                COALESCE(ksk.Name, bc.KeyingSystemKind)                             SKANA,
                COALESCE(kst.Caption, bc.KeyingSystemType, bc.CreatedBy)            SKASY, -- SKBEA in case of separator
                RIGHT(CONCAT(REPLICATE('0', 3), bc.CopyNumber), 3)                  SKNR1,
                ''                                                                  SKFI1,
                RIGHT(CONCAT(REPLICATE('0', 2), bc.CopyCounter), 2)                 SKNR2,
                ''                                                                  SKFI2,
                RIGHT(FORMAT(COALESCE(bc.DateOfOrder, o.OrderDate), 'ddMMyyyy'), 8) SKBDT,
                ''                                                                  SKFI3,
                bc.Marker                                                           SKWIL, -- WK 
                bc.CopyText                                                         SKCPY,
                bc.CreatedBy                                                        SKBEA,
                bc.CardBrandName                                                    SKKAR,
                bc.CustomerName                                                     SKTX1,
                bc.CustomerStreet                                                   SKTX2,
                bc.CustomerPlace                                                    SKTX3,
                bc.LogEmboss                                                        M_Log_Emboss,
                bc.SplitId                                                          M_Split_Id,
                bc.LogProductionDate                                                M_LogProductionDate,
                bc.LogProductionResult                                              M_LogProductionResult,
                bc.Marked                                                           M_Marked
FROM dbo.SecurityCards bc
         LEFT JOIN dbo.KeyingSystems ks on bc.KeyingSystemId = ks.Id
         LEFT JOIN dbo.KeyingSystemKinds ksk on ksk.Id = ks.KeyingSystemKindId -- employee records without system kind
         LEFT JOIN dbo.KeyingSystemTypes kst on kst.Id = ks.KeyingSystemTypeId -- employee records without system type
         JOIN dbo.SecurityCardStates scs on scs.Id = bc.CardStateId
         LEFT JOIN dbo.SecurityCardBrands scb on scb.Id = bc.CardBrandId
         LEFT JOIN dbo.Orders o on o.KeyingSystemId = ks.Id
WHERE bc.CardStateId = 2 -- SecurityCardStateValue.ReadyForPrinting
  AND bc.LogProductionDate IS NULL
ORDER BY bc.PrintSort
GO

-- Instead of DELETE triggered by Maticard Pro after printing cards
CREATE OR ALTER TRIGGER DeleteCardPrinterTrigger
    ON dbo.CardPrinter
    INSTEAD OF DELETE
    AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @systemNr nvarchar(122);
    SELECT @systemNr = DELETED.SKANL FROM DELETED;

    DECLARE @id uniqueidentifier;
    SELECT @id = DELETED.Id FROM DELETED;

    IF @systemNr = '1' -- delete separator card record
        BEGIN
            DELETE FROM dbo.SecurityCards WHERE Id = @id;
        END
    ELSE
        BEGIN
            UPDATE dbo.SecurityCards
            SET CardStateId         = (SELECT Id FROM dbo.SecurityCardStates WHERE lower(Name) = 'printed'),
                PrintSort           = null,
                LogProductionDate   = getdate(),
                LogProductionResult = 1
            WHERE Id = @id;
        END
END
GO

-- Instead of UPDATE trigger of Maticard Pro after printing cards
CREATE OR ALTER TRIGGER UpdateCardPrinterTrigger
    ON dbo.CardPrinter
    INSTEAD OF UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id nvarchar(122);
    SELECT @id = INSERTED.Id FROM INSERTED;
    PRINT ('Updating CardPrint ' + @id);
    IF UPDATE(M_LogProductionDate)
        BEGIN
            DECLARE @prodDate datetime2;
            SELECT @prodDate = INSERTED.M_LogProductionDate FROM INSERTED WHERE INSERTED.ID = @id;
            PRINT ('Updating CardPrint M_LogProductionDate ' + cast(@prodDate as varchar(122)));

            DECLARE @prodResult int;
            SELECT @prodResult = INSERTED.M_LogProductionResult FROM INSERTED WHERE INSERTED.ID = @id;
            UPDATE dbo.SecurityCards
            SET LogProductionDate   = @prodDate,
                LogProductionResult = @prodResult
            WHERE Id = @id;
        END
END
GO

-- Sicherungskarten Sondertexte execute only manually on production
-- CREATE VIEW SL508101 AS
-- SELECT * FROM [AS400].[S65661EF].[SLDAT].[SL508101]
-- GO

-- Sicherungskartenausgabe Prüfdatei execute only manually on production
-- CREATE VIEW SL508201 AS
-- SELECT * FROM [AS400].[S65661EF].[SLDAT].[SL508201]
-- GO

-- additional customer addresses for Carat security cards, replaces AS400 DB2 SL508101
-- needs refactoring to customer table and related 1:n profile/commision table

DROP VIEW IF EXISTS dbo.SecurityCardCustomers
GO

-- additional compatibility view of special customer adresses of AS400
CREATE OR ALTER VIEW dbo.SecurityCardCustomersAS400
AS
SELECT scb.Id,                   -- additional Id
       scb.CustomerNumber SSKDN, -- Kundennummer
       scb.Text1          SSTX1, -- Kundenname
       scb.Text2          SSTX2, -- Straße
       scb.Text3          SSTX3, -- Ort
       scb.Profile        SSPRO, -- Profil obsolete
       scb.Commission     SSKOM  -- Kommission z.B. Emmler
FROM dbo.SecurityCardBrands scb
GO

DROP VIEW IF EXISTS dbo.SecurityCardLog
GO

-- additional log of issued security cards, replaces AS400 DB2 SL508201
CREATE OR ALTER VIEW dbo.SecurityCardLogAS400
AS
SELECT sc.Id,                                                       -- additional Id
       COALESCE(sc.KeyingSystemNumber, ks.KeyingSystemNumber) SFANL,-- Anlagennummer
       sc.OrderNumber                                         SFAUF,-- Auftragsnummer
       YEAR(sc.DateOfOrder)                                   SFJJ, -- Kartendruck Jahr
       MONTH(sc.DateOfOrder)                                  SFMM, -- Kartendruck Monat
       DAY(sc.DateOfOrder)                                    SFTT, -- Kartendruck Tag
       sc.CreatedBy                                           SFBEA -- Sachbearbeiter
FROM dbo.SecurityCards sc
         LEFT JOIN dbo.KeyingSystems ks on ks.Id = sc.KeyingSystemId
         JOIN dbo.SecurityCardStates scs on scs.Id = sc.CardStateId
WHERE scs.Id >= (SELECT Id from SecurityCardStates scs2 WHERE LOWER(scs2.Name) = 'printed') --printed
  AND ks.KeyingSystemNumber <> '1' -- not separator record
GO


-- Verknüpfungstabelle SecurityCardBrands und KeyingSystemSequences/sequences
-- SELECT * FROM dbo.SecurityCardBrands scb;

-- mapping of brands or special customers of security cards to keying system sequences
-- displays which names of system sequences are mapped to a special customer or key account 
-- and its settings related to printing of security cards
CREATE OR ALTER VIEW dbo.SecurityCardBrandInfos AS
SELECT DISTINCT scb.*,
                (SELECT STRING_AGG(kst2.SequenceName, ',')
                 from dbo.SecurityCardBrandsToSequenceInfos scbtsi2
                          JOIN dbo.KeyingSystemTypes kst2 ON scbtsi2.SequenceId = kst2.Id
                 WHERE scbtsi2.BrandId = scb.Id) AS SystemSequences
FROM dbo.SecurityCardBrands scb
         LEFT JOIN dbo.SecurityCardBrandsToSequenceInfos scbtsi on scbtsi.BrandId = scb.Id
         LEFT JOIN dbo.KeyingSystemTypes kst on kst.Id = scbtsi.SequenceId
GO
