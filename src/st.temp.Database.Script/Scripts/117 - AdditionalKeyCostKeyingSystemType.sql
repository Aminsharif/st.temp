create table DefaultAdditionalKeyCostKeyingSystemTypes
(
    Id                       uniqueidentifier not null primary key,
    CustomerInformationId    nvarchar(255)
        constraint FK_AdditionalKeyCostKeyingSystemType_CustomerInformation references CustomerInformation,
    KeyingSystemTypeId       uniqueidentifier
        constraint FK_AdditionalKeyCostKeyingSystemType_KeyingSystemTypes references KeyingSystemTypes,
    CaratCommissionId        uniqueidentifier
        constraint FK_AdditionalKeyCostKeyingSystemType_CaratCommissions references CaratCommissions,
    DefaultAdditionalKeyCost decimal(10, 2)   not null default 0,
    Created                  DATETIME2        not null default GETUTCDATE(),
    CreatedBy                nvarchar(255)    not null,
)

GO

Create UNIQUE Index UQ_AdditionalKeyCostKeyingSystemType_CustomerInformation On DefaultAdditionalKeyCostKeyingSystemTypes (CustomerInformationId, KeyingSystemTypeId, CaratCommissionId)
GO

alter table CustomerInformation
    drop column DefaultAdditionalKeyCost

Go