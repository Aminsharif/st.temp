ALTER PROCEDURE [dbo].[SetOrderNumberForKeyingSystem](@keyingSystemNumber nvarchar(255),
                                                      @orderNumber int,
                                                      @orderNumberProAlpha nvarchar(255)) as
Begin

    IF @orderNumberProAlpha IS NULL
        BEGIN
            RAISERROR (N'orderNumberProAlpha cannot be null.', -- Message text.
                11, -- Severity.
                1 -- State.
                );
        END

    If not exists(select *
                  from Orders o
                           inner join KeyingSystems k on o.KeyingSystemId = k.Id
                  where k.KeyingSystemNumberId = @keyingSystemNumber
                    and o.OrderNumber = @orderNumber)
        Begin
            RAISERROR (N'Order for KeyingSystem does not exist.', -- Message text.  
                11, -- Severity does not exist,  
                1, -- State,  
                @keyingSystemNumber);
        end

    -- Update Order with pro Alpha Id    
    update o
    set o.OrderNumberProAlpha = @orderNumberProAlpha
    from Orders o
             inner join KeyingSystems k on o.KeyingSystemId = k.Id
    where k.KeyingSystemNumberId = @keyingSystemNumber
      and o.OrderNumber = @orderNumber
      and o.OrderNumberProAlpha is null
End

Go

ALTER view [dbo].[vwOrders] as
    select                      ks.KeyingSystemNumberId                   KeyingSystemNumber,
                                o.Id,
                                KeyingSystemId,
                                kst.ProAlphaReferenceForCylinders         KeyingSystemTypeCaptionForCylinders,
                                kst.ProAlphaReferenceForSuperordinateKeys KeyingSystemTypeCaptionForSuperordinateKeys,
                                OrderNumber,
                                OrderNumberProAlpha,
                                CustomerIdProAlpha,
                                o.Note,
                                ShipmentDate,
                                ot.Name                                   OrderType,
                                kst.IsCarat,
                                o.CreatedBy,
                                o.Created,
                                o.UpdatedBy,
                                o.LastUpdated,
                                o.IsCalculation,
                                o.IsFunctionRequest,
                                o.AdditionalKeyCost,
                                o.CustomerOrderNumber,
                                OrderKind,
                                OrderDate,
                                ShippingAddress_Name1,
                                ShippingAddress_Name2,
                                ShippingAddress_Street,
                                ShippingAddress_HouseNumber,
                                ShippingAddress_Country,
                                ShippingAddress_City,
                                ShippingAddress_PostalCode,
                                ShipmentTermsIdProAlpha,
                                ShippingMethodIdProAlpha,
                                KeyNumberingPrice,
                                ke.Value                                  KeyEmbossing,
        KeyNumberingType      = Case ks.KeyNumberingType
                                    When 0 Then 'None'
                                    When 1 Then 'Sequential'
                                    When 2 Then 'SequentialSuperordinateKey'
                                    When 3 Then 'Manual'
                                    End,
        KeyingSystemShortname = Case kst.Id
                                    When '08E53D25-D843-4F60-BB56-448E0C16D080' Then 'STD'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D081' Then 'WZ'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D082' Then '2VE'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D083' Then 'HSR'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D084' Then '3VE'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D09E' Then '3VE' -- 3VE SKG
                                    When '08E53D25-D843-4F60-BB56-448E0C16D085' Then 'STR' -- STR
                                    When '08E53D25-D843-4F60-BB56-448E0C16D086' Then 'TH6' -- ??
                                    When '08E53D25-D843-4F60-BB56-448E0C16D087' Then 'SI6'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D088' Then '2VS'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D089' Then '3VS'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D08A'
                                        Then 'STR' -- Primus VL                                    
                                    When '08E53D25-D843-4F60-BB56-448E0C16D090' Then 'STR' -- Primus VX
                                    When '08E53D25-D843-4F60-BB56-448E0C16D091' Then '3VE' -- Primus HX
                                    When '08E53D25-D843-4F60-BB56-448E0C16D092' Then 'S1'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D093' Then 'S3'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D094' Then 'S4'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D095' Then 'S5'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D096' Then 'CARAT' -- Carat CSS
                                    When '08E53D25-D843-4F60-BB56-448E0C16D097' Then 'CS1' -- Carat CSS manuell
                                    When '08E53D25-D843-4F60-BB56-448E0C16D098' Then 'TH6' -- Carat P1
                                    When '08E53D25-D843-4F60-BB56-448E0C16D099' Then '2VE' -- Carat P2

                                    End,
                                m.LockwizName                             KeyingSystemLockwizName
    from Orders o
             inner join KeyingSystems ks on o.KeyingSystemId = ks.Id
             inner join KeyingSystemNumbers ksn on ksn.Id = ks.KeyingSystemNumberId
             inner join KeyingSystemTypes kst on ksn.KeyingSystemTypeId = kst.Id
             inner join OrderTypes ot on o.OrderTypeId = ot.Id
             left outer join KeyEmbossings ke on ke.Id = o.KeyEmbossingId
             left outer join Lockwiz.KeyingSystemKindMappings m on ks.KeyingSystemKindId = m.KeyingSystemKindId and
                                                                   ksn.KeyingSystemTypeId = m.KeyingSystemTypeId
GO

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
                     , null
                     , null
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
GO