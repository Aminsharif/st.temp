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

    update o
    set o.OrderNumberProAlpha = @orderNumberProAlpha
    from Orders o
             inner join KeyingSystems k on o.KeyingSystemId = k.Id
    where k.KeyingSystemNumber = @keyingSystemNumber
      and o.OrderNumber = @orderNumber
      and o.OrderNumberProAlpha is null
End
Go