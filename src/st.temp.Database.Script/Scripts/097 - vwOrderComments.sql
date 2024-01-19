create view vwOrderComments as
select            ks.KeyingSystemNumber,
                  o.OrderNumber,
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
where oc.PrintType <> 0