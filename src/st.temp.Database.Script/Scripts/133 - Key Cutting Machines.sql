create table KeyCuttingMachines
(
    Id                    uniqueidentifier not null primary key,
    Name                  nvarchar(255)    not null,
    IsActive              bit              not null default 1,
    Description           nvarchar(max)    not null,
    FileSuffix            nvarchar(255)    not null,
    BusinessLogicLocation nvarchar(255)    not null,
    CreatedBy             nvarchar(255)    not null,
    Created               datetime2        not null default GETUTCDATE(),
    UpdatedBy             nvarchar(255),
    LastUpdated           datetime2,
)

Go

create table KeyCuttingMachineKeyingSystemType
(
    Id                   uniqueidentifier not null primary key default NEWID(),
    KeyCuttingMachinesId uniqueidentifier not null,
    KeyingSystemTypesId  uniqueidentifier not null
)

ALTER TABLE KeyCuttingMachineKeyingSystemType
    ADD CONSTRAINT FK_KeyCuttingMachineKeyingSystemType_KeyCuttingMachines FOREIGN KEY (KeyCuttingMachinesId)
        REFERENCES KeyCuttingMachines
        ON DELETE cascade;

ALTER TABLE KeyCuttingMachineKeyingSystemType
    ADD CONSTRAINT FK_KeyCuttingMachineKeyingSystemType_KeyingSystemType FOREIGN KEY (KeyingSystemTypesId)
        REFERENCES KeyingSystemTypes
        ON DELETE cascade;

Go

create table CustomerInformationKeyCuttingMachine
(
    Id                          uniqueidentifier not null primary key default NEWID(),
    CustomerInformationsId      nvarchar(255)    not null,
    KeyCuttingCuttingMachinesId uniqueidentifier not null
)

ALTER TABLE CustomerInformationKeyCuttingMachine
    ADD CONSTRAINT FK_CustomerInformationKeyCuttingMachine_KeyCuttingMachinesId FOREIGN KEY (KeyCuttingCuttingMachinesId)
        REFERENCES KeyCuttingMachines
        ON DELETE cascade;

ALTER TABLE CustomerInformationKeyCuttingMachine
    ADD CONSTRAINT FK_CustomerInformationKeyCuttingMachine_CustomerInformationId FOREIGN KEY (CustomerInformationsId)
        REFERENCES CustomerInformation
        ON DELETE cascade;