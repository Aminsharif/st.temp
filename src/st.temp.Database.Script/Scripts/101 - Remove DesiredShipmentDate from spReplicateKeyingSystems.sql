Alter Procedure spReplicateKeyingSystem(
    @keyingSystemId uniqueidentifier,
    @replicationCounter int,
    @createdBy nvarchar(256))
As
Begin
    -- check keying system
    If not exists(select *
                  from KeyingSystems
                  where Id = @keyingSystemId)
        Begin
            RAISERROR (N'KeyingSystem does not exist.', -- Message text.  
                11, -- Severity does not exist,  
                1, -- State,  
                '');
        end

    Create TABLE #TempCylinderEntriesWithNewIds
    (
        Id          uniqueidentifier,
        ParentId    uniqueidentifier,
        NewId       uniqueidentifier,
        NewParentId UNIQUEIDENTIFIER,
        Position    int
    )
    Create TABLE #TempSuperordinateKeysWithNewIds
    (
        Id          uniqueidentifier,
        ParentId    uniqueidentifier,
        NewId       uniqueidentifier,
        NewParentId UNIQUEIDENTIFIER,
        Position    int
    )

    Declare @keyingSystemKindId uniqueidentifier
    Declare @keyingSystemTypeId uniqueidentifier
    Declare @keyNumberingType int
    DECLARE @newKeyingSystemId uniqueidentifier

    select @keyingSystemKindId = KeyingSystemKindId,
           @keyingSystemTypeId = KeyingSystemTypeId,
           @keyNumberingType = KeyNumberingType
    from KeyingSystems
    where Id = @keyingSystemId

    create table #KeyingSystemsCreated
    (
        Id uniqueidentifier
    )

    Declare @counter int = 0
    Begin Transaction
        while(@counter < @replicationCounter)
            Begin

                -- Create Keying System
                exec CreateKeyingSystem @keyingSystemTypeId, @keyingSystemKindId, @createdBy, @keyNumberingType,
                     @newKeyingSystemId out

                insert into #KeyingSystemsCreated (Id) Values (@newKeyingSystemId)

                -- Create Order for that keying System
                Declare @newOrderId uniqueidentifier = NEWID()

                insert into Orders (Id, KeyingSystemId, OrderNumber, OrderNumberProAlpha, CustomerIdProAlpha, Note,
                                    ShipmentDate, OrderType, CreatedBy, Created, UpdatedBy,
                                    LastUpdated, OrderKind, OrderDate, ShippingAddress_Name1, ShippingAddress_Name2,
                                    ShippingAddress_Street, ShippingAddress_HouseNumber, ShippingAddress_Country,
                                    ShippingAddress_City,
                                    ShippingAddress_PostalCode, ShipmentTermsIdProAlpha, ShippingMethodIdProAlpha,
                                    KeyNumberingPrice,
                                    CustomerOrderNumber, AdditionalKeyCost)
                select @newOrderId
                     , @newKeyingSystemId
                     , 0
                     , null
                     , CustomerIdProAlpha
                     , Note
                     , ShipmentDate
                     , OrderType
                     , @createdBy
                     , GETUTCDATE()
                     , null
                     , null
                     , OrderKind
                     , [OrderDate]
                     , [ShippingAddress_Name1]
                     , [ShippingAddress_Name2]
                     , [ShippingAddress_Street]
                     , [ShippingAddress_HouseNumber]
                     , [ShippingAddress_Country]
                     , [ShippingAddress_City]
                     , [ShippingAddress_PostalCode]
                     , [ShipmentTermsIdProAlpha]
                     , [ShippingMethodIdProAlpha]
                     , COALESCE(ci.DefaultKeyNumberingPrice, KeyNumberingPrice) KeyNumberingPrice
                     , CustomerOrderNumber
                     , AdditionalKeyCost
                from Orders
                         inner join CustomerInformation ci on CustomerIdProAlpha = ci.Id
                where KeyingSystemId = @keyingSystemId
                  and OrderKind = 0

                -- Order State
                insert into OrderStates (Id, OrderId, Value, Created, CreatedBy)
                Values (NEWID(), @newOrderId, 0, GETUTCDATE(), @createdBy)

                -- CylinderEntries
                -- Temp Table to track cylinder Entries with new Ids
                ;
                WITH CylinderEntriesForKeyingSystem
                         AS (SELECT Id, ParentCylinderEntryId, 0 as Position
                             FROM CylinderEntries
                             WHERE ParentCylinderEntryId IS NULL
                               AND KeyingSystemId = @keyingSystemId
                             UNION ALL
                             SELECT CylinderEntries.Id,
                                    CylinderEntries.ParentCylinderEntryId,
                                    CylinderEntriesForKeyingSystem.Position + 1
                             FROM CylinderEntries
                                      INNER JOIN CylinderEntriesForKeyingSystem
                                                 ON CylinderEntries.ParentCylinderEntryId =
                                                    CylinderEntriesForKeyingSystem.Id
                             WHERE CylinderEntries.ParentCylinderEntryId IS NOT NULL
                               AND CylinderEntries.KeyingSystemId = @keyingSystemId),
                     CylinderEntriesWithNewId as (select *, NEWID() as NewId
                                                  from CylinderEntriesForKeyingSystem)
                insert
                into #TempCylinderEntriesWithNewIds
                select Id, ParentCylinderEntryId, NewId, Lag(NewId) OVER ( Order by Position ) NewParentId, Position
                from CylinderEntriesWithNewId

                ---- Migrate CylinderEntries
                ;
                With NewCylinderEntries as (select t.NewId            Id,
                                                   @newOrderId        OrderId,
                                                   @newKeyingSystemId KeyingSystemId,
                                                   Locking,
                                                   DoorNumber,
                                                   Description,
                                                   CylindersCount,
                                                   KeysCount,
                                                   BackSet,
                                                   PartNumber,
                                                   LengthA,
                                                   LengthB,
                                                   Color,
                                                   @createdBy         CreatedBy,
                                                   GETUTCDATE()       Created,
                                                   null               UpdatedBy,
                                                   null               LastUpdated,
                                                   Price,
                                                   t.NewParentId      ParentCylinderEntryId,
                                                   null               LockwizId,
                                                   PartVariantNumber,
                                                   KeyLabel,
                                                   t.Position
                                            from CylinderEntries
                                                     inner join #TempCylinderEntriesWithNewIds t on CylinderEntries.Id = t.Id
                                            where KeyingSystemId = @keyingSystemId)
                insert
                into CylinderEntries (Id, OrderId, KeyingSystemId, Locking, DoorNumber, Description, CylindersCount,
                                      KeysCount, BackSet, PartNumber, LengthA, LengthB, Color, CreatedBy, Created,
                                      UpdatedBy, LastUpdated, Price, ParentCylinderEntryId, LockwizId,
                                      PartVariantNumber, KeyLabel)
                select Id,
                       OrderId,
                       KeyingSystemId,
                       Locking,
                       DoorNumber,
                       Description,
                       CylindersCount,
                       KeysCount,
                       BackSet,
                       PartNumber,
                       LengthA,
                       LengthB,
                       Color,
                       CreatedBy,
                       Created,
                       UpdatedBy,
                       LastUpdated,
                       Price,
                       ParentCylinderEntryId,
                       LockwizId,
                       PartVariantNumber,
                       KeyLabel
                From NewCylinderEntries
                order by Position

                -- Migrate AdditionalEquipmentCylinderEntry
                insert into AdditionalEquipmentCylinderEntry (Id, AdditionalEquipmentsId, CylinderEntriesId)
                select NewId(), a.AdditionalEquipmentsId, temp.NewId
                from #TempCylinderEntriesWithNewIds temp
                         inner join AdditionalEquipmentCylinderEntry a on temp.Id = a.CylinderEntriesId

                --            -- SuperordinateKeys
                --            -- Temp Table to track cylinder Entries with new Ids
                ;
                WITH CylinderSuperordinateKeysForKeyingSystem
                         AS (SELECT Id, ParentSuperordinateKeyId, 0 as Position
                             FROM SuperordinateKeys
                             WHERE ParentSuperordinateKeyId IS NULL
                               AND KeyingSystemId = @keyingSystemId
                             UNION ALL
                             SELECT SuperordinateKeys.Id,
                                    SuperordinateKeys.ParentSuperordinateKeyId,
                                    CylinderSuperordinateKeysForKeyingSystem.Position + 1
                             FROM SuperordinateKeys
                                      INNER JOIN CylinderSuperordinateKeysForKeyingSystem
                                                 ON SuperordinateKeys.ParentSuperordinateKeyId =
                                                    CylinderSuperordinateKeysForKeyingSystem.Id
                             WHERE SuperordinateKeys.ParentSuperordinateKeyId IS NOT NULL
                               AND SuperordinateKeys.KeyingSystemId = @keyingSystemId),
                     CylinderEntriesWithNewId as (select *, NEWID() as NewId
                                                  from CylinderSuperordinateKeysForKeyingSystem)
                insert
                into #TempSuperordinateKeysWithNewIds
                select Id, ParentSuperordinateKeyId, NewId, Lag(NewId) OVER ( Order by Position ) NewParentId, Position
                from CylinderEntriesWithNewId

                -- Migrate SuperordinateKeys
                ;
                With NewSuperordinateKeys as (select sTemp.NewId        Id,
                                                     @newOrderId        OrdrId,
                                                     @newKeyingSystemId NewKeyingSystemId,
                                                     Locking,
                                                     KeysCount,
                                                     PartNumber,
                                                     Description,
                                                     Price,
                                                     @createdBy         CreatedBy,
                                                     GETUTCDATE()       Created,
                                                     null               UpdatedBy,
                                                     null               LastUpdated,
                                                     sTemp.NewParentId  ParentSuperordinateKeyId,
                                                     LockwizId,
                                                     PartVariantNumber,
                                                     KeyLabel,
                                                     Position
                                              from SuperordinateKeys
                                                       inner join #TempSuperordinateKeysWithNewIds sTemp
                                                                  on SuperordinateKeys.Id = sTemp.Id
                                              where KeyingSystemId = @keyingSystemId)
                insert
                into SuperordinateKeys
                select Id,
                       OrdrId,
                       NewKeyingSystemId,
                       Locking,
                       KeysCount,
                       PartNumber,
                       Description,
                       Price,
                       CreatedBy,
                       Created,
                       UpdatedBy,
                       LastUpdated,
                       ParentSuperordinateKeyId,
                       LockwizId,
                       PartVariantNumber,
                       KeyLabel
                From NewSuperordinateKeys
                order by Position

                -- Migrate CylinderEntries to Cylinder Entries
                insert into CylinderEntriesToCylinderEntries
                select NewId(), sTempSourceId.NewId, sTempTargetId.NewId, c.ConnectionType, @createdBy, GETUTCDATE()
                from CylinderEntriesToCylinderEntries c
                         inner join #TempCylinderEntriesWithNewIds sTempSourceId
                                    on c.SourceCylinderEntryId = sTempSourceId.Id
                         inner join #TempCylinderEntriesWithNewIds sTempTargetId
                                    on c.TargetCylinderEntryId = sTempTargetId.Id

                -- Migrate CylinderEntriesToSuperordinateKeys
                insert into CylinderEntriesToSuperordinateKeys
                select NewId(), cylinderEntryIds.NewId, superordinateKeyIds.NewId, @createdBy, GETUTCDATE()
                from CylinderEntriesToSuperordinateKeys s
                         inner join #TempCylinderEntriesWithNewIds cylinderEntryIds
                                    on s.CylinderEntryId = cylinderEntryIds.Id
                         inner join #TempSuperordinateKeysWithNewIds superordinateKeyIds
                                    on s.SuperordinateKeyId = superordinateKeyIds.Id

                -- Clone Security Cards
                insert into SecurityCards
                select NEWID(),
                       @newKeyingSystemId,
                       @newOrderId,
                       GETUTCDATE(),
                       @createdBy,
                       CustomerId,
                       Text1,
                       Text2,
                       Text3,
                       CopyText,
                       LogEmboss,
                       LogProductionDate,
                       LogProductionResult,
                       null,
                       null,
                       0,
                       CopyNumber,
                       Comment,
                       HasCard,
                       CaratCommissionId
                from SecurityCards
                where KeyingSystemId = @keyingSystemId
                  and SequenceNumber = 1

                -- Security Card States
                insert into SecurityCardStateHistories
                select NEWID(), Id, 1, @createdBy, GETUTCDATE()
                from SecurityCards
                where KeyingSystemId = @newKeyingSystemId

                -- Next iteration
                set @counter += 1

                Delete from #TempCylinderEntriesWithNewIds where 1 = 1
                Delete from #TempSuperordinateKeysWithNewIds where 1 = 1
            End

        -- Set default values for keyingSystems created
        Update ks
        set ks.KeyNumberingType = ks.KeyNumberingType
        from KeyingSystems ks
                 inner join #KeyingSystemsCreated ksc
                            on ks.Id = ksc.Id
                 inner join Orders o on o.KeyingSystemId = ks.Id
                 inner join CustomerInformation ci on o.CustomerIdProAlpha = ci.Id
    Commit Transaction

    select ks.*
    from #KeyingSystemsCreated temp
             inner join KeyingSystems ks on temp.Id = ks.Id;
End
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
                                     sc.Text1,
                                     sc.Text2,
                                     sc.Text3,
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
                                       Cross Apply (Select TOP 1 SecurityCardState, Created
                                                    from SecurityCardStateHistories
                                                    where SecurityCardId = sc.Id
                                                    order by Created desc) SecurityHistory
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
         securityCardBatches as (select *
                                 from securityCardsByCreator
                                 union all
                                 select *
                                 from securityCardSeparators
                                 where securityCardSeparators.lastId = securityCardSeparators.Id)

--- Step 3 : Prepare the data so that it is suitable for the Maticard Software
--- Since we have to order the data we need a "Select Top" otherwise SQL Server does not want to create a view since order and stuff are not allowed in a view
    SELECT Top 10000 Id                                                                  ID,
                     IIF(isSeparator = 1, null, KeyingSystemNumber)                      SKANL,
                     IIF(isSeparator = 1, null, Name)                                    SKANA,
                     IIF(isSeparator = 1, CreatedBy, CardCaption)                        SKASY,                -- SKBEA in case of separator
                     IIF(isSeparator = 1, null,
                         RIGHT('000' + CAST(SequenceNumber AS NVARCHAR(3)), 3))          SKNR1,                -- Copy Number
                     IIF(isSeparator = 1, null, '')                                      SKFI1,
                     IIF(isSeparator = 1, null,
                         RIGHT('00' + CAST(CopyNumber AS NVARCHAR(2)), 2))               SKNR2,                -- Copy Counter
                     IIF(isSeparator = 1, null, '')                                      SKFI2,
                     IIF(isSeparator = 1, null, RIGHT(FORMAT(OrderDate, 'ddMMyyyy'), 8)) SKBDT,
                     IIF(isSeparator = 1, null, '')                                      SKFI3,
                     IIF(isSeparator = 1, null, 'WK')                                    SKWIL,                -- WK 
                     IIF(isSeparator = 1, null, CopyText)                                SKCPY,
                     IIF(isSeparator = 1, null, CreatedBy)                               SKBEA,
                     IIF(isSeparator = 1, null, 'Wilka')                                 SKKAR,
                     IIF(isSeparator = 1, null, Text1)                                   SKTX1,
                     IIF(isSeparator = 1, null, Text2)                                   SKTX2,
                     IIF(isSeparator = 1, null, Text3)                                   SKTX3,
                     IIF(isSeparator = 1, 0, LogEmboss)                                  M_Log_Emboss,
                     IIF(isSeparator = 1, null, '')                                      M_Split_Id,
                     IIF(isSeparator = 1, null, CAST(LogProductionDate AS datetime))     M_LogProductionDate,  --Datetime in Maticard sw
                     IIF(isSeparator = 1, null, LogProductionResult)                     M_LogProductionResult,--INT in Maticard sw
                     0                                                                   M_Marked              --INT in Maticard sw
    from securityCardBatches
    order by CreatedBy, isSeparator, sortOrder
Go