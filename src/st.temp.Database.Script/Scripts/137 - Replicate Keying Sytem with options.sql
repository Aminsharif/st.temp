ALTER Procedure [dbo].[spReplicateKeyingSystem](
    @keyingSystemId uniqueidentifier,
    @replicationCounter int,
    @createdBy nvarchar(256),
    @includeOrderComments bit = 0)
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
    Declare @caratProfileId uniqueidentifier

    select @keyingSystemKindId = KeyingSystemKindId,
           @keyingSystemTypeId = n.KeyingSystemTypeId,
           @keyNumberingType = KeyNumberingType,
           @caratProfileId = CaratProfileId

    from KeyingSystems k
             inner join KeyingSystemNumbers n on k.KeyingSystemNumberId = n.Id
    where k.Id = @keyingSystemId

    create table #KeyingSystemsCreated
    (
        Id uniqueidentifier
    )

    Declare @counter int = 0
    Begin Transaction
        while(@counter < @replicationCounter)
            Begin

                -- Create Keying System
                exec CreateKeyingSystem @keyingSystemTypeId, @keyingSystemKindId, @caratProfileId, @createdBy,
                     @keyNumberingType,
                     @newKeyingSystemId out

                insert into #KeyingSystemsCreated (Id) Values (@newKeyingSystemId)

                -- Create Order for that keying System
                Declare @newOrderId uniqueidentifier = NEWID()

                insert into Orders (Id, KeyingSystemId, OrderNumber, OrderNumberProAlpha, CustomerIdProAlpha, Note,
                                    ShipmentDate, DesiredShipmentDate, OrderTypeId, CreatedBy, Created, UpdatedBy,
                                    LastUpdated, OrderKind, OrderDate, ShippingAddress_Name1, ShippingAddress_Name2,
                                    ShippingAddress_Street, ShippingAddress_HouseNumber, ShippingAddress_Country,
                                    ShippingAddress_City,
                                    ShippingAddress_PostalCode, ShipmentTermsIdProAlpha, ShippingMethodIdProAlpha,
                                    KeyNumberingPrice,
                                    CustomerOrderNumber, AdditionalKeyCost, CaratCommissionId, KeyEmbossingId,
                                    PackagingType)
                select @newOrderId
                     , @newKeyingSystemId
                     , 0
                     , null
                     , CustomerIdProAlpha
                     , Note
                     , ShipmentDate
                     , DesiredShipmentDate
                     , 'C4BBFAFE-D2D6-43CE-A36B-B4E0858D5F3F' -- AA
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
                     , CaratCommissionId
                     , KeyEmbossingId
                     , 0
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
                option (maxrecursion 0)

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
                                                   t.Position,
                                                   IsCalculationRelevant
                                            from CylinderEntries
                                                     inner join #TempCylinderEntriesWithNewIds t on CylinderEntries.Id = t.Id
                                            where KeyingSystemId = @keyingSystemId)
                insert
                into CylinderEntries (Id, OrderId, KeyingSystemId, Locking, DoorNumber, Description, CylindersCount,
                                      KeysCount, BackSet, PartNumber, LengthA, LengthB, Color, CreatedBy, Created,
                                      UpdatedBy, LastUpdated, Price, ParentCylinderEntryId, LockwizId,
                                      PartVariantNumber, KeyLabel, IsCalculationRelevant)
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
                       KeyLabel,
                       IsCalculationRelevant
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
                option (maxrecursion 0)

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
                                                     IsCalculationRelevant,
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
                       KeyLabel,
                       IsCalculationRelevant
                From NewSuperordinateKeys
                order by Position

                -- Migrate CylinderEntries to Cylinder Entries
                insert into CylinderEntriesToCylinderEntries
                select NewId(),
                       sTempSourceId.NewId,
                       sTempTargetId.NewId,
                       c.ConnectionType,
                       @createdBy,
                       GETUTCDATE(),
                       c.ConnectionGroup
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
                IF EXISTS(SELECT 1 FROM SecurityCards WHERE KeyingSystemId = @keyingSystemId AND SequenceNumber = 1)
                    BEGIN
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
                               null,
                               null,
                               1,
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
                    END

                -- Migrate Order Comments
                If (@includeOrderComments > 0)
                    Begin

                        Insert into OrderComments (Id, KeyingSystemId, OrderId, CommentText, CommentType, PrintType,
                                                   CreatedBy)
                        select NewId(), @newKeyingSystemId, null, CommentText, CommentType, PrintType, @createdBy
                        from OrderComments
                        where KeyingSystemId = @keyingSystemId
                          and PrintType = 2
                    end

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

Alter Procedure spCopyOrder(
    @sourceOrderId uniqueidentifier,
    @targetOrderId uniqueidentifier,
    @createdBy nvarchar(256),
    @includeOrderComments bit = 0)
As
Begin

    -- Check source and target order
    If not exists(select *
                  from Orders
                  where Id = @sourceOrderId)
        Begin
            RAISERROR (N'Source Order does not exist.', -- Message text.  
                11, -- Severity does not exist,  
                1, -- State,  
                '');
        end

    If not exists(select *
                  from Orders
                  where Id = @targetOrderId)
        Begin
            RAISERROR (N'Target Order does not exist.', -- Message text.  
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

    DECLARE @targetKeyingSystemId uniqueidentifier

    select @targetKeyingSystemId = KeyingSystemId from Orders where Id = @targetOrderId

    DECLARE @sourceKeyingSystemId uniqueidentifier
    select @sourceKeyingSystemId = KeyingSystemId from Orders where Id = @sourceOrderId

    Begin Transaction
        ;
        WITH CylinderEntriesForSourceOrder
                 AS (SELECT Id, ParentCylinderEntryId, 0 as Position
                     FROM CylinderEntries
                     WHERE ParentCylinderEntryId IS NULL
                       AND OrderId = @sourceOrderId
                     UNION ALL
                     SELECT CylinderEntries.Id,
                            CylinderEntries.ParentCylinderEntryId,
                            CylinderEntriesForSourceOrder.Position + 1
                     FROM CylinderEntries
                              INNER JOIN CylinderEntriesForSourceOrder
                                         ON CylinderEntries.ParentCylinderEntryId =
                                            CylinderEntriesForSourceOrder.Id
                     WHERE CylinderEntries.ParentCylinderEntryId IS NOT NULL
                       AND CylinderEntries.OrderId = @sourceOrderId),
             CylinderEntriesWithNewId as (select *, NEWID() as NewId
                                          from CylinderEntriesForSourceOrder)
        insert
        into #TempCylinderEntriesWithNewIds
        select Id, ParentCylinderEntryId, NewId, Lag(NewId) OVER ( Order by Position ) NewParentId, Position
        from CylinderEntriesWithNewId
        option (maxrecursion 0)

        ---- Migrate CylinderEntries
        Declare @lastParentCylinderEntryId uniqueidentifier;
        WITH CylinderEntriesForOrder
                 AS (SELECT Id, ParentCylinderEntryId, 0 as Position
                     FROM CylinderEntries
                     WHERE ParentCylinderEntryId IS NULL
                       AND KeyingSystemId = @targetKeyingSystemId
                     UNION ALL
                     SELECT CylinderEntries.Id,
                            CylinderEntries.ParentCylinderEntryId,
                            CylinderEntriesForOrder.Position + 1
                     FROM CylinderEntries
                              INNER JOIN CylinderEntriesForOrder
                                         ON CylinderEntries.ParentCylinderEntryId = CylinderEntriesForOrder.Id
                     WHERE CylinderEntries.ParentCylinderEntryId IS NOT NULL
                       AND CylinderEntries.KeyingSystemId = @targetKeyingSystemId)
        SELECT Top 1 @lastParentCylinderEntryId = s.Id
        FROM CylinderEntriesForOrder s
                 inner join CylinderEntries c on s.Id = c.Id
        order by Position desc
        option (maxrecursion 0);
        With NewCylinderEntries as (select t.NewId               Id,
                                           @targetOrderId        OrderId,
                                           @targetKeyingSystemId KeyingSystemId,
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
                                           @createdBy            CreatedBy,
                                           GETUTCDATE()          Created,
                                           null                  UpdatedBy,
                                           null                  LastUpdated,
                                           Price,
                                           t.NewParentId         ParentCylinderEntryId,
                                           null                  LockwizId,
                                           PartVariantNumber,
                                           KeyLabel,
                                           t.Position,
                                           IsCalculationRelevant
                                    from CylinderEntries
                                             inner join #TempCylinderEntriesWithNewIds t on CylinderEntries.Id = t.Id
                                    where OrderId = @sourceOrderId)
        insert
        into CylinderEntries (Id, OrderId, KeyingSystemId, Locking, DoorNumber, Description, CylindersCount,
                              KeysCount, BackSet, PartNumber, LengthA, LengthB, Color, CreatedBy, Created,
                              UpdatedBy, LastUpdated, Price, ParentCylinderEntryId, LockwizId,
                              PartVariantNumber, KeyLabel, IsCalculationRelevant)
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
               IsNull(ParentCylinderEntryId, @lastParentCylinderEntryId),
               LockwizId,
               PartVariantNumber,
               KeyLabel,
               IsCalculationRelevant
        From NewCylinderEntries
        order by Position

        -- Migrate AdditionalEquipmentCylinderEntry
        insert into AdditionalEquipmentCylinderEntry (Id, AdditionalEquipmentsId, CylinderEntriesId)
        select NewId(), a.AdditionalEquipmentsId, temp.NewId
        from #TempCylinderEntriesWithNewIds temp
                 inner join AdditionalEquipmentCylinderEntry a on temp.Id = a.CylinderEntriesId

        -- SuperordinateKeys   

        Declare @lastSuperordinateKeyId uniqueidentifier;
        WITH SuperordinateKeysForOrder
                 AS (SELECT Id, ParentSuperordinateKeyId, 0 as Position
                     FROM SuperordinateKeys
                     WHERE ParentSuperordinateKeyId IS NULL
                       AND KeyingSystemId = @targetKeyingSystemId
                     UNION ALL
                     SELECT SuperordinateKeys.Id,
                            SuperordinateKeys.ParentSuperordinateKeyId,
                            SuperordinateKeysForOrder.Position + 1
                     FROM SuperordinateKeys
                              INNER JOIN SuperordinateKeysForOrder
                                         ON SuperordinateKeys.ParentSuperordinateKeyId = SuperordinateKeysForOrder.Id
                     WHERE SuperordinateKeys.ParentSuperordinateKeyId IS NOT NULL
                       AND SuperordinateKeys.KeyingSystemId = @targetKeyingSystemId)
        SELECT Top 1 @lastSuperordinateKeyId = c.Id
        FROM SuperordinateKeysForOrder s
                 inner join SuperordinateKeys c on s.Id = c.Id
        order by Position desc
        option (maxrecursion 0);
        WITH CylinderSuperordinateKeysForSourceOrder
                 AS (SELECT Id, ParentSuperordinateKeyId, 0 as Position
                     FROM SuperordinateKeys
                     WHERE ParentSuperordinateKeyId IS NULL
                       AND OrderId = @sourceOrderId
                     UNION ALL
                     SELECT SuperordinateKeys.Id,
                            SuperordinateKeys.ParentSuperordinateKeyId,
                            CylinderSuperordinateKeysForSourceOrder.Position + 1
                     FROM SuperordinateKeys
                              INNER JOIN CylinderSuperordinateKeysForSourceOrder
                                         ON SuperordinateKeys.ParentSuperordinateKeyId =
                                            CylinderSuperordinateKeysForSourceOrder.Id
                     WHERE SuperordinateKeys.ParentSuperordinateKeyId IS NOT NULL
                       AND SuperordinateKeys.OrderId = @sourceOrderId),
             CylinderEntriesWithNewId as (select *, NEWID() as NewId
                                          from CylinderSuperordinateKeysForSourceOrder)
        insert
        into #TempSuperordinateKeysWithNewIds
        select Id, ParentSuperordinateKeyId, NewId, Lag(NewId) OVER ( Order by Position ) NewParentId, Position
        from CylinderEntriesWithNewId

        -- Migrate SuperordinateKeys
        ;
        With NewSuperordinateKeys as (select sTemp.NewId           Id,
                                             @targetOrderId        OrderId,
                                             @targetKeyingSystemId NewKeyingSystemId,
                                             Locking,
                                             KeysCount,
                                             PartNumber,
                                             Description,
                                             Price,
                                             @createdBy            CreatedBy,
                                             GETUTCDATE()          Created,
                                             null                  UpdatedBy,
                                             null                  LastUpdated,
                                             sTemp.NewParentId     ParentSuperordinateKeyId,
                                             LockwizId,
                                             PartVariantNumber,
                                             KeyLabel,
                                             Position,
                                             IsCalculationRelevant
                                      from SuperordinateKeys
                                               inner join #TempSuperordinateKeysWithNewIds sTemp
                                                          on SuperordinateKeys.Id = sTemp.Id
                                      where OrderId = @sourceOrderId)
        insert
        into SuperordinateKeys
        select Id,
               OrderId,
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
               isNull(ParentSuperordinateKeyId, @lastSuperordinateKeyId),
               LockwizId,
               PartVariantNumber,
               KeyLabel,
               IsCalculationRelevant
        From NewSuperordinateKeys
        order by Position

        -- Migrate CylinderEntries to Cylinder Entries
        insert into CylinderEntriesToCylinderEntries
        select NewId(),
               sTempSourceId.NewId,
               sTempTargetId.NewId,
               c.ConnectionType,
               @createdBy,
               GETUTCDATE(),
               c.ConnectionGroup
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

        -- Migrate Order Comments
        If (@includeOrderComments > 0)
            Begin

                Insert into OrderComments (Id, KeyingSystemId, OrderId, CommentText, CommentType, PrintType,
                                           CreatedBy)
                select NewId(), @targetKeyingSystemId, @targetOrderId, CommentText, CommentType, PrintType, @createdBy
                from OrderComments
                where (KeyingSystemId = @sourceKeyingSystemId and OrderId = @sourceKeyingSystemId and PrintType = 1)
                   or (KeyingSystemId = @sourceKeyingSystemId and PrintType = 2)
            end

        Delete from #TempCylinderEntriesWithNewIds where 1 = 1
        Delete from #TempSuperordinateKeysWithNewIds where 1 = 1
    Commit Transaction
End