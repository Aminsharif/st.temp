Alter table CustomerInformation
    add DefaultSecurityCardPrintBlank nvarchar(255)
GO

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
                                     kst.CardCaption,
                                     ci.DefaultSecurityCardPrintBlank
                              FROM dbo.SecurityCards sc
                                       Left outer JOIN KeyingSystems ks on sc.KeyingSystemId = ks.Id
                                       Left outer JOIN KeyingSystemKinds ksk
                                                       on ksk.Id = ks.KeyingSystemKindId -- employee records without system kind
                                       Left outer JOIN KeyingSystemTypes kst
                                                       on kst.Id = ks.KeyingSystemTypeId -- employee records without system type
                                       inner join Orders o on sc.OrderId = o.Id
                                       Left outer join CustomerInformation ci on o.CustomerIdProAlpha = ci.Id
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
           isNull(DefaultSecurityCardPrintBlank, 'Wilka')        SKKAR,
           Text1                                                 SKTX1,
           Text2                                                 SKTX2,
           Text3                                                 SKTX3,
           LogEmboss                                             M_Log_Emboss,
           ''                                                    M_Split_Id,
           CAST(LogProductionDate AS datetime)                   M_LogProductionDate,  --Datetime in Maticard sw
           LogProductionResult                                   M_LogProductionResult,--INT in Maticard sw
           Marked                                                M_Marked              --INT in Maticard sw
    from securityCardData