create table CaratProfiles
(
    Id                    uniqueidentifier not null primary key,
    CustomerInformationId nvarchar(255),
    Name                  nvarchar(255)    not null,
    CreatedBy             nvarchar(255)    not null,
    Created               datetime2        not null default GETUTCDATE(),
    UpdatedBy             nvarchar(255),
    LastUpdated           datetime2,
    KeyingSystemTypeId    uniqueidentifier not null,
    Constraint UQ_Name Unique (Name),
    CONSTRAINT FK_CaratProfiles_KeyingSystemTypeId foreign key (KeyingSystemTypeId) REFERENCES KeyingSystemTypes,
    CONSTRAINT FK_CaratProfiles_CustomerInformationId foreign key (CustomerInformationId) REFERENCES CustomerInformation,
    PeriodStart           datetime2        not null default '9999-12-31T23:59:59.9999999',
    PeriodEnd             datetime2        NOT NULL DEFAULT '0001-01-01T00:00:00.0000000',
)

ALTER TABLE CaratProfiles    ADD PERIOD FOR SYSTEM_TIME ([PeriodStart], [PeriodEnd])

ALTER TABLE CaratProfiles    ALTER COLUMN [PeriodStart] ADD HIDDEN
ALTER TABLE CaratProfiles    ALTER COLUMN [PeriodEnd] ADD HIDDEN

Go
DECLARE @historyTableSchema sysname = SCHEMA_NAME()
EXEC (N'ALTER TABLE [CaratProfiles] SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [' + @historyTableSchema + '].[CaratProfilesHistory]))')