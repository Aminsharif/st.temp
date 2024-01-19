CREATE TABLE UploadedExcelFileInfos
(
    Id                       uniqueidentifier NOT NULL primary key,
    OrderId                  uniqueidentifier NOT NULL references Orders,
    ExcelFileName            nvarchar(max)    NOT NULL,
    ExcelFilePath            nvarchar(max)    NOT NULL,
    CreatedBy                nvarchar(255)    NOT NULL,
    Created                  datetime2        NOT NULL default GETUTCDATE(),
    UpdatedBy                nvarchar(255),
    LastUpdated              datetime2,
)
GO
