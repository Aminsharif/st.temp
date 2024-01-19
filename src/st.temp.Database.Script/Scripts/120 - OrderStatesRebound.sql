alter table OrderStates
    add Rebound int not null default 1

GO


Create NONCLUSTERED index idx_OrderStates_OrderId on OrderStates (OrderId)

Go