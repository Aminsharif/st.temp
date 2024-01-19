        sp_rename 'KeyingSystemTypes.ProAlphaReference', 'ProAlphaReferenceForCylinders', 'COLUMN'
        GO

        alter table KeyingSystemTypes
            add ProAlphaReferenceForSuperordinateKeys nvarchar(255) not null default '-'
        Go

-- Standard
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System Standard'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D080'
        GO

-- WZ 
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = '-'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D081'
        GO

-- 2VE
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System 2VE'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D082'
        GO

-- HSR 
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System HSR'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D083'
        GO

-- 3VE
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System 3VE'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D084'
        GO

-- STR 
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System STR'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D085'
        GO

-- TH6
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System TH6'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D086'
        GO

-- SI6
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System SI6'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D087'
        GO

-- 2VS
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System 2VS'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D088'
        GO

-- 3VS
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'System 3VS'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D089'
        GO

-- Primus VL
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'Primus VL'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D08A'
        GO

-- Primus VX
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'Primus VX'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D090'
        GO

-- Primus HX
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'Primus HX'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D091'
        GO

-- Carat S1
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'S1-Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D092'
        GO

-- Carat S3
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'S3-Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D093'
        GO

-- Carat S4
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'S4-Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D094'
        GO

-- Carat S5
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'S5-Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D095'
        GO

-- Carat CSS
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'CSS - Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D096'
        GO

-- Carat CSS manuell
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'CSS - Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D097'
        GO

-- Carat P1
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'CARAT P1-Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D098'
        GO

-- Carat P2
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'CARAT P2-Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D099'
        GO

-- Carat P3
        update KeyingSystemTypes
        set ProAlphaReferenceForSuperordinateKeys = 'CARAT P3-Profil'
        where Id = '08E53D25-D843-4F60-BB56-448E0C16D09A'
        GO

        Alter View Ausrechnung as
            select ks.KeyingSystemNumber                    Anlagennummer,
                   [Schliessungsnummer],
                   isNull([IdNrdAusrechnung], 0)            IdNrdAusrechnung,
                   SchliessungSchluessel,
                   ProfilgruppeSchluessel,
                   ErganzungSchluessel,
                   Serie1bzwASchluessel,
                   Serie2bzwBSchluessel,
                   isNull(Serie3bzwCSchluessel, Space(5))   Serie3bzwCSchluessel,
                   BohrungenFTaststSchluessel,
                   isNull(SchliessungKern, Space(7))        SchliessungKern,
                   isNull(Aufbau1Kern, Space(7))            Aufbau1Kern,
                   isNull(Aufbau2Kern, Space(7))            Aufbau2Kern,
                   isNull(Aufbau3Kern, Space(7))            Aufbau3Kern,
                   isNull(Aufbau4Kern, Space(7))            Aufbau4Kern,
                   isNull(ProfilgruppeKern, Space(6))       ProfilgruppeKern,
                   isNull(ErgaenzungKern, Space(5))         ErgaenzungKern,
                   isNull(Serie1bzwAKern, Space(5))         Serie1bzwAKern,
                   isNull(Serie2bzwBKern, Space(5))         Serie2bzwBKern,
                   isNull(Serie3bzwCKern, Space(5))         Serie3bzwCKern,
                   isNull(TaststifteKern, Space(12))        TaststifteKern,
                   kst.ProAlphaReferenceForCylinders        AnlagensystemZylinder,
                   kst.ProAlphaReferenceForSuperordinateKeys AnlagensystemUebergeordneterSchluessel,
                   ksk.ProAlphaReference                    Anlagenart,
                   calc.UpdatedAt
            from LockwizProductionCalculations calc
                     inner join Orders o on calc.OrderId = o.Id
                     inner join KeyingSystems ks on ks.Id = o.KeyingSystemId
                     inner join KeyingSystemTypes kst on kst.Id = ks.KeyingSystemTypeId
                     left outer join KeyingSystemKinds ksk on ksk.Id = ks.KeyingSystemKindId
        GO
