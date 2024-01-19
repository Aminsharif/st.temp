drop trigger DeleteCardPrinterTrigger
Go

drop trigger UpdateCardPrinterTrigger
Go

drop view SecurityCardCustomersAS400
Go

drop view SecurityCardBrandInfos
Go

drop view SecurityCardLogAS400
Go

drop view CardPrinter
Go

drop table SecurityCardBrandsToSequenceInfos
Go

ALTER TABLE [dbo].SecurityCards
    SET (SYSTEM_VERSIONING = OFF)
Go
drop table SecurityCardsHistory
GO

drop table SecurityCards
GO

drop table SecurityCardBrands
Go

drop table SecurityCardStates
Go

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

create table dbo.SecurityCards
(
    Id                        uniqueidentifier primary key not null,
    KeyingSystemId            uniqueidentifier
        constraint FK_SecurityCards_KeyingSystems
            references KeyingSystems,                                                        -- SFANL new systems
    OrderId                   uniqueidentifier
        constraint FK_SecurityCards_Order references Orders,
    Created                   datetime2                    not null default GETUTCDATE(),
    CreatedBy                 nvarchar(256),                                                 -- SFBEA
    CustomerNumber            nvarchar(256)                not null,                         -- SSKDN
    CustomerName              nvarchar(256),                                                 -- SSTX1
    CustomerStreet            nvarchar(256),                                                 -- SSTX2
    CustomerPlace             nvarchar(256),                                                 -- SSTX3
    SecurityCardBrandId       uniqueidentifier                                               -- SKKAR new systems
        constraint FK_SecurityCards_SecurityCardBrands
            references SecurityCardBrands,
    CopyText                  nvarchar(255),                                                 -- SKCPY
    LogEmboss                 bit                                   default 0 not null,
    LogProductionDate         dateTime2,
    LogProductionResult       nvarchar(255),
    ReplacementSecurityCardId uniqueidentifier
        constraint FK_SecurityCards_SecurityCards_Replacement references SecurityCards (Id), -- Card which replaced this card
    ReplacementReason         int,
    SequenceNumber            int                          not null,
    CopyNumber                int                          not null,
    Comment                   nvarchar(max),
)
GO

create table dbo.SecurityCardStateHistories
(
    Id                uniqueidentifier primary key not null,
    SecurityCardId    uniqueidentifier             not null
        constraint FK_SecurityCardStateHistory_SecurityCard
            references SecurityCards on delete cascade,
    SecurityCardState int                          not null default 1,
    CreatedBy         nvarchar(255)                not null,
    Created           datetime2                    not null default GETUTCDATE()
)

Go

DECLARE @santens     uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A0'
DECLARE @superKljuc  uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A1'
DECLARE @steinbach   uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A2'
DECLARE @boerkey     uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A3'
DECLARE @bst         uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A4'
DECLARE @carat11571  uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A5'
DECLARE @caratEmler  uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A6'
DECLARE @petersCarat uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A7'
DECLARE @petersWilka uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A8'
DECLARE @wilkaCarat  uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83A9'
DECLARE @wilkaWilka  uniqueidentifier = '34FEF313-AF71-4EBD-81BD-4DFCB85A83AA'

INSERT INTO SecurityCardBrands (Id, CustomerNumber, Name, HasCard, HasAddress, Commission)
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
GO

-- Compatibility view for card printer replacing its Access database
CREATE OR ALTER VIEW vwSecurityCardPrintQueue AS
-- Step 1: Getting all data required
With securityCardData as (SELECT sc.Id,
                                 ks.KeyingSystemNumber,
                                 ksk.Name,
                                 sc.CreatedBy,
                                 SecurityHistory.Created,
                                 o.OrderDate,
                                 sc.CopyText,
                                 sc.CustomerName,
                                 sc.CustomerStreet,
                                 sc.CustomerPlace,
                                 sc.LogEmboss,
                                 sc.LogProductionDate,
                                 sc.LogProductionResult
                          FROM dbo.SecurityCards sc
                                   INNER JOIN KeyingSystems ks on sc.KeyingSystemId = ks.Id
                                   INNER JOIN KeyingSystemKinds ksk
                                              on ksk.Id = ks.KeyingSystemKindId -- employee records without system kind
                                   INNER JOIN KeyingSystemTypes kst
                                              on kst.Id = ks.KeyingSystemTypeId -- employee records without system type      
                                   INNER JOIN Orders o on o.KeyingSystemId = ks.Id
                              -- This Cross Apply is in order to get the latest state entry     
                                   Cross Apply (Select TOP 1 SecurityCardState, Created
                                                from SecurityCardStateHistories
                                                where SecurityCardId = sc.Id
                                                order by Created desc) SecurityHistory
                          Where SecurityHistory.SecurityCardState = 2
                            AND sc.LogProductionDate IS NULL),

     -- Step 2: Prepare Data so that items to be printed are in the order of the "to be printed" state has been set for each Creator of the security card
     --         Then find the last element of the batch which will be our separator card
     --         Finally merge the data and order it in that way that the separator is at the end of each batch
     securityCardsByCreator as (select *,
                                       0                                                           isSeparator,
                                       null                                                        lastId,
                                       ROW_NUMBER() over (PARTITION BY CreatedBy order by Created) sortOrder
                                from securityCardData),
     securityCardSeparators as (select *,
                                       1                                                                                                                   isSeparator,
                                       Last_VALUE(Id)
                                                  Over (Partition by CreatedBy order by Created Range between unbounded Preceding and Unbounded Following) lastId,
                                       null                                                                                                                sortOrder


                                from securityCardData),
     securityCardBatches as (select *
                             from securityCardsByCreator
                             union all
                             select *
                             from securityCardSeparators
                             where securityCardSeparators.lastId = securityCardSeparators.Id)

--- Step 3 : Prepare the data so that it is suitable for the Maticard Software
--- Since we have to order the data we need a "Select Top" otherwise SQL Server does not want to create a view since order and stuff are not allowed in a view
SELECT Top 10000 Id                                      ID,
                 KeyingSystemNumber                      SKANL,
                 Name                                    SKANA,
                 Case
                     When isSeparator = 1 THEN CreatedBy
                     END as                              SKASY, -- SKBEA in case of separator
                 '000'                                   SKNR1, -- Copy Number
                 ''                                      SKFI1,
                 '00'                                    SKNR2, -- Copy Counter
                 ''                                      SKFI2,
                 RIGHT(FORMAT(OrderDate, 'ddMMyyyy'), 8) SKBDT,
                 ''                                      SKFI3,
                 'WK'                                    SKWIL, -- WK 
                 CopyText                                SKCPY,
                 CreatedBy                               SKBEA,
                 'Wilka'                                 SKKAR,
                 CustomerName                            SKTX1,
                 CustomerStreet                          SKTX2,
                 CustomerPlace                           SKTX3,
                 LogEmboss                               M_Log_Emboss,
                 ''                                      M_Split_Id,
                 LogProductionDate                       M_LogProductionDate,
                 LogProductionResult                     M_LogProductionResult,
                 ''                                      M_Marked
from securityCardBatches
order by CreatedBy, isSeparator, sortOrder
GO

-- Instead of DELETE triggered by Maticard Pro after printing cards
CREATE TRIGGER DeletePrintQueueTrigger
    ON dbo.vwSecurityCardPrintQueue
    INSTEAD OF DELETE
    AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id uniqueidentifier;
    SELECT @id = DELETED.Id FROM DELETED;

    insert into SecurityCardStateHistories (Id, SecurityCardId, SecurityCardState, CreatedBy)
    Values (NEWID(), @id, 3, 'Makidata')

    UPDATE dbo.SecurityCards
    SET LogProductionDate   = GETUTCDATE(),
        LogProductionResult = 1
    WHERE Id = @id;
END
GO

-- Instead of UPDATE trigger of Maticard Pro after printing cards
CREATE TRIGGER UpdatePrintQueueTrigger
    ON dbo.vwSecurityCardPrintQueue
    INSTEAD OF UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id uniqueidentifier;
    SELECT @id = INSERTED.Id FROM INSERTED;
    IF UPDATE(M_LogProductionDate)
        BEGIN
            DECLARE @prodDate datetime2;
            SELECT @prodDate = INSERTED.M_LogProductionDate FROM INSERTED WHERE INSERTED.ID = @id;

            DECLARE @prodResult nvarchar(255);
            SELECT @prodResult = INSERTED.M_LogProductionResult FROM INSERTED WHERE INSERTED.ID = @id;

            UPDATE dbo.SecurityCards
            SET LogProductionDate   = @prodDate,
                LogProductionResult = @prodResult
            WHERE Id = @id;
        END
END
GO

Create Procedure spReplaceSecurityCard(
    @replacementSecurityCardId uniqueidentifier, -- Card to replace
    @orderId uniqueidentifier, -- current order
    @customerNumber nvarchar(255),
    @customerName nvarchar(255),
    @customerStreet nvarchar(255),
    @customerPlace nvarchar(255),
    @replacementReason int,
    @createdBy nvarchar(255),
    @newSecurityCardId uniqueidentifier OUTPUT)
As
BEGIN

    Begin Transaction
        Set @newSecurityCardId = NEWID()

-- Create new card
        insert into SecurityCards (Id,
                                   KeyingSystemId,
                                   OrderId,
                                   Created,
                                   CreatedBy,
                                   CustomerNumber,
                                   CustomerName,
                                   CustomerStreet,
                                   CustomerPlace,
                                   SecurityCardBrandId,
                                   CopyText,
                                   LogEmboss,
                                   LogProductionDate,
                                   LogProductionResult,
                                   ReplacementSecurityCardId,
                                   ReplacementReason,
                                   SequenceNumber,
                                   CopyNumber,
                                   Comment)
        select @newSecurityCardId         Id,
               KeyingSystemId,
               @orderId                   OrderId,
               GETUTCDATE()               Created,
               @createdBy                 CreatedBy,
               @customerNumber            CustomerNumber,
               @customerName              CustomerName,
               @customerStreet            CustomerStreet,
               @customerPlace             CustomerPlace,
               SecurityCardBrandId,
               CopyText,
               LogEmboss,
               null                       LogProductionDate,
               null                       LogProductionResult,
               @replacementSecurityCardId ReplacementSecurityCardId,
               ReplacementReason,
               SequenceNumber + 1,
               CopyNumber,
               Comment
        from SecurityCards
        where Id = @replacementSecurityCardId

-- set state to created
        insert into SecurityCardStateHistories (Id,
                                                SecurityCardId,
                                                SecurityCardState,
                                                CreatedBy,
                                                Created)
        values (NewId(), @newSecurityCardId, 1, @createdBy, GETUTCDATE())

-- set old card as replacement reason
        update SecurityCards
        set ReplacementReason = @replacementReason
        where Id = @replacementSecurityCardId

-- set state of old card as replaced
        insert into SecurityCardStateHistories (Id,
                                                SecurityCardId,
                                                SecurityCardState,
                                                CreatedBy,
                                                Created)
        values (NewId(), @replacementSecurityCardId, 5, @createdBy, GETUTCDATE())
    Commit TRANSACTION
End

GO

Create Procedure spCloneSecurityCard(
    @cloneSecurityCardId uniqueidentifier, -- Card to replace    
    @replacementReason int,
    @createdBy nvarchar(255),
    @newSecurityCardId uniqueidentifier OUTPUT)
As
BEGIN

    Begin Transaction
        Set @newSecurityCardId = NEWID()

-- Create new card
        insert into SecurityCards (Id,
                                   KeyingSystemId,
                                   OrderId,
                                   Created,
                                   CreatedBy,
                                   CustomerNumber,
                                   CustomerName,
                                   CustomerStreet,
                                   CustomerPlace,
                                   SecurityCardBrandId,
                                   CopyText,
                                   LogEmboss,
                                   LogProductionDate,
                                   LogProductionResult,
                                   ReplacementSecurityCardId,
                                   ReplacementReason,
                                   SequenceNumber,
                                   CopyNumber,
                                   Comment)
        select @newSecurityCardId   Id,
               KeyingSystemId,
               null                 OrderId,
               GETUTCDATE()         Created,
               @createdBy           CreatedBy,
               CustomerNumber       CustomerNumber,
               CustomerName,
               CustomerStreet,
               CustomerPlace,
               SecurityCardBrandId,
               CopyText,
               LogEmboss,
               null                 LogProductionDate,
               null                 LogProductionResult,
               @cloneSecurityCardId ReplacementSecurityCardId,
               ReplacementReason,
               SequenceNumber,
               CopyNumber,
               Comment
        from SecurityCards
        where Id = @cloneSecurityCardId

-- set state to created
        insert into SecurityCardStateHistories (Id,
                                                SecurityCardId,
                                                SecurityCardState,
                                                CreatedBy,
                                                Created)
        values (NewId(), @newSecurityCardId, 1, @createdBy, GETUTCDATE())

-- set old card as replacement reason
        update SecurityCards
        set ReplacementReason = @replacementReason
        where Id = @cloneSecurityCardId

-- set state of old card as replaced
        insert into SecurityCardStateHistories (Id,
                                                SecurityCardId,
                                                SecurityCardState,
                                                CreatedBy,
                                                Created)
        values (NewId(), @cloneSecurityCardId, 5, @createdBy, GETUTCDATE())
    Commit TRANSACTION
End

GO

Create Procedure spCopySecurityCard(
    @copySecurityCardId uniqueidentifier, -- Card which is to copy
    @orderId uniqueidentifier, -- current Order
    @customerNumber nvarchar(255),
    @customerName nvarchar(255),
    @customerStreet nvarchar(255),
    @customerPlace nvarchar(255),
    @createdBy nvarchar(255),
    @newSecurityCardId uniqueidentifier OUTPUT)
As
BEGIN
    Begin Transaction
        Set @newSecurityCardId = NEWID()

        Declare @keyingSystemId uniqueidentifier
        select @keyingSystemId = KeyingSystemId from Orders where Id = @orderId

        If not exists(select * from KeyingSystems where Id = @keyingSystemId)
            Begin
                RAISERROR (N'KeyingSystem does not exist for order.', -- Message text.  
                    11, -- Severity does not exist,  
                    1 -- State,  
                    );
            end

        Declare @copyCount int
        select @copyCount = max(CopyNumber) from SecurityCards where KeyingSystemId = @keyingSystemId

        -- Create new card
        insert into SecurityCards (Id,
                                   KeyingSystemId,
                                   OrderId,
                                   Created,
                                   CreatedBy,
                                   CustomerNumber,
                                   CustomerName,
                                   CustomerStreet,
                                   CustomerPlace,
                                   SecurityCardBrandId,
                                   CopyText,
                                   LogEmboss,
                                   LogProductionDate,
                                   LogProductionResult,
                                   ReplacementSecurityCardId,
                                   ReplacementReason,
                                   SequenceNumber,
                                   CopyNumber,
                                   Comment)
        select @newSecurityCardId  Id,
               KeyingSystemId,
               @orderId            OrderId,
               GETUTCDATE()        Created,
               @createdBy          createdBy,
               @customerNumber     CustomerNumber,
               @customerName       CustomerName,
               @customerStreet     CustomerStreet,
               @customerPlace      CustomerPlace,
               SecurityCardBrandId,
               CopyText,
               LogEmboss,
               null                LogProductionDate,
               null                LogProductionResult,
               @copySecurityCardId ReplacementSecurityCardId,
               ReplacementReason,
               SequenceNumber,
               @copyCount + 1,
               null                Comment

        from SecurityCards
        where Id = @copySecurityCardId

        -- set state to created
        insert into SecurityCardStateHistories (Id,
                                                SecurityCardId,
                                                SecurityCardState,
                                                CreatedBy,
                                                Created)
        values (NewId(), @newSecurityCardId, 1, @createdBy, GETUTCDATE())
    Commit TRANSACTION
End
GO