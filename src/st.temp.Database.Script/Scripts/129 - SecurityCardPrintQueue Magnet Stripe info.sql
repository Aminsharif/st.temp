ALTER VIEW [dbo].[vwSecurityCardPrintQueue] AS
    With securityCardData as (SELECT sc.Id,
                                     ks.KeyingSystemNumber,
                                     ksk.Name KeyingSystemKind,
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

    SELECT ROW_NUMBER() Over (order by CreatedBy)                 Id,
           CONVERT(nvarchar(36), Id)                              SecurityCardId,
           KeyingSystemNumber                                     SKANL,
           KeyingSystemKind                                       SKANA,
           CardCaption                                            SKASY,                -- SKBEA in case of separator

           RIGHT('000' + CAST(SequenceNumber AS NVARCHAR(3)), 3)  SKNR1,                -- Copy Number
           ''                                                     SKFI1,

           RIGHT('00' + CAST(CopyNumber AS NVARCHAR(2)), 2)       SKNR2,                -- Copy Counter
           ''                                                     SKFI2,
           RIGHT(FORMAT(Created, 'ddMMyyyy'), 8)                  SKBDT,
           ''                                                     SKFI3,
           'WK'                                                   SKWIL,                -- WK 
           RIGHT(REPLICATE('0', 10) + KeyingSystemNumber, 10) + KeyingSystemKind + CardCaption +
           RIGHT(REPLICATE('0', 3) + CAST(SequenceNumber AS NVARCHAR(3)), 3) + ' ' +
           RIGHT(REPLICATE('0', 2) + CAST(CopyNumber AS NVARCHAR(2)), 2) + CHAR(9) +
           RIGHT(FORMAT(Created, 'ddMMyyyy'), 8) + CHAR(9) + 'WK' SKCPY,
           CreatedBy                                              SKBEA,
           'Wilka'                                                SKKAR,
           Text1                                                  SKTX1,
           Text2                                                  SKTX2,
           Text3                                                  SKTX3,
           LogEmboss                                              M_Log_Emboss,
           ''                                                     M_Split_Id,
           CAST(LogProductionDate AS datetime)                    M_LogProductionDate,  --Datetime in Maticard sw
           LogProductionResult                                    M_LogProductionResult,--INT in Maticard sw
           Marked                                                 M_Marked              --INT in Maticard sw
    from securityCardData

Go

alter view vwOrderComments as
    (SELECT ks.KeyingSystemNumber,
            o.OrderNumber,
            oc.CommentText,
            PrintType   = Case oc.PrintType
                              When 0 Then 'Never'
                              When 1 Then 'OnlyForCurrentOrder'
                              When 2 Then 'Always' End,
            CommentType = Case oc.CommentType
                              When 0 Then 'Commercial'
                              When 1 Then 'Technical' End
     FROM Orders o
              LEFT JOIN KeyingSystems ks ON o.KeyingSystemId = ks.Id
              LEFT JOIN Orders os ON os.KeyingSystemId = ks.Id
              LEFT JOIN OrderComments oc
                        ON oc.OrderId = o.Id AND (oc.PrintType = 1 AND oc.KeyingSystemId = ks.Id OR oc.PrintType = 2))

Go