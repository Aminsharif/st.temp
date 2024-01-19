EXEC sp_rename 'LockwizProductionCalculations', 'KeyingSystemCalculationEntries';

Go

EXEC sp_rename 'KeyingSystemCalculationEntries.UpdatedAt', 'LastUpdated', 'COLUMN';
Go

alter table KeyingSystemCalculationEntries
    add
        CreatedBy nvarchar(255) not null default 'System',
        Created datetime2 not null default GETUTCDATE(),
        UpdatedBy nvarchar(255)
go

ALTER View [dbo].[vwAusrechnung] as
    select l.LockwizName                             KeyingSystemName,
           ks.KeyingSystemNumberId                   Anlagennummer,
           [Schliessungsnummer],
           isNull([IdNrdAusrechnung], 0)             IdNrdAusrechnung,
           SchliessungSchluessel,
           ProfilgruppeSchluessel,
           ErganzungSchluessel,
           Serie1bzwASchluessel,
           Serie2bzwBSchluessel,
           isNull(Serie3bzwCSchluessel, Space(5))    Serie3bzwCSchluessel,
           BohrungenFTaststSchluessel,
           isNull(SchliessungKern, Space(7))         SchliessungKern,
           isNull(Aufbau1Kern, Space(7))             Aufbau1Kern,
           isNull(Aufbau2Kern, Space(7))             Aufbau2Kern,
           isNull(Aufbau3Kern, Space(7))             Aufbau3Kern,
           isNull(Aufbau4Kern, Space(7))             Aufbau4Kern,
           isNull(ProfilgruppeKern, Space(6))        ProfilgruppeKern,
           isNull(ErgaenzungKern, Space(5))          ErgaenzungKern,
           isNull(Serie1bzwAKern, Space(5))          Serie1bzwAKern,
           isNull(Serie2bzwBKern, Space(5))          Serie2bzwBKern,
           isNull(Serie3bzwCKern, Space(5))          Serie3bzwCKern,
           isNull(TaststifteKern, Space(12))         TaststifteKern,
           kst.ProAlphaReferenceForCylinders         AnlagensystemZylinder,
           kst.ProAlphaReferenceForSuperordinateKeys AnlagensystemUebergeordneterSchluessel,
           ksk.ProAlphaReference                     Anlagenart,
           l.LockwizName                             AnlagenartLockwiz,
           kst.IsCarat                               IstCarat,
           o.CustomerIdProAlpha                      Kundennummer,
           calc.LastUpdated
    from KeyingSystemCalculationEntries calc
             inner join Orders o on calc.OrderId = o.Id
             inner join KeyingSystems ks on ks.Id = o.KeyingSystemId
             inner join KeyingSystemNumbers ksn on ks.KeyingSystemNumberId = ksn.Id
             inner join KeyingSystemTypes kst on kst.Id = ksn.KeyingSystemTypeId
             left outer join KeyingSystemKinds ksk on ksk.Id = ks.KeyingSystemKindId
             left outer join Lockwiz.KeyingSystemKindMappings l
                             on ks.KeyingSystemKindId = l.KeyingSystemKindId and
                                ksn.KeyingSystemTypeId = l.KeyingSystemTypeId

GO