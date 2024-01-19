--- Ensures that SecurityCards is a temporal table and has columns PeriodStart, PeriodEnd

--- recreate table to ensure complete temporal table
IF NOT EXISTS(SELECT 1
              FROM sys.columns
              WHERE Name = N'PeriodStart'
                AND Object_ID = Object_ID(N'dbo.SecurityCards')) OR
   NOT EXISTS(SELECT 1
              FROM sys.columns
              WHERE Name = N'PeriodEnd'
                AND Object_ID = Object_ID(N'dbo.SecurityCards'))
    BEGIN
        IF EXISTS(SELECT 1 FROM sys.tables WHERE object_id = Object_ID(N'dbo.SecurityCards'))
            BEGIN
                ALTER TABLE dbo.SecurityCards
                    SET (SYSTEM_VERSIONING = OFF)
                DROP TABLE dbo.SecurityCards
                DROP TABLE dbo.SecurityCardsHistory
            END

        CREATE TABLE dbo.SecurityCards
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
    END
GO