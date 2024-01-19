-- Erweitern der Tabelle SecurityCardStates um die neuen Spalten
ALTER TABLE [maticard].SecurityCardStates
    ADD Created datetime2 not null default GETUTCDATE(),
        CreatedBy nvarchar(255),
        LastUpdated datetime2

Drop TRIGGER trDeleteSecurityCard
Go

-- This trigger creates a separator card for Maticard in case that there is not a separator card for that card already
    ALTER TRIGGER trInsertSecurityCard
    ON SecurityCards
    AFTER INSERT
    AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRAN
                DECLARE @id uniqueidentifier;
                SELECT @id = INSERTED.Id FROM INSERTED;

                IF (@id IS NULL)
                    BEGIN
                        RETURN;
                    END

                Declare @createdBy nvarchar(255)
                SELECT @createdBy = INSERTED.CreatedBy FROM INSERTED WHERE INSERTED.ID = @id;

                MERGE INTO [maticard].SecurityCardStates AS Target
                USING (VALUES (@id)) AS Source (id)
                ON Target.id = Source.id
                WHEN NOT MATCHED THEN
                    INSERT (id, CreatedBy)
                    VALUES (Source.id, @createdBy);
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
                                     msc.CreatedBy,
                                     msc.Created,
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
                                     kst.CardCaption
                              FROM dbo.SecurityCards sc
                                       Left outer JOIN KeyingSystems ks on sc.KeyingSystemId = ks.Id
                                       Left outer JOIN KeyingSystemKinds ksk
                                                       on ksk.Id = ks.KeyingSystemKindId -- employee records without system kind
                                       Left outer JOIN KeyingSystemTypes kst
                                                       on kst.Id = ks.KeyingSystemTypeId -- employee records without system type
                                       inner join [maticard].SecurityCardStates msc on msc.Id = sc.Id)

    SELECT ROW_NUMBER() Over (order by CreatedBy)                Id,
           CONVERT(nvarchar(36), Id)                             SecurityCardId,
           KeyingSystemNumber                                    SKANL,
           Name                                                  SKANA,
           CardCaption                                           SKASY,                -- SKBEA in case of separator

           RIGHT('000' + CAST(SequenceNumber AS NVARCHAR(3)), 3) SKNR1,                -- Copy Number
           ''                                                    SKFI1,

           RIGHT('00' + CAST(CopyNumber AS NVARCHAR(2)), 2)      SKNR2,                -- Copy Counter
           ''                                                    SKFI2,
           RIGHT(FORMAT(Created, 'ddMMyyyy'), 8)                 SKBDT,
           ''                                                    SKFI3,
           'WK'                                                  SKWIL,                -- WK 
           CopyText                                              SKCPY,
           CreatedBy                                             SKBEA,
           'Wilka'                                               SKKAR,
           Text1                                                 SKTX1,
           Text2                                                 SKTX2,
           Text3                                                 SKTX3,
           LogEmboss                                             M_Log_Emboss,
           ''                                                    M_Split_Id,
           CAST(LogProductionDate AS datetime)                   M_LogProductionDate,  --Datetime in Maticard sw
           LogProductionResult                                   M_LogProductionResult,--INT in Maticard sw
           Marked                                                M_Marked              --INT in Maticard sw
    from securityCardData
Go

Alter TRIGGER UpdatePrintQueueTrigger
    ON dbo.vwSecurityCardPrintQueue
    INSTEAD OF UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @securityCardId uniqueidentifier;
        SELECT @securityCardId = INSERTED.SecurityCardId FROM INSERTED;

        Declare @createdBy nvarchar(255)
        SELECT @createdBy = INSERTED.SKBEA FROM INSERTED WHERE INSERTED.SecurityCardId = @securityCardId;

        IF UPDATE(M_LogProductionDate)
            BEGIN
                DECLARE @prodDate datetime2;
                SELECT @prodDate = INSERTED.M_LogProductionDate
                FROM INSERTED
                WHERE INSERTED.SecurityCardId = @securityCardId;

                MERGE INTO [maticard].SecurityCardStates AS Target
                USING (VALUES (@securityCardId, @prodDate)) AS Source (securityCardId, LogProductionDate)
                ON Target.Id = Source.securityCardId
                WHEN MATCHED THEN
                    UPDATE
                    SET Target.LogProductionDate = Source.LogProductionDate;
            END

        IF UPDATE(M_LogProductionResult)
            BEGIN
                DECLARE @prodResult nvarchar(255);
                SELECT @prodResult = INSERTED.M_LogProductionResult
                FROM INSERTED
                WHERE INSERTED.SecurityCardId = @securityCardId;

                MERGE INTO [maticard].SecurityCardStates AS Target
                USING (VALUES (@securityCardId, @prodResult)) AS Source (securityCardId, LogProductionResult)
                ON Target.Id = Source.securityCardId
                WHEN MATCHED THEN
                    UPDATE
                    SET Target.LogProductionResult = Source.LogProductionResult;
            END

        IF UPDATE(M_Log_Emboss)
            BEGIN
                SET NOCOUNT ON;
                BEGIN TRY
                    BEGIN TRAN
                        DECLARE @logEmboss nvarchar(255);
                        SELECT @logEmboss = INSERTED.M_Log_Emboss
                        FROM INSERTED
                        WHERE INSERTED.SecurityCardId = @securityCardId;

                        -- Adds created state to internal used states history
                        If (@logEmboss = 3)
                            Begin
                                Insert into SecurityCardStateHistories
                                    (Id, SecurityCardId, SecurityCardState, CreatedBy, Created)
                                Values (NewId(), @securityCardId, 2, @createdBy, GETUTCDATE())
                            end

                        MERGE INTO [maticard].SecurityCardStates AS Target
                        USING (VALUES (@securityCardId, @logEmboss)) AS Source ([@securityCardId], LogEmboss)
                        ON Target.Id = Source.[@securityCardId]
                        WHEN MATCHED THEN
                            UPDATE
                            SET Target.LogEmboss = Source.LogEmboss;

                    Commit Tran
                END TRY
                BEGIN CATCH
                    ROLLBACK TRAN
                END CATCH
            END

        IF UPDATE(M_Marked)
            BEGIN
                DECLARE @marked nvarchar(255);
                SELECT @marked = INSERTED.M_Marked FROM INSERTED WHERE INSERTED.SecurityCardId = @securityCardId;

                MERGE INTO [maticard].SecurityCardStates AS Target
                USING (VALUES (@securityCardId, @marked)) AS Source (id, Marked)
                ON Target.Id = Source.id
                WHEN MATCHED THEN
                    UPDATE
                    SET Target.Marked = Source.Marked;
            END
    END
GO

-- Migrate security Cards

Begin Transaction
delete
from SecurityCards
where Id in (select Id from SecurityCards where KeyingSystemId is null)

delete
from maticard.SecurityCardStates

insert into maticard.SecurityCardStates (Id, CreatedBy) (select Id, CreatedBy from SecurityCards)

Commit TRANSACTION

Go