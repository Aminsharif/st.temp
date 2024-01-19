Alter TABLE Orders
    add OrderKind int not null default 0

ALTER TABLE Orders
    add OrderDate datetime2 not null default GETUTCDATE()
