CREATE TABLE ZasXlsInfos
(
    Id                       uniqueidentifier NOT NULL primary key,
    ZasNumber                nvarchar(255)    NOT NULL,
    [System]                 nvarchar(255)    NOT NULL,
    [Description]            nvarchar(max),
    CreatedBy                nvarchar(255)    NOT NULL,
    Created                  datetime2        NOT NULL default GETUTCDATE(),
    UpdatedBy                nvarchar(255),
    LastUpdated              datetime2,
)
GO
