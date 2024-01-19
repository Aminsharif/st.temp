ALTER TABLE [dbo].CaratProfiles
    SET (SYSTEM_VERSIONING = OFF)
Go
drop table CaratProfilesHistory
GO

drop table CaratProfiles

go

create table CaratProfiles
(
    Id                 uniqueidentifier not null primary key,
    Name               nvarchar(255)    not null,
    CreatedBy          nvarchar(255)    not null,
    Created            datetime2        not null default GETUTCDATE(),
    UpdatedBy          nvarchar(255),
    LastUpdated        datetime2,
    KeyingSystemTypeId uniqueidentifier not null,

    Constraint UQ_CaratProfiles_Name Unique (Name),
    CONSTRAINT FK_CaratProfiles_KeyingSystemTypeId foreign key (KeyingSystemTypeId) REFERENCES KeyingSystemTypes,
)

create table CustomerInformationCaratProfile
(
    Id                            uniqueidentifier not null primary key,
    IsActive                      bit              not null default 1,
    CustomerInformationId         nvarchar(255)    not null,
    PreviousCustomerInformationId nvarchar(255),
    CaratProfileId                uniqueidentifier not null,

    CreatedBy                     nvarchar(255)    not null,
    Created                       datetime2        not null default GETUTCDATE(),
    UpdatedBy                     nvarchar(255),
    LastUpdated                   datetime2,

    Constraint UQ_CustomerCaratProfile_CustomerInformationId_CaratProfileId Unique (CustomerInformationId, CaratProfileId, PreviousCustomerInformationId),
    CONSTRAINT FK_CustomerCaratProfile_CaratProfileId foreign key (CustomerInformationId) REFERENCES CustomerInformation,
    CONSTRAINT FK_CustomerCaratProfile_PreviousCustomerInformationId foreign key (PreviousCustomerInformationId) REFERENCES CustomerInformation,
    CONSTRAINT FK_CustomerCaratProfile_CustomerInformationId foreign key (CustomerInformationId) REFERENCES CustomerInformation
)

Go

alter table KeyEmbossings
    add
        Text1 nvarchar(1200),
        Text2 nvarchar(1200),
        Note nvarchar(max)
Go 
    
    