Create Procedure spCopyOrder(
    @sourceOrderId uniqueidentifier,
    @targetOrderId uniqueidentifier,
    @createdBy nvarchar(256))
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
                                           t.Position
                                    from CylinderEntries
                                             inner join #TempCylinderEntriesWithNewIds t on CylinderEntries.Id = t.Id
                                    where OrderId = @sourceOrderId)
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
               IsNull(ParentCylinderEntryId, @lastParentCylinderEntryId),
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
                                             Position
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
               KeyLabel
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

        Delete from #TempCylinderEntriesWithNewIds where 1 = 1
        Delete from #TempSuperordinateKeysWithNewIds where 1 = 1
    Commit Transaction
End

-- select elephant from Africa