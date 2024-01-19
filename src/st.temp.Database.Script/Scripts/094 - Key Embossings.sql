create table KeyEmbossings
(
    Id                    uniqueidentifier not null primary key,
    CustomerInformationId nvarchar(255),
    Value                 nvarchar(255)    not null,
    CreatedBy             nvarchar(255)    not null,
    Created               datetime2        not null default GETUTCDATE(),
    UpdatedBy             nvarchar(255),
    LastUpdated           datetime2,
    Constraint UQ_KeyEmbossings_Value Unique (Value),
    CONSTRAINT FK_KeyEmbossings_CustomerInformationId foreign key (CustomerInformationId) REFERENCES CustomerInformation
)