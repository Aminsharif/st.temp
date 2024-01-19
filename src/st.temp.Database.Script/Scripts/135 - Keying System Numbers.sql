create table KeyingSystemNumbers
(
    Id                 nvarchar(255) primary key not null,
    KeyingSystemTypeId uniqueidentifier          not null
        constraint FK_KeyingSystemNumbers_KeyingSystemTypeId references KeyingSystemTypes,
)

-- Migrate Keying System Numbers

Go

UPDATE KeyingSystems
SET KeyingSystemNumber = (
    CASE
        WHEN KeyingSystemNumber IS NULL THEN CAST(Id AS NVARCHAR(255)) + '_Test'
        ELSE KeyingSystemNumber
        END
    )
WHERE KeyingSystemNumber IS NULL;

Go

INSERT INTO KeyingSystemNumbers (Id, KeyingSystemTypeId)
SELECT KeyingSystemNumber, KeyingSystemTypeId
FROM KeyingSystems;

Go

-- Deletes Foreign key constraints on KeyingSystems
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql +=
       'ALTER TABLE ' + QUOTENAME(cs.name) + '.' + QUOTENAME(t.name) + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys AS fk
         INNER JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
         INNER JOIN sys.schemas AS cs ON t.schema_id = cs.schema_id
WHERE fk.name LIKE 'FK__KeyingSys__Keyin%'
  and t.name = 'KeyingSystems';

EXEC sp_executesql @sql;

Go

-- Deletes default value constraint for KeyingSytemTypeIds column
DECLARE @sql2 NVARCHAR(MAX) = N'';

SELECT @sql2 +=
       'ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ' DROP CONSTRAINT ' + QUOTENAME(dc.name) + ';
'
FROM sys.tables AS t
         INNER JOIN sys.default_constraints dc ON t.object_id = dc.parent_object_id
         INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
WHERE dc.name LIKE 'DF__KeyingSys__Keyin%'
  and dc.definition like '%08E53D25-D843-4F60-BB56-448E0C16D080%';

EXEC sp_executesql @sql2;

Go

alter table KeyingSystems
    add constraint FK_KeyingSystems_KeyingSystemKindId FOREIGN KEY (KeyingSystemKindId)
        REFERENCES KeyingSystemKinds

Go

DROP INDEX idx_UQ_KeyingSystemNumber_NotNull ON KeyingSystems;

Go

EXEC sp_rename 'KeyingSystems.KeyingSystemNumber', 'KeyingSystemNumberId', 'COLUMN';

Go

ALTER TABLE KeyingSystems
    ALTER COLUMN KeyingSystemNumberId nvarchar(255) NOT NULL;
Go

CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_KeyingSystemNumberId
    ON KeyingSystems (KeyingSystemNumberId);
GO

alter Table KeyingSystems
    drop column KeyingSystemTypeId

Go

ALTER PROCEDURE CreateKeyingSystem(
    @keyingSystemTypeId uniqueidentifier,
    @keyingSystemKindId uniqueidentifier,
    @caratProfileId uniqueidentifier = Null,
    @createdBy nvarchar(255),
    @keyNumberingType int,
    @keyingSystemId uniqueidentifier OUTPUT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @keyingSystemNumber nvarchar(255) = null

            SELECT TOP 1 @keyingSystemNumber = n.Id
            FROM KeyingSystemNumbers n
                     LEFT OUTER JOIN KeyingSystems k ON n.Id = k.KeyingSystemNumberId
            WHERE n.KeyingSystemTypeId = @keyingSystemTypeId
              AND k.Id IS NULL
            ORDER BY n.Id

            -- If @keyingSystemNumber is NULL, raise an error
            IF @keyingSystemNumber IS NULL
                RAISERROR ('keyingSystemNumber cannot be NULL. Please check if there is a keying system number for that keying system type which is not in use', 16, 1)

            SELECT @keyingSystemId = NEWID();

            INSERT INTO KeyingSystems
            (Id,
             KeyingSystemKindId,
             CaratProfileId,
             KeyingSystemNumberId,
             CreatedBy,
             KeyNumberingType,
             Created)
            VALUES (@keyingSystemId,
                    @keyingSystemKindId,
                    @caratProfileId,
                    @keyingSystemNumber,
                    @createdBy,
                    @keyNumberingType,
                    GETUTCDATE())
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END

GO

ALTER Procedure [dbo].[spReplicateKeyingSystem](
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

                -- Next iteration
                set @counter += 1

                Delete from #TempCylinderEntriesWithNewIds where 1 = 1
                Delete from #TempSuperordinateKeysWithNewIds where 1 = 1
            End

        -- Set default values for keyingSystems created
        --Update ks
        --set ks.KeyNumberingType = ks.KeyNumberingType
        --from KeyingSystems ks
        --         inner join #KeyingSystemsCreated ksc
        --                    on ks.Id = ksc.Id
        --         inner join Orders o on o.KeyingSystemId = ks.Id
        --         inner join CustomerInformation ci on o.CustomerIdProAlpha = ci.Id
    Commit Transaction

    select ks.*
    from #KeyingSystemsCreated temp
             inner join KeyingSystems ks on temp.Id = ks.Id;
End
GO

alter view vwLoggedEvents as
    With LoggedEvents as (SELECT pe.Id          ProcessedEventId,
                                 pe.HandlerName,
                                 pe.EventName,
                                 pe.ReferenceId OrderId,
                                 pe.ProcessingAt,
                                 pe.ProcessedAt,
                                 pe.OperationResult,
                                 le.Id          LogEntryId,
                                 le.Created     LogEntryCreated,
                                 le.Message     LogEntryMessage
                          From DomainEvents.ProcessedEvents pe
                                   left outer join [ProductConfigurator].[Logs] le on pe.Id = le.ProcessedEventId
                          where pe.Domain = 'Order')
    select LoggedEvents.*, o.OrderNumber, ks.Id KeyingSystemId, ks.KeyingSystemNumberId KeyingSystemNumber
    from LoggedEvents
             left outer join Orders o on LoggedEvents.OrderId = o.Id
             left outer join KeyingSystems ks on o.KeyingSystemId = ks.Id

Go

Alter view vwCylinderEntries as
    select ks.KeyingSystemNumberId                                              KeyingSystemNumber,
           Locking,
           LengthA,
           LengthB,
           BackSet,
           Color,
           DoorNumber,
           OrderNumber,
           LockwizId,
           KeysCount,
           CylindersCount,
           Price,
           Description,
           CASE
               WHEN NumberOfCylindersThatUseThisCylinderAsCentral > 0 THEN 'Z'
               WHEN NumberOfCylindersThatUseThisCylinderAsSynchronized > 0 THEN 'G'
               WHEN NumberOfCylindersThatUseThisCylinderAsIncluding > 0 THEN 'M'
               ELSE null
               END as                                                           ConnectionType,
           IIF(AB.NumberOfCylindersThatUseThisCylinderAsCentral > 0, 1, 0)      IsCentral,
           IIF(AC.NumberOfCylindersThatUseThisCylinderAsSynchronized > 0, 1, 0) IsSynchronized,
           IIF(AD.NumberOfCylindersThatUseThisCylinderAsIncluding > 0, 1, 0)    IsIncluding,
        PartVariantNumber =
           case ce.PartVariantNumber
               When 'None' then ce.PartNumber
               else
                   ce.PartVariantNumber
               end,
           ae.AdditionalEquipments
    from CylinderEntries ce
             inner join Orders o on ce.OrderId = o.Id
             inner join KeyingSystems ks on ce.KeyingSystemId = ks.Id
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsCentral
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 1) AB
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsSynchronized
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 2) AC
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsIncluding
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 3) AD
             Outer Apply (select String_Agg(ae.Caption, N',') AdditionalEquipments
                          from AdditionalEquipmentCylinderEntry aec
                                   inner join AdditionalEquipments ae on aec.AdditionalEquipmentsId = ae.Id
                          where aec.CylinderEntriesId = ce.Id) AE
    where LockwizId is not null

Go

ALTER view [dbo].[vwOrders] as
    select                      ks.KeyingSystemNumberId KeyingSystemNumber,
                                o.Id,
                                KeyingSystemId,
                                OrderNumber,
                                OrderNumberProAlpha,
                                CustomerIdProAlpha,
                                o.Note,
                                ShipmentDate,
                                ot.Name                 OrderType,
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
                                ke.Value                KeyEmbossing,
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
                                m.LockwizName           KeyingSystemLockwizName
    from Orders o
             inner join KeyingSystems ks on o.KeyingSystemId = ks.Id
             inner join KeyingSystemNumbers ksn on ksn.Id = ks.KeyingSystemNumberId
             inner join KeyingSystemTypes kst on ksn.KeyingSystemTypeId = kst.Id
             inner join OrderTypes ot on o.OrderTypeId = ot.Id
             left outer join KeyEmbossings ke on ke.Id = o.KeyEmbossingId
             left outer join Lockwiz.KeyingSystemKindMappings m on ks.KeyingSystemKindId = m.KeyingSystemKindId and
                                                                   ksn.KeyingSystemTypeId = m.KeyingSystemTypeId

Go

Alter View vwKeyLabels as
    select ks.KeyingSystemNumberId KeyingSystemNumber,
           OrderNumber,
           ces.LockwizId,
           ces.Locking,
           ckl.Label,
           'Cylinder'              Type
    from KeyingSystems ks
             inner join Orders o on ks.Id = o.KeyingSystemId
             inner join CylinderEntries ces on o.Id = ces.OrderId
             inner join CylinderEntryKeyLabels ckl on ces.Id = ckl.CylinderEntryId
    union
    select ks.KeyingSystemNumberId KeyingSystemNumber,
           OrderNumber,
           sks.LockwizId,
           sks.Locking,
           skl.Label,
           'SuperordinateKey'      Type
    from KeyingSystems ks
             inner join Orders o on ks.Id = o.KeyingSystemId
             inner join SuperordinateKeys sks on o.Id = sks.OrderId
             inner join SuperordinateKeyLabels skl on sks.Id = skl.SuperordinateKeyId
Go

Alter Procedure spGetOrderComments(
    @keyingSystemNumber nvarchar(255),
    @orderNumber int = null)
as
Begin
    -- check keying system
    If not exists(select *
                  from KeyingSystems
                  where KeyingSystemNumberId = @keyingSystemNumber)
        Begin
            RAISERROR (N'KeyingSystem does not exist.', -- Message text.  
                11, -- Severity does not exist,  
                1, -- State,  
                '');
        end

    -- Case 1: KeyingSystemNumber and Order Number passed => Comments For this keying System which are passed always and those only for this order without never
    if (@orderNumber is not null)
        Begin
            select            ks.KeyingSystemNumberId KeyingSystemNumber,
                              o.OrderNumber,
                              oc.CommentType,
                              oc.PrintType,
                              oc.CommentText,
                PrintType   = Case oc.PrintType
                                  When 0 Then 'Never'
                                  When 1 Then 'OnlyForCurrentOrder'
                                  When 2 Then 'Always' End,
                CommentType = Case oc.CommentType
                                  When 0 Then 'Commercial'
                                  When 1 Then 'Technical' End

            from OrderComments oc
                     inner join KeyingSystems ks
                                on oc.KeyingSystemId = ks.Id
                     inner join Orders o on oc.OrderId = o.Id
            where oc.PrintType = 2
               or (ks.KeyingSystemNumberId = @keyingSystemNumber
                and o.OrderNumber = @orderNumber and oc.PrintType <> 0)
        End

-- Case 2: KeyingSystemNumber passed => Comments for this keying System which are passed always
    ELSE
        Begin
            select            ks.KeyingSystemNumberId KeyingSystemNumber,
                              null                    OrderNumber,
                              oc.CommentType,
                              oc.PrintType,
                              oc.CommentText,
                PrintType   = Case oc.PrintType
                                  When 0 Then 'Never'
                                  When 1 Then 'OnlyForCurrentOrder'
                                  When 2 Then 'Always' End,
                CommentType = Case oc.CommentType
                                  When 0 Then 'Commercial'
                                  When 1 Then 'Technical' End
            from OrderComments oc
                     inner join KeyingSystems ks on oc.KeyingSystemId = ks.Id
            where oc.PrintType = 2
        end
End
Go

alter view vwOrderComments as
    (SELECT            ks.KeyingSystemNumberId KeyingSystemNumber,
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

Alter PROCEDURE SetProductConfiguratorFinalizationComplete(@keyingSystemNumber nvarchar(255), @orderNumber int) as
Begin
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

    -- insert updated State
    insert into OrderStates (Id, OrderId, Value, CreatedBy)
    select newid(), o.Id, 4, 'Produktkonfigurator'
    from Orders o
             inner join KeyingSystems k on o.KeyingSystemId = k.Id
    where k.KeyingSystemNumberId = @keyingSystemNumber
      and o.OrderNumber = @orderNumber
end
Go

Alter PROCEDURE SetOrderNumberForKeyingSystem(@keyingSystemNumber nvarchar(255),
                                              @orderNumber int,
                                              @orderNumberProAlpha nvarchar(255)) as
Begin

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

ALTER view [dbo].[vwCylinderEntries] as
    select ks.KeyingSystemNumberId                                              KeyingSystemNumber,
           Locking,
           LengthA,
           LengthB,
           BackSet,
           Color,
           DoorNumber,
           OrderNumber,
           LockwizId,
           KeysCount,
           CylindersCount,
           Price,
           Description,
           CASE
               WHEN NumberOfCylindersThatUseThisCylinderAsCentral > 0 THEN 'Z'
               WHEN NumberOfCylindersThatUseThisCylinderAsSynchronized > 0 THEN 'G'
               WHEN NumberOfCylindersThatUseThisCylinderAsIncluding > 0 THEN 'M'
               ELSE null
               END as                                                           ConnectionType,
           IIF(AB.NumberOfCylindersThatUseThisCylinderAsCentral > 0, 1, 0)      IsCentral,
           IIF(AC.NumberOfCylindersThatUseThisCylinderAsSynchronized > 0, 1, 0) IsSynchronized,
           IIF(AD.NumberOfCylindersThatUseThisCylinderAsIncluding > 0, 1, 0)    IsIncluding,
        PartVariantNumber =
           case ce.PartVariantNumber
               When 'None' then ce.PartNumber
               else
                   ce.PartVariantNumber
               end,
           ae.AdditionalEquipments
    from CylinderEntries ce
             inner join Orders o on ce.OrderId = o.Id
             inner join KeyingSystems ks on ce.KeyingSystemId = ks.Id
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsCentral
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 1) AB
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsSynchronized
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 2) AC
             Outer Apply(select count(*) NumberOfCylindersThatUseThisCylinderAsIncluding
                         from CylinderEntriesToCylinderEntries cet
                         where cet.TargetCylinderEntryId = ce.Id
                           and ConnectionType = 3) AD
             Outer Apply (select String_Agg(ae.Caption, N',') AdditionalEquipments
                          from AdditionalEquipmentCylinderEntry aec
                                   inner join AdditionalEquipments ae on aec.AdditionalEquipmentsId = ae.Id
                          where aec.CylinderEntriesId = ce.Id) AE
    where LockwizId is not null
GO

Alter view vwSuperordinateKeys as
    select ks.KeyingSystemNumberId KeyingSystemNumber,
           OrderNumber,
           LockwizId,
           PartVariantNumber,
           Locking,
           KeysCount,
           Price,
           Description
    from SuperordinateKeys sks
             inner join Orders o on sks.OrderId = o.Id
             inner join KeyingSystems ks on sks.KeyingSystemId = ks.Id
    where LockwizId is not null
Go

ALTER View vwAusrechnung as
    select l.LockwizName                             KeyingSystemName,
           ks.KeyingSystemNumberId                   Anlagennummer,
           [Schliessungsnummer],
           isNull([IdNrdAusrechnung], 0)             IdNrdAusrechnung,
           SchliessungSchluessel,
           ProfilgruppeSchluessel,
           ErganzungSchluessel,
           Serie1bzwASchluessel,
           Serie2bzwBSchluessel,
           isNull(Serie3bzwCSchluessel, Space(5))    Serie3bzwCSchluessel,
           BohrungenFTaststSchluessel,
           isNull(SchliessungKern, Space(7))         SchliessungKern,
           isNull(Aufbau1Kern, Space(7))             Aufbau1Kern,
           isNull(Aufbau2Kern, Space(7))             Aufbau2Kern,
           isNull(Aufbau3Kern, Space(7))             Aufbau3Kern,
           isNull(Aufbau4Kern, Space(7))             Aufbau4Kern,
           isNull(ProfilgruppeKern, Space(6))        ProfilgruppeKern,
           isNull(ErgaenzungKern, Space(5))          ErgaenzungKern,
           isNull(Serie1bzwAKern, Space(5))          Serie1bzwAKern,
           isNull(Serie2bzwBKern, Space(5))          Serie2bzwBKern,
           isNull(Serie3bzwCKern, Space(5))          Serie3bzwCKern,
           isNull(TaststifteKern, Space(12))         TaststifteKern,
           kst.ProAlphaReferenceForCylinders         AnlagensystemZylinder,
           kst.ProAlphaReferenceForSuperordinateKeys AnlagensystemUebergeordneterSchluessel,
           ksk.ProAlphaReference                     Anlagenart,
           kskm.LockwizName                          AnlagenartLockwiz,
           kst.IsCarat                               IstCarat,
           o.CustomerIdProAlpha                      Kundennummer,
           calc.UpdatedAt
    from LockwizProductionCalculations calc
             inner join Orders o on calc.OrderId = o.Id
             inner join KeyingSystems ks on ks.Id = o.KeyingSystemId
             inner join KeyingSystemNumbers ksn on ksn.Id = ks.KeyingSystemNumberId
             inner join KeyingSystemTypes kst on kst.Id = ksn.KeyingSystemTypeId
             left outer join KeyingSystemKinds ksk on ksk.Id = ks.KeyingSystemKindId
             left outer join Lockwiz.KeyingSystemKindMappings l
                             on ks.KeyingSystemKindId = l.KeyingSystemKindId and
                                ksn.KeyingSystemTypeId = l.KeyingSystemTypeId
             left outer join Lockwiz.KeyingSystemKindMappings kskm
                             on ksn.KeyingSystemTypeId = kskm.KeyingSystemTypeId and
                                ksn.KeyingSystemTypeId = kskm.KeyingSystemTypeId
Go

ALTER VIEW [dbo].[vwSecurityCardPrintQueue] AS
    With securityCardData as (SELECT sc.Id,
                                     ks.KeyingSystemNumberId,
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
                                       Left outer Join KeyingSystemNumbers ksn on ksn.Id = ks.KeyingSystemNumberId
                                       Left outer JOIN KeyingSystemTypes kst
                                                       on kst.Id = ksn.KeyingSystemTypeId -- employee records without system type
                                       inner join Orders o on sc.OrderId = o.Id
                                       Left outer join CustomerInformation ci on o.CustomerIdProAlpha = ci.Id
                                       inner join [maticard].SecurityCardStates msc on msc.Id = sc.Id)

    SELECT ROW_NUMBER() Over (order by CreatedBy)                Id,
           CONVERT(nvarchar(36), Id)                             SecurityCardId,
           KeyingSystemNumberId                                  SKANL,
           KeyingSystemKind                                      SKANA,
           CardCaption                                           SKASY,                -- SKBEA in case of separator

           RIGHT('000' + CAST(SequenceNumber AS NVARCHAR(3)), 3) SKNR1,                -- Copy Number
           ''                                                    SKFI1,

           RIGHT('00' + CAST(CopyNumber AS NVARCHAR(2)), 2)      SKNR2,                -- Copy Counter
           ''                                                    SKFI2,
           RIGHT(FORMAT(Created, 'ddMMyyyy'), 8)                 SKBDT,
           ''                                                    SKFI3,
           'WK'                                                  SKWIL,                -- WK 
           RIGHT(REPLICATE('0', 10) + KeyingSystemNumberId, 10)
               + LEFT(KeyingSystemKind + REPLICATE(' ', 3), 3)
               + LEFT(CardCaption + REPLICATE(' ', 10), 10)
               + RIGHT(REPLICATE('0', 3) + CAST(SequenceNumber AS NVARCHAR(3)), 3)
               + Space(1)
               + RIGHT(REPLICATE('0', 2) + CAST(CopyNumber AS NVARCHAR(2)), 2)
               + SPACE(7)
               + RIGHT(FORMAT(Created, 'ddMMyyyy'), 8)
               + RIGHT(REPLICATE(' ', 12) + 'WK', 12)
               + Space(5)                                        SKCPY,
           CreatedBy                                             SKBEA,
           isNull(DefaultSecurityCardPrintBlank, 'Wilka')        SKKAR,
           Text1                                                 SKTX1,
           Text2                                                 SKTX2,
           Text3                                                 SKTX3,
           LogEmboss                                             M_Log_Emboss,
           ''                                                    M_Split_Id,
           CAST(LogProductionDate AS datetime)                   M_LogProductionDate,  --Datetime in Maticard sw
           LogProductionResult                                   M_LogProductionResult,--INT in Maticard sw
           Marked                                                M_Marked              --INT in Maticard sw
    from securityCardData
Go

Create PROCEDURE spUpdateKeyingSystem(
    @keyingSystemId uniqueidentifier,
    @keyingSystemTypeId uniqueidentifier,
    @updatedBy nvarchar(255))
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            IF NOT EXISTS (SELECT 1 FROM KeyingSystems WHERE Id = @keyingSystemId)
                BEGIN
                    RAISERROR ('KeyingSystem with the provided Id does not exist', 16, 1);
                END

            DECLARE @keyingSystemNumber nvarchar(255) = null

            SELECT TOP 1 @keyingSystemNumber = n.Id
            FROM KeyingSystemNumbers n
                     LEFT OUTER JOIN KeyingSystems k ON n.Id = k.KeyingSystemNumberId
            WHERE n.KeyingSystemTypeId = @keyingSystemTypeId
              AND k.Id IS NULL
            ORDER BY n.Id

            -- If @keyingSystemNumber is NULL, raise an error
            IF @keyingSystemNumber IS NULL
                RAISERROR ('keyingSystemNumber cannot be NULL. Please check if there is a keying system number for that keying system type which is not in use', 16, 1)

            Update KeyingSystems set KeyingSystemNumberId = @keyingSystemNumber where Id = @keyingSystemId
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END