CREATE TABLE UploadedPdfForLockingPlanInfos
(
    Id                       uniqueidentifier NOT NULL primary key,
    OrderId                  uniqueidentifier NOT NULL,
    PdfFileName              nvarchar(max)    NOT NULL,
    PdfFileDirectory         nvarchar(max)    NOT NULL,
    CreatedBy                nvarchar(255)    NOT NULL,
    Created                  datetime2        NOT NULL default GETUTCDATE(),
    UpdatedBy                nvarchar(255),
    LastUpdated              datetime2,

    CONSTRAINT FK_UploadedPdfForLockingPlanInfos_OrderId foreign key (OrderId) REFERENCES Orders,
)
GO
