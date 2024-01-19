alter table Orders
    add PackagingType int not null default 0
Go

Create table Packagings
(
    Id          uniqueidentifier primary key,
    Name        nvarchar(255)    not null,
    Description nvarchar(max),
    OrderId     uniqueidentifier not null,
    CreatedBy   nvarchar(255)    not null,
    Created     datetime2        not null default GETUTCDATE(),
    UpdatedBy   nvarchar(255),
    LastUpdated datetime2,
    CONSTRAINT FK_Packagings_Orders FOREIGN KEY (OrderId) REFERENCES Orders
)

GO

ALTER TABLE CylinderEntries
    ADD PackagingId UNIQUEIDENTIFIER NULL;

ALTER TABLE CylinderEntries
    ADD CONSTRAINT FK_CylinderEntries_Packagings FOREIGN KEY (PackagingId)
        REFERENCES Packagings (Id)
        ON DELETE SET NULL;
Go

Go
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
    Declare @caratProfileId uniqueidentifier

    select @keyingSystemKindId = KeyingSystemKindId,
           @keyingSystemTypeId = KeyingSystemTypeId,
           @keyNumberingType = KeyNumberingType,
           @caratProfileId = CaratProfileId

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
    With securityCardData as (SELECT sc.Id,
                                     ks.KeyingSystemNumber,
                                     ksk.Name KeyingSystemKind,
                                     msc.CreatedBy,
                                     msc.Created,
                                     sc.CopyText,
                                     sc.Text1,
                                     sc.Text2,
                                     sc.Text3,
                                     msc.LogEmboss,
                                     msc.LogProductionDate,
                                     msc.LogProductionResult,
                                     msc.Marked,
                                     sc.SequenceNumber,
                                     sc.CopyNumber,
                                     kst.CardCaption,
                                     ci.DefaultSecurityCardPrintBlank
                              FROM dbo.SecurityCards sc
                                       Left outer JOIN KeyingSystems ks on sc.KeyingSystemId = ks.Id
                                       Left outer JOIN KeyingSystemKinds ksk
                                                       on ksk.Id = ks.KeyingSystemKindId -- employee records without system kind
                                       Left outer JOIN KeyingSystemTypes kst
                                                       on kst.Id = ks.KeyingSystemTypeId -- employee records without system type
                                       inner join Orders o on sc.OrderId = o.Id
                                       Left outer join CustomerInformation ci on o.CustomerIdProAlpha = ci.Id
                                       inner join [maticard].SecurityCardStates msc on msc.Id = sc.Id)

    SELECT ROW_NUMBER() Over (order by CreatedBy)                 Id,
           CONVERT(nvarchar(36), Id)                              SecurityCardId,
           KeyingSystemNumber                                     SKANL,
           KeyingSystemKind                                       SKANA,
           CardCaption                                            SKASY,                -- SKBEA in case of separator

           RIGHT('000' + CAST(SequenceNumber AS NVARCHAR(3)), 3)  SKNR1,                -- Copy Number
           ''                                                     SKFI1,

           RIGHT('00' + CAST(CopyNumber AS NVARCHAR(2)), 2)       SKNR2,                -- Copy Counter
           ''                                                     SKFI2,
           RIGHT(FORMAT(Created, 'ddMMyyyy'), 8)                  SKBDT,
           ''                                                     SKFI3,
           'WK'                                                   SKWIL,                -- WK 
           RIGHT(REPLICATE('0', 10) + KeyingSystemNumber, 10) + KeyingSystemKind + CardCaption +
           RIGHT(REPLICATE('0', 3) + CAST(SequenceNumber AS NVARCHAR(3)), 3) + ' ' +
           RIGHT(REPLICATE('0', 2) + CAST(CopyNumber AS NVARCHAR(2)), 2) + CHAR(9) +
           RIGHT(FORMAT(Created, 'ddMMyyyy'), 8) + CHAR(9) + 'WK' SKCPY,
           CreatedBy                                              SKBEA,
           isNull(DefaultSecurityCardPrintBlank, 'Wilka')         SKKAR,
           Text1                                                  SKTX1,
           Text2                                                  SKTX2,
           Text3                                                  SKTX3,
           LogEmboss                                              M_Log_Emboss,
           ''                                                     M_Split_Id,
           CAST(LogProductionDate AS datetime)                    M_LogProductionDate,  --Datetime in Maticard sw
           LogProductionResult                                    M_LogProductionResult,--INT in Maticard sw
           Marked                                                 M_Marked              --INT in Maticard sw
    from securityCardData

Go

alter view vwOrderComments as
    (SELECT ks.KeyingSystemNumber,
            o.OrderNumber,
            oc.CommentText,
            PrintType   = Case oc.PrintType
                              When 0 Then 'Never'
                              When 1 Then 'OnlyForCurrentOrder'
                              When 2 Then 'Always' End,
            CommentType = Case oc.CommentType
                              When 0 Then 'Commercial'
                              When 1 Then 'Technical' End
     FROM Orders o
              LEFT JOIN KeyingSystems ks ON o.KeyingSystemId = ks.Id
              LEFT JOIN Orders os ON os.KeyingSystemId = ks.Id
              LEFT JOIN OrderComments oc
                        ON oc.OrderId = o.Id AND (oc.PrintType = 1 AND oc.KeyingSystemId = ks.Id OR oc.PrintType = 2))

Go