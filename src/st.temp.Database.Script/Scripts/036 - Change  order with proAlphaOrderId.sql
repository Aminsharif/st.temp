Drop procedure SetOrderNumberForKeyingSystem
Go

Go
create PROCEDURE SetOrderNumberForKeyingSystem(@keyingSystemNumber nvarchar(255),
                                               @orderNumber int,
                                               @orderNumberProAlpha nvarchar(255)) as
Begin

    If not exists(select *
                  from Orders o
                           inner join KeyingSystems k on o.KeyingSystemId = k.Id
                  where k.KeyingSystemNumber = @keyingSystemNumber
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
    where k.KeyingSystemNumber = @keyingSystemNumber
      and o.OrderNumber = @orderNumber
      and o.OrderNumberProAlpha is null
End
Go

Go
Create PROCEDURE SetProductConfiguratorFinalizationComplete(@keyingSystemNumber nvarchar(255), @orderNumber int) as
Begin
    If not exists(select *
                  from Orders o
                           inner join KeyingSystems k on o.KeyingSystemId = k.Id
                  where k.KeyingSystemNumber = @keyingSystemNumber
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
    where k.KeyingSystemNumber = @keyingSystemNumber
      and o.OrderNumber = @orderNumber
end
Go

Alter View [dbo].[KeyLabels] as
    select ks.KeyingSystemNumber,
           Right('00000' + cast(o.OrderNumber as nvarchar(10)), 6) OrderNumber,
           ces.LockwizId,
           ces.Locking,
           ckl.Label,
           'Cylinder'                                              Type
    from KeyingSystems ks
             inner join Orders o on ks.Id = o.KeyingSystemId
             inner join CylinderEntries ces on o.Id = ces.OrderId
             inner join CylinderEntryKeyLabels ckl on ces.Id = ckl.CylinderEntryId
    union
    select ks.KeyingSystemNumber,
           Right('00000' + cast(o.OrderNumber as nvarchar(10)), 6) OrderNumber,
           sks.LockwizId,
           sks.Locking,
           skl.Label,
           'SuperordinateKey'                                      Type
    from KeyingSystems ks
             inner join Orders o on ks.Id = o.KeyingSystemId
             inner join SuperordinateKeys sks on o.Id = sks.OrderId
             inner join SuperordinateKeyLabels skl on sks.Id = skl.SuperordinateKeyId
GO