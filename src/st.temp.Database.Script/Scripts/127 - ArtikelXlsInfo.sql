CREATE TABLE ArtikelXlsInfos
(
    Id                       uniqueidentifier NOT NULL primary key,
    [System]                 nvarchar(255)    NOT NULL,
    PartNumber               nvarchar(255)    NOT NULL,
    PartName                 nvarchar(255)    NOT NULL,
    [Description]            nvarchar(max),
    CreatedBy                nvarchar(255)    NOT NULL,
    Created                  datetime2        NOT NULL default GETUTCDATE(),
    UpdatedBy                nvarchar(255),
    LastUpdated              datetime2,
)
GO
