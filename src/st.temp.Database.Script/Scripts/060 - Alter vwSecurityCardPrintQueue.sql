alter table SecurityCards
    ALTER COLUMN LogProductionResult int;
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
                                     sc.LogProductionResult
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
    SELECT Top 10000 Id                                      ID,
                     KeyingSystemNumber                      SKANL,
                     Name                                    SKANA,
                     Case
                         When isSeparator = 1 THEN CreatedBy
                         END as                              SKASY,                -- SKBEA in case of separator
                     '000'                                   SKNR1,                -- Copy Number
                     ''                                      SKFI1,
                     '00'                                    SKNR2,                -- Copy Counter
                     ''                                      SKFI2,
                     RIGHT(FORMAT(OrderDate, 'ddMMyyyy'), 8) SKBDT,
                     ''                                      SKFI3,
                     'WK'                                    SKWIL,                -- WK 
                     CopyText                                SKCPY,
                     CreatedBy                               SKBEA,
                     'Wilka'                                 SKKAR,
                     CustomerName                            SKTX1,
                     CustomerStreet                          SKTX2,
                     CustomerPlace                           SKTX3,
                     CAST(LogEmboss AS INT)                  M_Log_Emboss,--INT in Maticard sw
                     ''                                      M_Split_Id,
                     CAST(LogProductionDate AS datetime)     M_LogProductionDate,  --Datetime in Maticard sw
                     LogProductionResult                     M_LogProductionResult,--INT in Maticard sw
                     0                                       M_Marked              --INT in Maticard sw
    from securityCardBatches
    order by CreatedBy, isSeparator, sortOrder
Go