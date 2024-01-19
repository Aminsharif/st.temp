alter table CaratCommissions
    drop constraint FK_CaratCommissions_CommisseeId
Go

alter table CaratCommissions
    drop constraint UQ_CaratCommissions_CommisseeId_CommissaryId
Go

alter table CaratCommissions
    drop column CommisseeId

GO

alter table CaratCommissions
    add Caption nvarchar(max) not null default 'Caption'
Go


