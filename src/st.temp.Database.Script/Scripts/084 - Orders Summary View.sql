create view vwOrderSummaries as
(
select o.Id                   OrderId,
       LatestOrderState.Id    OrderStateId,
       LatestOrderState.Value OrderStateValue
from Orders o
         Cross Apply (Select TOP 1 os.Id, os.CreatedBy, os.Created, os.Value
                      from OrderStates os
                      where os.OrderId = o.Id
                      order by Created desc) LatestOrderState)