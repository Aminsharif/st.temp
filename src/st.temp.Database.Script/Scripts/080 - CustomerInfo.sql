Create table CustomerInformation
(
    Id          nvarchar(255) not null primary key,
    Name        nvarchar(255) not null,
    Created     DATETIME2     not null default GETUTCDATE(),
    CreatedBy   nvarchar(255) not null,
    LastUpdated DATETIME2,
    UpdatedBy   nvarchar(255),
)

GO

Insert into CustomerInformation (Id, Name, CreatedBy)
select distinct(o.CustomerIdProAlpha), isNull(s.CustomerName, 'Unbekannt'), 'Migration'
from Orders o
         left outer join SecurityCards s on o.CustomerIdProAlpha = s.CustomerNumber
GO

alter table Orders
    add constraint FK_Orders_CustomerIdProAlpha foreign key (CustomerIdProAlpha) references CustomerInformation (Id)
Go