create table CaratCommissions
(
    Id           uniqueidentifier primary key,
    CommissaryId nvarchar(255) not null, -- Derjenige der kommissarisch tätig wird
    CommisseeId  nvarchar(255) not null, -- Derjenige für den man kommissarisch tätig wird
    CreatedBy    nvarchar(255) not null,
    Created      datetime2     not null default GETUTCDATE(),
    UpdatedBy    nvarchar(255),
    LastUpdated  datetime2,

    CONSTRAINT FK_CaratCommissions_CommissaryId foreign key (CommissaryId) REFERENCES CustomerInformation,
    CONSTRAINT FK_CaratCommissions_CommisseeId foreign key (CommisseeId) REFERENCES CustomerInformation,
    CONSTRAINT UQ_CaratCommissions_CommisseeId_CommissaryId unique (CommissaryId, CommisseeId)
)

GO

create table CaratCommissionKeyEmbossing
(
    Id                 uniqueidentifier primary key not null default newid(),
    CaratCommissionsId uniqueidentifier             not null,
    KeyEmbossingsId    uniqueidentifier             not null,

    CONSTRAINT FK_CaratCommissionKeyEmbossing_CommissionId foreign key (CaratCommissionsId) REFERENCES CaratCommissions on delete cascade,
    CONSTRAINT FK_CaratCommissionKeyEmbossing_KeyEmbossingId foreign key (KeyEmbossingsId) REFERENCES KeyEmbossings on delete cascade
)

alter table OrderComments
    Add
        constraint CHK_OrderComments_PrintType check (PrintType Between 0 and 2),
        constraint CHK_OrderComments_CommentType check (CommentType Between 0 and 1)
Go
