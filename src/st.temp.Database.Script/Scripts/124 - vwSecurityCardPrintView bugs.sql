ALTER TABLE SecurityCards
    ALTER COLUMN KeyingSystemId UNIQUEIDENTIFIER NULL
Go

-- Create Separator Security Cards
;
With NumberedSecurityCards as (select ROW_NUMBER() over (PARTITION BY CreatedBy order by Created) CardNumber, *
                               from SecurityCards),
     FirstSecurityCards as (select *
                            from NumberedSecurityCards
                            where CardNumber = 1)
Insert
Into SecurityCards (Id, SequenceNumber, CopyNumber, Created, CreatedBy)
select NewId(), 0, 0, GETUTCDATE(), CreatedBy
from FirstSecurityCards

Go

-- This trigger creates a separator card for Maticard in case that there is not a separator card for that card already
CREATE TRIGGER trInsertSecurityCard
    ON SecurityCards
    AFTER INSERT
    AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN
            DECLARE @createdBy NVARCHAR(255)
            SELECT @createdBy = CreatedBy FROM inserted

            -- In case that we don't have a seperator card yet, create a new one
            IF (SELECT count(*) FROM SecurityCards WHERE CreatedBy = @createdBy AND KeyingSystemId is null) <= 0
                BEGIN
                    INSERT INTO SecurityCards (Id, CreatedBy, Created, CopyNumber, SequenceNumber)
                    VALUES (NewId(), @createdBy, GETUTCDATE(), 0, 0)
                END
                -- Otherwise reset the security card state for that entry
            ELSE
                BEGIN
                    DECLARE @Id UNIQUEIDENTIFIER
                    SELECT @Id = Id FROM SecurityCards WHERE CreatedBy = @createdBy AND KeyingSystemId is null

                    Update maticard.SecurityCardStates
                    set LogEmboss           = null,
                        LogProductionDate   = null,
                        LogProductionResult = null
                    WHERE Id = @Id
                END
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
END

Go

CREATE TRIGGER trDeleteSecurityCard
    ON SecurityCards
    AFTER DELETE
    AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN
            DECLARE @createdBy NVARCHAR(255)
            SELECT @createdBy = CreatedBy FROM deleted

            -- Delete Separator Cards if no cards for that user in batch
            IF (SELECT count(*) FROM SecurityCards WHERE CreatedBy = @createdBy AND KeyingSystemId is not null) <= 0
                BEGIN
                    DELETE FROM SecurityCards WHERE CreatedBy = @createdBy AND KeyingSystemId is null
                END
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
END
Go

ALTER VIEW [dbo].[vwSecurityCardPrintQueue] AS
    With securityCardData as (SELECT sc.Id,
                                     ks.KeyingSystemNumber,
                                     ksk.Name,
                                     sc.CreatedBy,
                                     sc.Created,
                                     sc.CopyText,
                                     sc.Text1,
                                     sc.Text2,
                                     sc.Text3,
                                     msc.LogEmboss,
                                     msc.LogProductionDate,
                                     msc.LogProductionResult,
                                     msc.Marked,
                                     sc.SequenceNumber,
                                     sc.CopyNumber,
                                     kst.CardCaption,
                                     IIF(ks.KeyingSystemNumber is null, 1, 0) isSeparator
                              FROM dbo.SecurityCards sc
                                       Left outer JOIN KeyingSystems ks on sc.KeyingSystemId = ks.Id
                                       Left outer JOIN KeyingSystemKinds ksk
                                                       on ksk.Id = ks.KeyingSystemKindId -- employee records without system kind
                                       Left outer JOIN KeyingSystemTypes kst
                                                       on kst.Id = ks.KeyingSystemTypeId -- employee records without system type
                                       left outer join [maticard].SecurityCardStates msc on msc.Id = sc.Id)

    SELECT Top 10000 CONVERT(nvarchar(36), Id)                             ID,
                     IIF(isSeparator = 1, '', KeyingSystemNumber)          SKANL,
                     IIF(isSeparator = 1, '', Name)                        SKANA,
                     IIF(isSeparator = 1, '', CardCaption)                 SKASY,                -- SKBEA in case of separator

                     RIGHT('000' + CAST(SequenceNumber AS NVARCHAR(3)), 3) SKNR1,                -- Copy Number
                     ''                                                    SKFI1,

                     RIGHT('00' + CAST(CopyNumber AS NVARCHAR(2)), 2)      SKNR2,                -- Copy Counter
                     ''                                                    SKFI2,
                     RIGHT(FORMAT(Created, 'ddMMyyyy'), 8)                 SKBDT,
                     ''                                                    SKFI3,
                     'WK'                                                  SKWIL,                -- WK 
                     IIF(isSeparator = 1, '', CopyText)                    SKCPY,
                     CreatedBy                                             SKBEA,
                     'Wilka'                                               SKKAR,
                     IIF(isSeparator = 1, '', Text1)                       SKTX1,
                     IIF(isSeparator = 1, '', Text2)                       SKTX2,
                     IIF(isSeparator = 1, '', Text3)                       SKTX3,
                     LogEmboss                                             M_Log_Emboss,
                     ''                                                    M_Split_Id,
                     CAST(LogProductionDate AS datetime)                   M_LogProductionDate,  --Datetime in Maticard sw
                     LogProductionResult                                   M_LogProductionResult,--INT in Maticard sw
                     Marked                                                M_Marked              --INT in Maticard sw
    from securityCardData
    order by CreatedBy, isSeparator desc
Go

-- Instead of UPDATE trigger of Maticard Pro after printing cards
    Alter TRIGGER UpdatePrintQueueTrigger
    ON dbo.vwSecurityCardPrintQueue
    INSTEAD OF UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @id uniqueidentifier;
        SELECT @id = INSERTED.Id FROM INSERTED;

        IF UPDATE(M_LogProductionDate)
            BEGIN
                DECLARE @prodDate datetime2;
                SELECT @prodDate = INSERTED.M_LogProductionDate FROM INSERTED WHERE INSERTED.ID = @id;

                Declare @createdBy nvarchar(255)
                SELECT @createdBy = INSERTED.SKBEA FROM INSERTED WHERE INSERTED.ID = @id;

                MERGE INTO [maticard].SecurityCardStates AS Target
                USING (VALUES (@id, @prodDate)) AS Source (id, LogProductionDate)
                ON Target.id = Source.id
                WHEN MATCHED THEN
                    UPDATE
                    SET Target.LogProductionDate = Source.LogProductionDate
                WHEN NOT MATCHED THEN
                    INSERT (id, LogProductionDate)
                    VALUES (Source.id, Source.LogProductionDate);
            END

        IF UPDATE(M_LogProductionResult)
            BEGIN
                DECLARE @prodResult nvarchar(255);
                SELECT @prodResult = INSERTED.M_LogProductionResult FROM INSERTED WHERE INSERTED.ID = @id;

                MERGE INTO [maticard].SecurityCardStates AS Target
                USING (VALUES (@id, @prodResult)) AS Source (id, LogProductionResult)
                ON Target.id = Source.id
                WHEN MATCHED THEN
                    UPDATE
                    SET Target.LogProductionResult = Source.LogProductionResult
                WHEN NOT MATCHED THEN
                    INSERT (id, LogProductionResult)
                    VALUES (Source.id, Source.LogProductionResult);
            END

        IF UPDATE(M_Log_Emboss)
            BEGIN
                SET NOCOUNT ON;
                BEGIN TRY
                    BEGIN TRAN
                        DECLARE @logEmboss nvarchar(255);
                        SELECT @logEmboss = INSERTED.M_Log_Emboss FROM INSERTED WHERE INSERTED.ID = @id;

                        -- Adds created state to internal used states history
                        If (@logEmboss = 3)
                            Begin
                                Insert into SecurityCardStateHistories
                                    (Id, SecurityCardId, SecurityCardState, CreatedBy, Created)
                                Values (NewId(), @id, 2, @createdBy, GETUTCDATE())
                            end

                        MERGE INTO [maticard].SecurityCardStates AS Target
                        USING (VALUES (@id, @logEmboss)) AS Source (id, LogEmboss)
                        ON Target.id = Source.id
                        WHEN MATCHED THEN
                            UPDATE
                            SET Target.LogEmboss = Source.LogEmboss
                        WHEN NOT MATCHED THEN
                            INSERT (id, LogEmboss)
                            VALUES (Source.id, Source.LogEmboss);

                    Commit Tran
                END TRY
                BEGIN CATCH
                    ROLLBACK TRAN
                END CATCH
            END

        IF UPDATE(M_Marked)
            BEGIN
                DECLARE @marked nvarchar(255);
                SELECT @marked = INSERTED.M_Marked FROM INSERTED WHERE INSERTED.ID = @id;

                MERGE INTO [maticard].SecurityCardStates AS Target
                USING (VALUES (@id, @marked)) AS Source (id, Marked)
                ON Target.id = Source.id
                WHEN MATCHED THEN
                    UPDATE
                    SET Target.Marked = Source.Marked
                WHEN NOT MATCHED THEN
                    INSERT (id, Marked)
                    VALUES (Source.id, Source.Marked);
            END
    END
GO

/****** Object:  View [dbo].[vwOrders]    Script Date: 03.04.2023 09:40:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vwOrders] as
    select                      ks.KeyingSystemNumber,
                                o.Id,
                                KeyingSystemId,
                                OrderNumber,
                                OrderNumberProAlpha,
                                CustomerIdProAlpha,
                                o.Note,
                                ShipmentDate,
                                ot.Name       OrderType,
                                kst.IsCarat,
                                o.CreatedBy,
                                o.Created,
                                o.UpdatedBy,
                                o.LastUpdated,
                                o.IsCalculation,
                                o.IsFunctionRequest,
                                o.AdditionalKeyCost,
                                o.CustomerOrderNumber,
                                OrderKind,
                                OrderDate,
                                ShippingAddress_Name1,
                                ShippingAddress_Name2,
                                ShippingAddress_Street,
                                ShippingAddress_HouseNumber,
                                ShippingAddress_Country,
                                ShippingAddress_City,
                                ShippingAddress_PostalCode,
                                ShipmentTermsIdProAlpha,
                                ShippingMethodIdProAlpha,
                                KeyNumberingPrice,
                                ke.Value      KeyEmbossing,
        KeyNumberingType      = Case ks.KeyNumberingType
                                    When 0 Then 'None'
                                    When 1 Then 'Sequential'
                                    When 2 Then 'SequentialSuperordinateKey'
                                    When 3 Then 'Manual'
                                    End,
        KeyingSystemShortname = Case kst.Id
                                    When '08E53D25-D843-4F60-BB56-448E0C16D080' Then 'STD'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D081' Then 'WZ'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D082' Then '2VE'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D083' Then 'HSR'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D084' Then '3VE'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D09E' Then '3VE' -- 3VE SKG
                                    When '08E53D25-D843-4F60-BB56-448E0C16D085' Then 'STR' -- STR
                                    When '08E53D25-D843-4F60-BB56-448E0C16D086' Then 'TH6' -- ??
                                    When '08E53D25-D843-4F60-BB56-448E0C16D087' Then 'SI6'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D088' Then '2VS'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D089' Then '3VS'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D08A'
                                        Then 'STR' -- Primus VL                                    
                                    When '08E53D25-D843-4F60-BB56-448E0C16D090' Then 'STR' -- Primus VX
                                    When '08E53D25-D843-4F60-BB56-448E0C16D091' Then '3VE' -- Primus HX
                                    When '08E53D25-D843-4F60-BB56-448E0C16D092' Then 'S1'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D093' Then 'S3'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D094' Then 'S4'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D095' Then 'S5'
                                    When '08E53D25-D843-4F60-BB56-448E0C16D096' Then 'CARAT' -- Carat CSS
                                    When '08E53D25-D843-4F60-BB56-448E0C16D097' Then 'CS1' -- Carat CSS manuell
                                    When '08E53D25-D843-4F60-BB56-448E0C16D098' Then 'TH6' -- Carat P1
                                    When '08E53D25-D843-4F60-BB56-448E0C16D099' Then '2VE' -- Carat P2

                                    End,
                                m.LockwizName KeyingSystemLockwizName
    from Orders o
             inner join KeyingSystems ks on o.KeyingSystemId = ks.Id
             inner join KeyingSystemTypes kst on ks.KeyingSystemTypeId = kst.Id
             inner join OrderTypes ot on o.OrderTypeId = ot.Id
             left outer join KeyEmbossings ke on ke.Id = o.KeyEmbossingId
             left outer join Lockwiz.KeyingSystemKindMappings m on ks.KeyingSystemKindId = m.KeyingSystemKindId and
                                                                   ks.KeyingSystemTypeId = m.KeyingSystemTypeId
GO