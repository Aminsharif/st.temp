Create Procedure spGetOrderComments(
    @keyingSystemNumber nvarchar(255),
    @orderNumber int = null)
as
Begin
    -- check keying system
    If not exists(select *
                  from KeyingSystems
                  where KeyingSystemNumber = @keyingSystemNumber)
        Begin
            RAISERROR (N'KeyingSystem does not exist.', -- Message text.  
                11, -- Severity does not exist,  
                1, -- State,  
                '');
        end

    -- Case 1: KeyingSystemNumber and Order Number passed => Comments For this keying System which are passed always and those only for this order without never
    if (@orderNumber is not null)
        Begin
            select ks.KeyingSystemNumber,
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
               or (ks.KeyingSystemNumber = @keyingSystemNumber
                and o.OrderNumber = @orderNumber and oc.PrintType <> 0)
        End

-- Case 2: KeyingSystemNumber passed => Comments for this keying System which are passed always
    ELSE
        Begin
            select            ks.KeyingSystemNumber,
                              null OrderNumber,
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