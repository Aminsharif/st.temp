Alter table CharacteristicClassifications
    add
        Created datetime2 not null default GETUTCDATE(),
        CreatedBy nvarchar(255) not null default 'Script',
        LastUpdated datetime2,
        UpdatedBy nvarchar(255)
GO

declare @name as nvarchar(255);
SELECT @name = name
FROM dbo.sysobjects
WHERE name LIKE 'DF__SecurityC__LogEm%'

IF @name IS NOT NULL
    BEGIN
        EXEC ('ALTER TABLE SecurityCards DROP CONSTRAINT ' + @name);
    END
Go

alter table SecurityCards
    alter column LogEmboss int not null
Go

ALTER VIEW [dbo].[vwSecurityCardPrintQueue] AS
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
                                     sc.LogProductionResult,
                                     sc.SequenceNumber,
                                     sc.CopyNumber,
                                     kst.CardCaption
                              FROM dbo.SecurityCards sc
                                       INNER JOIN KeyingSystems ks on sc.KeyingSystemId = ks.Id
                                       INNER JOIN KeyingSystemKinds ksk
                                                  on ksk.Id = ks.KeyingSystemKindId -- employee records without system kind
                                       INNER JOIN KeyingSystemTypes kst
                                                  on kst.Id = ks.KeyingSystemTypeId -- employee records without system type      
                                       INNER JOIN Orders o on o.KeyingSystemId = ks.Id
                                  -- This Cross Apply is in order to get the latest state entry     
                                       Cross Apply (
                                  Select TOP 1 SecurityCardState, Created
                                  from SecurityCardStateHistories
                                  where SecurityCardId = sc.Id
                                  order by Created desc
                              ) SecurityHistory
                              Where SecurityHistory.SecurityCardState = 1
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
         securityCardBatches as (
             select *
             from securityCardsByCreator
             union all
             select *
             from securityCardSeparators
             where securityCardSeparators.lastId = securityCardSeparators.Id
         )

--- Step 3 : Prepare the data so that it is suitable for the Maticard Software
--- Since we have to order the data we need a "Select Top" otherwise SQL Server does not want to create a view since order and stuff are not allowed in a view
    SELECT Top 10000 Id                                                                           ID,
                     IIF(isSeparator = 1, null, KeyingSystemNumber)                               SKANL,
                     IIF(isSeparator = 1, null, Name)                                             SKANA,
                     IIF(isSeparator = 1, CreatedBy, CardCaption)                                 SKASY,                -- SKBEA in case of separator
                     IIF(isSeparator = 1, null,
                         RIGHT('000' + CAST(SequenceNumber AS NVARCHAR(3)), 3))                   SKNR1,                -- Copy Number
                     IIF(isSeparator = 1, null, '')                                               SKFI1,
                     IIF(isSeparator = 1, null, RIGHT('00' + CAST(CopyNumber AS NVARCHAR(2)), 2)) SKNR2,                -- Copy Counter
                     IIF(isSeparator = 1, null, '')                                               SKFI2,
                     IIF(isSeparator = 1, null, RIGHT(FORMAT(OrderDate, 'ddMMyyyy'), 8))          SKBDT,
                     IIF(isSeparator = 1, null, '')                                               SKFI3,
                     IIF(isSeparator = 1, null, 'WK')                                             SKWIL,                -- WK 
                     IIF(isSeparator = 1, null, CopyText)                                         SKCPY,
                     IIF(isSeparator = 1, null, CreatedBy)                                        SKBEA,
                     IIF(isSeparator = 1, null, 'Wilka')                                          SKKAR,
                     IIF(isSeparator = 1, null, CustomerName)                                     SKTX1,
                     IIF(isSeparator = 1, null, CustomerStreet)                                   SKTX2,
                     IIF(isSeparator = 1, null, CustomerPlace)                                    SKTX3,
                     IIF(isSeparator = 1, 0, LogEmboss)                                           M_Log_Emboss,
                     IIF(isSeparator = 1, null, '')                                               M_Split_Id,
                     IIF(isSeparator = 1, null, CAST(LogProductionDate AS datetime))              M_LogProductionDate,  --Datetime in Maticard sw
                     IIF(isSeparator = 1, null, LogProductionResult)                              M_LogProductionResult,--INT in Maticard sw
                     0                                                                            M_Marked              --INT in Maticard sw
    from securityCardBatches
    order by CreatedBy, isSeparator, sortOrder
Go