Create TABLE SlsData
(
    PartNumber nvarchar(255) not null unique,
    S160ST     int,
    S160AN     int,
    S160AZ     nvarchar(255),
    S160KZ     nvarchar(255),
    S160BE     nvarchar(255),
    S16061     nvarchar(255),
    S16063     nvarchar(255),
    S16065     nvarchar(255),
    S16066     nvarchar(255),
    S16071     nvarchar(255),
    S160AB     int,
    S160LB     nvarchar(255),
    S160DA     int
)

Go

create view vwMassInvestigationRawData as
select ce.Id,
       ce.PartNumber,
       ce.KeyingSystemId,
       ce.OrderId,
       sls.S160BE [Name],
       BackSet,
       LengthA,
       LengthB,
       Color,
       AE.AdditionalEquipments,
       CylindersCount,
       KeysCount,
       0          EntryType
from CylinderEntries ce
         inner join KeyingSystems ks on ce.KeyingSystemId = ks.Id
         left outer join SlsData sls on sls.PartNumber = ce.PartNumber
         outer apply (select STRING_AGG(ae.Caption, ',') AdditionalEquipments
                      from AdditionalEquipments ae
                               inner join AdditionalEquipmentCylinderEntry aece
                                          on ae.Id = aece.AdditionalEquipmentsId
                      where aece.CylinderEntriesId = ce.Id) AE

Union

select se.Id,
       se.PartNumber,
       se.KeyingSystemId,
       se.OrderId,
       sls.S160BE [Name],
       Null       BackSet,
       Null       LengthA,
       Null       LengthB,
       Null       Color,
       null       AdditionalEquipments,
       Null       CylindersCount,
       KeysCount,
       1          EntryType
from SuperordinateKeys se
         inner join KeyingSystems ks on se.KeyingSystemId = ks.Id
         left outer join SlsData sls on sls.PartNumber = se.PartNumber
Go

insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'A400', 3, 2, Null, N'KK', N'PDZ  VDS A', Null, Null, N'D', Null, Null, 0, N'KRANZ', 110998);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'A410', 3, 1, Null, N' K', N'PHZ  VDS A', Null, Null, N'D', Null, Null, 0, N'KRANZ', 110998);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B400', 3, 2, Null, N'KK', N'PDZ  VDS B', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B410', 3, 1, Null, N' K', N'PHZ  VDS B', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E400', 3, 2, Null, N'KK', N'PDZ  Elektronik', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E405', 3, 2, Null, N'KA', N'PDZ  Elektronik mit Knauf', Null, Null, N'D', Null, Null, 0, N'SIMSCH', 90198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E410', 3, 1, Null, N' K', N'PHZ  Elektronik', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E463', 3, 2, Null, N'KK', N'PDZ  Elektronik', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0491', 1, 2, Null, N'KK', N'Typ 0491', Null, N'D', Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0500', 1, 1, Null, N' K', N'Typ 0500', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0501', 1, 1, Null, N' K', N'Typ 0501', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0503', 1, 1, Null, N' K', N'Typ 0503', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0542', 0, 0, Null, Null, N'Typ 0542', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 101000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0550', 0, 1, Null, N' K', N'Typ 0550 matt vernickelt', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 210198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0560', 1, 1, Null, N' K', N'Typ 0560', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0586', 1, 1, Null, N' K', N'Typ 0586', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0587', 1, 1, Null, N' K', N'Typ 0587', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0590', 0, 1, Null, N' K', N'Typ 0590', N'N', N'N', N'N', N'N', N'N', 30, N'SIMSCH', 221104);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0592', 0, 1, Null, N' K', N'Typ 0592', N'N', N'N', Null, Null, N'N', 30, N'WEHNERT', 170203);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0593', 1, 1, Null, N' K', N'Typ 0593', Null, Null, Null, Null, Null, 30, N'ARGASIN', 130104);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0597', 1, 1, Null, N' K', N'Typ 0597 für 0550 - 0558', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0598', 1, 1, Null, N' K', N'Typ 0598', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0690', 4, 1, Null, N' K', N'Typ 0690', Null, N'D', Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0692', 1, 1, Null, N' K', N'Typ 0692', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'07-2', 1, 2, Null, N'KA', N'Knaufzyl. LgA=Achse GSV LgB=Kern', Null, Null, Null, Null, Null, 12060, N'SIMSCH',
        90198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'07-6', 1, 2, Null, N'KA', N'Knaufzyl. LgA=Kern LgB=Achse GSV', Null, Null, Null, Null, Null, 12065, N'SIMSCH',
        90198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1201', 4, 1, Null, Null, N'Typ 1201', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1211', 4, 1, Null, Null, N'Typ 1211', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1224', 4, 1, Null, Null, N'Typ 1224', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1231', 4, 1, Null, Null, N'Typ 1231', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1250', 1, 1, Null, N' K', N'Typ 1250 SW', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1251', 1, 1, Null, N' K', N'Typ 1251 SW', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1267', 1, 1, Null, N' K', N'Typ 1267 Spezial England', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1398', 3, 1, Null, N' K', N'PHZ Doppelfunktion', Null, Null, Null, Null, Null, 0, N'SIMSCH', 171197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1399', 3, 2, Null, N'KK', N'PDZ DF', Null, Null, Null, Null, Null, 0, N'SIMSCH', 40199);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1400', 3, 2, Null, N'KK', N'PDZ', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1401', 0, 0, Null, Null, N'Blindzylinder', Null, Null, N'D', N'N', N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1404', 3, 2, Null, N'AA', N'Doppelknaufzylinder', Null, Null, N'D', Null, N'N', 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1405', 3, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1407', 3, 2, N'5', N'KA', N'PDZ 5-stiftig LgA=Kern LgB=Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1410', 3, 1, N'B', N' K', N'PHZ', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1413', 0, 1, Null, N' A', N'PHZ mit Knauf', Null, Null, N'D', Null, N'N', 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1414', 3, 1, Null, N' K', N'PHZ', Null, Null, Null, Null, Null, 30, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1415', 3, 1, N'A', N'K', N'PHZ LgA=Kern LgB=Freilauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1463', 3, 2, Null, N'KK', N'PDZ', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1477', 0, 0, Null, Null, N'Handelsware WC-Zylinder', Null, Null, Null, N'N', Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1478', 3, 2, Null, N'KK', N'PDZ', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1479', 3, 2, N'L', N'KK', N'PDZ LgA=Aussen', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1480', 3, 1, N'L', N' K', N'PDZ LgA=Blind LgB=Kern', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1481', 3, 2, N'5', N'KK', N'PDZ 5-stiftig', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1482', 0, 1, Null, N' A', N'PDZ LgA=Blind LgB=Achse', Null, Null, N'D', Null, N'N', 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1483', 3, 2, N'5', N'KK', N'PDZ 5-stiftig', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1484', 3, 2, N'5', N'KA', N'PDZ 5-stiftig LgA=Kern LgB=Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1486', 0, 2, Null, N'AA', N'PDZ Achse/Achse', Null, Null, N'D', Null, N'N', 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1487', 0, 2, Null, N'AA', N'PDZ LgA=Notöffn. LgB=Achse', Null, Null, N'D', Null, N'N', 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1488', 3, 2, N'5', N'KK', N'PDZ 5-stiftig', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1489', 3, 2, N'B', N'AK', N'PDZ LgA=Notöffn. LgB=Kern', Null, Null, Null, Null, Null, 0, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2103', 2, 1, Null, N' K', N'Typ 0503                     WZ', Null, N'D', Null, Null, Null, 0, N'SIMSCH',
        90206);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2105', 2, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Knauf       WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        140198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2107', 2, 2, N'5', N'KA', N'PDZ 5-st. LgA=Kern LgB=Knauf WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        140198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2110', 2, 1, N'B', N' K', N'PHZ                          WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2113', 2, 2, Null, N'KK', N'Typ 2613                     WZ', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2114', 2, 1, Null, N' K', N'PHZ                          WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2115', 2, 1, N'B', N' K', N'PHZ                          WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2116', 2, 2, Null, N'KK', N'Typ 2530                     WZ', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2122', 2, 2, Null, N'KK', N'PDZ                          WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2124', 2, 2, Null, N'KK', N'Typ 2532                     WZ', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2131', 2, 2, Null, N'KK', N'Typ 2531                     WZ', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2132', 2, 1, Null, N' K', N'Typ 500F                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2133', 2, 1, Null, N' K', N'Vorhangschloß                WZ', Null, Null, Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2150', 2, 1, Null, N' K', N'Typ 1250                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2151', 2, 1, Null, N' K', N'Typ 1251                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2152', 2, 1, Null, N' K', N'Typ 0500                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2153', 2, 1, Null, N' K', N'Typ 0587                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2154', 2, 1, Null, N' K', N'Typ 0586                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2155', 2, 1, Null, N' K', N'Typ 0501                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2156', 2, 2, Null, N'KK', N'Typ 2534                     WZ', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2160', 2, 1, Null, N' K', N'Typ 0560                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2163', 2, 2, Null, N'KK', N'PDZ                          WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2178', 2, 2, Null, N'KK', N'PDZ                          WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2179', 2, 2, Null, N'KK', N'PDZ                          WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2180', 2, 1, N'B', N' K', N'PDZ LgA=Blind LgB=Kern       WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2181', 2, 2, N'5', N'KK', N'PDZ asymmetrisch 56,5        WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2183', 2, 2, N'5', N'KK', N'PDZ asymmetrisch 61,5        WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2184', 2, 2, N'5', N'KA', N'PDZ LgA=Kern LgB=Knauf       WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        140198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2188', 2, 2, N'5', N'KK', N'PDZ kurz                     WZ', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2189', 2, 2, N'B', N'AK', N'PDZ LgA=Notöffn. LgB=Kern    WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        140198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2191', 2, 2, Null, N'KK', N'Typ 0491                     WZ', Null, N'D', Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2192', 2, 1, Null, N' K', N'Typ 0692                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2193', 2, 1, Null, N' K', N'Typ 0593                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2197', 2, 1, Null, N' K', N'Typ 0597 für 0550-0558       WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2198', 2, 1, Null, N' K', N'Typ 0598                     WZ', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2200', 1, 1, Null, N' K', N'Vorhangschloss', Null, Null, Null, Null, Null, 30, N'SIMSCH', 221105);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2501', 0, 0, Null, Null, N'Typ 2501 Fallenschloß f. Z500', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH',
        101000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2511', 0, 0, Null, Null, N'Typ 2511 Riegelschloß f. Z500', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 61000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2516', 0, 0, Null, Null, N'Typ 2516 Riegelschloß', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 101000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2524', 0, 0, Null, Null, N'Typ 2524 Kastenschloß', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 101000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2530', 1, 2, Null, N'KK', N'Typ 2530', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2531', 1, 2, Null, N'KK', N'Typ 2531', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2532', 1, 2, Null, N'KK', N'Typ 2532', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2533', 1, 2, Null, N'KK', N'Typ 2533', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2534', 1, 2, Null, N'KK', N'Typ 2534', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2611', 0, 0, Null, Null, N'Typ 2611 Riegelschloß für 501', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH',
        101000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2613', 1, 2, Null, N'KK', N'Typ 0503', Null, N'D', Null, Null, Null, 26030, N'SIMSCH', 140809);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2614', 1, 1, Null, N' K', N'Typ 2614 Schwepper', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2616', 0, 0, Null, Null, N'Typ 2616', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 101000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2621', 0, 0, Null, Null, N'Typ 2621 Riegelschloß f. 0503', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH',
        101000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2626', 0, 0, Null, Null, N'Typ Riegelschloß', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 101000);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3005', 3, 1, Null, N'KA', N'PRIMUS HX KNAUFZYL.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 60612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'500F', 0, 1, Null, N' K', N'Typ 500F', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2130', 2, 2, Null, N'KK', N'wie 2533                     WZ', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0551', 1, 1, Null, N' K', N'Helbelzyl. S+S', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 170914);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0552', 0, 1, Null, N' K', N'wie 0550 braunoliv', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 210198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0553', 0, 1, Null, N' K', N'wie 0550 graubraun', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 210198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0554', 0, 1, Null, N' K', N'wie 0550 tiefschwarz', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 210198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0555', 0, 1, Null, N' K', N'wie 0550 reinweiss', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 210198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0556', 0, 1, Null, N' K', N'wie 0550 goldgelb', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 210198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0557', 0, 1, Null, N' K', N'wie 0550 minzgrün', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 210198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0558', 0, 1, Null, N' K', N'wie 0550 grauweiss', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 210198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0546', 0, 1, Null, N' K', N'Typ 0546', N'N', N'N', Null, Null, N'N', 30, N'WEHNERT', 170203);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0547', 0, 1, Null, N' K', N'Typ 0547', N'N', N'N', Null, Null, N'N', 30, N'WEHNERT', 170203);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0548', 0, 1, Null, N' K', N'Typ 0548', N'N', N'N', Null, Null, N'N', 30, N'WEHNERT', 170203);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0549', 0, 1, Null, N' K', N'Typ 0549', N'N', N'N', Null, Null, N'N', 30, N'WEHNERT', 170203);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1402', 3, 1, Null, N' K', N'Hebetürsicherung', Null, Null, Null, Null, Null, 30, N'SIMSCH', 280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'12/9', 0, 1, Null, N' K', N'Fenstergriff mit PHZ 1410', Null, Null, Null, Null, Null, 30, N'SIMSCH', 121197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3001', 3, 1, Null, N' K', N'PRIMUS HX VORHANGSCHLOSS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 60612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B401', 3, 2, Null, N'KK', N'PDZ  VDS B mit Querbolzen', Null, Null, N'D', Null, Null, 0, N'SIMSCH', 90403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B411', 3, 1, Null, N' K', N'PHZ  VDS B mit Querbolzen', Null, Null, N'D', Null, Null, 0, N'SIMSCH', 90403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5010', 2, 0, Null, Null, N'HS-Notschlüssel f. Serie 3000', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5020', 2, 0, Null, Null, N'HS-Notschlüssel f. 2179', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5030', 2, 0, Null, Null, N'HS-Notschlüssel f. Serie 3000 NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5040', 2, 0, Null, Null, N'HS-Notschlüssel f. 2179       NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5050', 2, 0, Null, Null, N'vergoldeter Übergabeschlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5110', 2, 0, Null, Null, N'GHS-Schlüssel                 NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5210', 2, 0, Null, Null, N'GHS-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5310', 2, 0, Null, Null, N'HS-Schlüssel                  NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5410', 2, 0, Null, Null, N'HS-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5510', 2, 0, Null, Null, N'GS-Schlüssel                  NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5610', 2, 0, Null, Null, N'GS-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5710', 2, 0, Null, Null, N'Neusilberschlüssel S200       NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'5730', 2, 0, Null, Null, N'Neusilberschlüssel S200', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6010', 1, 0, Null, Null, N'HS-Notschlüssel f. Serie 3000', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6020', 1, 0, Null, Null, N'HS-Notschlüssel f. 1479', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6030', 1, 0, Null, Null, N'HS-Notschlüssel f. Serie 3000 NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6040', 1, 0, Null, Null, N'HS-Notschlüssel f. 1479       NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6050', 1, 0, Null, Null, N'vergoldeter Übergabeschlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6060', 3, 0, Null, Null, N'DF-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6070', 3, 0, Null, Null, N'DF-Schlüssel                  NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6080', 3, 0, Null, Null, N'Elektronik-Nutzerschlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 140403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6081', 3, 0, Null, Null, N'Elektronik-Systemschlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6090', 3, 0, Null, Null, N'Elektronik-Nutzerschlüssel    NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6110', 1, 0, Null, Null, N'GHS-Schlüssel                 NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6210', 1, 0, Null, Null, N'GHS-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6310', 1, 0, Null, Null, N'HS-Schlüssel                  NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6410', 1, 0, Null, Null, N'HS-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6510', 1, 0, Null, Null, N'GS-Schlüssel                  NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6610', 1, 0, Null, Null, N'GS-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6710', 1, 0, Null, Null, N'Neusilberschlüssel S100       NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6730', 1, 0, Null, Null, N'Neusilberschlüssel S100', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 131197);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1322', 1, 2, Null, N'KK', N'S&S PDZ wie 1400', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190298);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0504', 1, 1, Null, N' K', N'Typ 0504', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 80198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0531', 0, 0, Null, Null, N'Typ 0531 Knaufolive', N'N', N'N', N'N', N'N', N'N', 0, N'KRANZ', 140198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6910', 1, 0, Null, Null, N'Neusilber Rohlinge S100', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 290198);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1310', 1, 1, N'B', N' K', N'S&S PHZ wie 1410', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190298);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1350', 1, 1, Null, N' K', N'S&S wie Typ 1250 SW', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 181103);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1388', 1, 2, N'5', N'KK', N'S&S PDZ 5-stiftig wie 1488', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190298);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0506', 1, 1, Null, N' K', N'S&S wie 0500', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 230298);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0940', 0, 1, N'5', N' K', N'Rundzylinder Fa. Fuhr', Null, Null, Null, Null, Null, 0, N'SIMSCH', 40101);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1351', 1, 1, Null, N' K', N'Typ 1351 SW', Null, N'D', Null, Null, Null, 30, N'ARGASI', 70798);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1306', 0, 0, Null, N' K', N'PHZ für Fliethomatic', Null, Null, Null, Null, Null, 0, N'KRANZ', 30898);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'491N', 1, 2, Null, N'KK', Null, Null, N'D', Null, Null, Null, 0, N'SIMSCH', 81298);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1257', 3, 1, Null, N'K', N'Aufzugzylinder   LgA=Kern LgB=SW', Null, N'D', Null, Null, Null, 0, N'SIMSCH',
        71298);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1305', 3, 2, Null, N'KA', N'Zylinder für MZ98', Null, Null, Null, Null, Null, 0, N'SIMSCH', 71298);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M400', 0, 2, Null, N'KA', N'Zylinder 1305 (Motorzylinder)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        40399);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M401', 0, 2, Null, N'KA', N'Zylinder 1305 (Motorzylinder)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        40399);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M402', 0, 2, Null, N'KA', N'Zylinder 1305 (Motorzylinder)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        40399);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M403', 0, 2, Null, N'KA', N'Zylinder 1305 (Motorzylinder)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        40399);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'491A', 1, 2, Null, N'KK', Null, Null, N'D', Null, Null, Null, 0, N'SIMSCH', 81298);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2118', 2, 1, Null, N'K', N'HZ für Schiffschloss         WZ', Null, N'D', Null, Null, Null, 0, N'SIMSCH',
        80699);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1418', 1, 1, Null, N' K', N'Halbzylinder Siemens', Null, Null, Null, Null, Null, 0, N'WEHNERT', 70916);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1258', 1, 1, Null, N' K', N'Typ 1258SW', Null, N'D', Null, Null, Null, 30, N'ARGASI', 80799);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0510', 4, 2, Null, N'KK', N'Sonderzylinder Schwepper', N'N', N'N', N'N', N'N', N'N', 21021, N'SIMSCH', 60899);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1312', 3, 1, Null, N' K', N'HZ mit drehbarer Schliessnase', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        210206);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2119', 2, 1, Null, N' K', N'HZ m. 2 Bohrungen M4         WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        300300);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2112', 2, 1, Null, N' K', N'HZ m. frei drehb. SN         WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        300300);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1319', 3, 1, Null, N' K', N'HZ m. 2 Bohrungen M4', Null, Null, Null, Null, Null, 0, N'SIMSCH', 300300);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2120', 2, 1, Null, N' K', N'HZ m.Bohrungen f.Thyssen Auf.WZ', Null, Null, Null, Null, Null, 35, N'KRANZ',
        30400);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1320', 3, 1, Null, N' K', N'HZ m. Bohrungen f. Thyssen Aufz.', Null, Null, Null, Null, Null, 35, N'KRANZ',
        30400);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1333', 3, 1, Null, N' K', N'HZ f. ABUS VHS Vari 2000', Null, Null, Null, Null, Null, 0, N'SIMSCH', 300300);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1382', 3, 2, Null, N'AK', N'DZ eins.blind m. frei drehb. SN', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        300300);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2182', 2, 2, Null, N'AK', N'PDZ eins.blind m.drehb.SN    WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        300300);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1259', 3, 1, Null, N'K', N'Hebelzylinder Sonderausführung', Null, N'N', Null, Null, Null, 0, N'SIMSCH',
        300300);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1321', 3, 1, Null, N' K', N'HZ m. 2 Bohrungen M3', Null, Null, Null, Null, Null, 0, N'SIMSCH', 30400);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2121', 2, 1, Null, N' K', N'HZ m. 2 Bohrungen M3         WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        30400);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K463', 3, 2, Null, N'KK', N'SKG ** - Ausführung', Null, Null, Null, Null, Null, 0, N'WEHNERT', 190500);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K400', 3, 2, Null, N'KK', N'SKG ** - Ausführung', Null, Null, Null, Null, Null, 0, N'WEHNERT', 190500);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0515', 1, 1, Null, N' K', N'wie 0500', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 300506);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K405', 3, 2, Null, N'KA', N'SKG ** - Ausführung', Null, Null, Null, Null, Null, 0, N'WEHNERT', 190500);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K410', 3, 1, Null, N' K', N'SKG ** - Ausführung', Null, Null, Null, Null, Null, 0, N'WEHNERT', 190500);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0507', 3, 1, Null, N'K', N'wie 0500 Aufzugzylinder', N'N', N'N', Null, Null, Null, 0, N'SIMSCH', 170400);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1280', 3, 1, Null, N'K', N'Aufzugschaltzylinder', Null, Null, Null, Null, Null, 30, N'SIMSCH', 190613);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0530', 0, 0, Null, Null, N'Typ 0530 Knaufolive', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 80600);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'07-7', 1, 2, Null, N'KA', N'Knaufzyl. LgA=Kern LgB=Achse GSV', Null, Null, Null, Null, Null, 12070, N'SIMSCH',
        80201);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0519', 0, 1, Null, N' K', N'wie Typ 0546 für 1410', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 180501);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E401', 3, 2, Null, N'KK', N'PDZ  Elektronik m. Schutzkappe', Null, Null, N'D', Null, Null, 0, N'SIMSCH',
        160101);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E406', 3, 2, Null, N'KA', N'PDZ  Elektronik m.Knauf+Schutzk.', Null, Null, N'D', Null, Null, 0, N'SIMSCH',
        160101);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E411', 3, 1, Null, N' K', N'PHZ  Elektronik m. Schutzkappe', Null, Null, N'D', Null, Null, 0, N'SIMSCH',
        160101);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E464', 3, 2, Null, N'KK', N'PDZ  Elektronik m. Schutzkappe', Null, Null, N'D', Null, Null, 0, N'SIMSCH',
        160101);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0516', 0, 1, Null, N' K', N'wie Typ 0548 für 1410', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 180501);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1900', 3, 2, Null, N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 130801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1963', 3, 2, Null, N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 130801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1905', 3, 2, Null, N'KA', N'Modular Knaufzylinder', Null, Null, Null, Null, Null, 0, N'SIMSCH', 130801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1907', 3, 2, Null, N'KA', N'Modular Knaufzylinder', Null, Null, Null, Null, Null, 0, N'SIMSCH', 130801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1988', 3, 2, N'5', N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 200801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1910', 3, 1, Null, N' K', N'Modular Halbzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 130801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1913', 3, 1, Null, N' K', N'Modular Halbzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 130801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1981', 3, 2, N'5', N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 200801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1983', 3, 2, N'5', N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 200801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1984', 3, 2, N'5', N'KA', N'Modular Knaufzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 200801);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'S200', 1, 0, Null, Null, N'Schlüssel S200', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 250901);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'S210', 1, 0, Null, Null, N'Schlüssel S210', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 250901);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'S150', 1, 0, Null, Null, N'Schlüssel S150', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 250901);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'S220', 1, 0, Null, Null, N'Schlüssel S220', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 250901);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M500', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M501', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M502', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M503', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M504', 0, 2, Null, N'AA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, N'D', 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M505', 0, 2, Null, N'AA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, N'D', 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M506', 0, 2, Null, N'AA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, N'D', 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M507', 0, 2, Null, N'AA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, N'D', 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M508', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M509', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M510', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M511', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        180303);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1313', 3, 2, Null, N'KA', N'Zylinder für MZ02', Null, Null, Null, Null, Null, 0, N'SIMSCH', 260302);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3600', 3, 2, Null, N'KK', N'PDZ', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3605', 3, 1, Null, N'KA', N'Knaufzyl.', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'07-8', 1, 2, Null, N'KA', N'Knaufzyl. LgA=Kern LgB=Achse GSV', Null, Null, Null, Null, Null, 12090, N'SIMSCH',
        71102);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'8010', 1, 1, N'B', N' K', N'loser Kern', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 281106);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0695', 4, 1, Null, N' K', N'Typ 0695', Null, N'D', Null, Null, Null, 0, N'SIMSCH', 140203);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3663', 3, 2, Null, N'KK', N'PDZ N+G', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3610', 3, 1, N'B', N' K', N'PHZ', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3681', 3, 2, N'5', N'KK', N'PDZ 5-stiftig', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'A463', 3, 2, Null, N'KK', N'PDZ  VDS A', Null, Null, Null, Null, Null, 0, N'SIMSCH', 90403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'A405', 3, 2, Null, N'KA', N'PDZ  VDS A mit Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 90403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B463', 3, 2, Null, N'KK', N'PDZ  VDS B', Null, Null, Null, Null, Null, 0, N'SIMSCH', 90403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B405', 3, 2, Null, N'KA', N'PDZ  VDS B mit Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 90403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B423', 3, 2, Null, N'KK', N'PDZ  VDS B m. ABH IV u. N+G', Null, Null, Null, Null, Null, 0, N'SIMSCH', 90403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B424', 3, 2, Null, N'KK', N'PDZ  VDS B m. Knauf u. ABH IV', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        90403);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1304', 0, 2, Null, N'AA', N'Doppelknaufzylinder', Null, Null, N'D', Null, N'N', 0, N'SIMSCH', 190503);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1307', 0, 2, Null, N'AA', N'Doppelknaufzylinder', Null, Null, N'D', Null, N'N', 0, N'SIMSCH', 190503);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1380', 0, 2, Null, N'AA', N'DZ blind/Knauf', Null, Null, N'D', Null, N'N', 0, N'SIMSCH', 261108);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1416', 3, 1, Null, N' K', N'Halbzyl. f. Vieler Fensterbesch.', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        280708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0697', 1, 1, Null, N' K', N'Typ 0697 Möbelschl.Rundzylinder', Null, N'D', Null, Null, Null, 35, N'SIMSCH',
        170703);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E490', 3, 2, Null, N'KA', N'PDZ  EASY-Elektronikknaufzyl.', Null, Null, N'D', Null, Null, 0, N'SIMSCH',
        200803);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1386', 1, 1, Null, N' K', N'S&S Rundzylinder wie 0586', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 150803);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2711', 0, 0, Null, Null, N'Typ 2711 Riegelschloss für 1410', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH',
        100204);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1325', 3, 1, Null, N'KA', N'HZ mit Schließbolzen', Null, Null, Null, Null, Null, 0, N'SIMSCH', 180504);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'8135', 0, 0, Null, Null, N'Drehstangen', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 250804);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E500', 3, 2, Null, N'KK', N'PDZ  Elektronik', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E501', 3, 2, Null, N'KK', N'PDZ  Elektronik m. Schutzkappe', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E510', 3, 1, Null, N' K', N'PHZ  Elektronik', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E511', 3, 1, Null, N' K', N'PHZ  Elektronik m. Schutzkappe', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E563', 3, 2, Null, N'KK', N'PDZ  Elektronik', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E564', 3, 2, Null, N'KK', N'PDZ  Elektronik m. Schutzkappe', Null, Null, N'D', Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1308', 1, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 70405);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2101', 2, 1, Null, N' K', N'Vorhangschloss               WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        90206);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2201', 1, 1, Null, N' K', N'Vorhangschloss', Null, Null, Null, Null, Null, 30, N'SIMSCH', 90206);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1253', 1, 1, Null, N' K', N'Hebelzylinder (Renz)', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 291105);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2157', 1, 1, Null, N' K', N'Hebelzylinder (Renz)', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 301105);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'EM40', 0, 2, Null, N'KA', N'M500 m. e-Außenzyl. ohne Kappe', Null, Null, N'D', Null, Null, 0, N'WEHNERT',
        300608);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'EM50', 0, 2, Null, N'KA', N'M500 m. e-Außenzyl. mit Kappe', Null, Null, N'D', Null, Null, 0, N'WEHNERT',
        300608);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'EM63', 0, 2, Null, N'KA', N'e-Außenzyl. f. M500 ohne Kappe', Null, Null, N'D', Null, Null, 0, N'WEHNERT',
        300608);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'EM64', 0, 2, Null, N'KA', N'e-Außenzyl. f. M500 mit Kappe', Null, Null, N'D', Null, Null, 0, N'WEHNERT',
        300608);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0698', 4, 1, Null, N' K', N'Möbel Rundzyl. 0698 für IKON', Null, N'D', Null, Null, Null, 30, N'SIMSCH',
        280306);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'8044', 1, 1, N'B', N' K', N'loser Kern für Vorhangschloss', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        61108);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1475', 1, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 310107);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1417', 1, 1, Null, N' K', N'S&S PHZ', Null, Null, Null, Null, Null, 0, N'SIMSCH', 60307);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3601', 3, 1, Null, N' K', N'Vorhangschloss', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1264', 1, 1, Null, N' K', N'Aufzugzylinder wie 0586', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 190407);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E570', 3, 0, Null, Null, N'Software Hotel', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E571', 3, 0, Null, Null, N'Software Objekte', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E574', 3, 0, Null, Null, N'Codierstation r/w', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E665', 3, 0, Null, Null, N'Lesestation USB', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E804', 0, 0, Null, Null, N'Easy DK', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E891', 0, 0, Null, Null, N'Easy DK Schlüsselanhänger', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E894', 0, 0, Null, Null, N'Easy DK Nutzerkarte', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6091', 0, 0, Null, Null, N'Easy DK Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6092', 0, 0, Null, Null, N'Easy DK Schlüssel             NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E895', 0, 0, Null, Null, N'Easy DK Programmierkarte', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E310', 0, 0, Null, Null, N'Batterie Easy DK + eHome', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E850', 0, 0, Null, Null, N'Easy DK Software + Prog.einheit', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH',
        190707);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1355', 1, 1, Null, N' K', N'S&S Schaltzylinder', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 280807);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1331', 1, 1, Null, N' K', N'S&S VORHANGSCHLOß', Null, Null, Null, Null, Null, 30, N'WEHNERT', 81007);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1249', 3, 1, Null, N' K', N'Ovalzylinder Albers', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 51107);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E881', 0, 0, Null, Null, N'Easy DK Abdeckkappe Innenkn.Niro', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH',
        281107);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E831', 0, 0, Null, Null, N'E-Leser schmal (Mifare)', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 281107);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E832', 0, 0, Null, Null, N'E-Leser breit (Mifare)', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 281107);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E871', 0, 0, Null, Null, N'EASY DK Notöffnung', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 240108);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E764', 3, 0, Null, Null, N'Software SGS Compact', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 140208);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M520', 1, 0, Null, Null, N'Motorgetriebeeinheit MZ02', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 110308);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E808', 0, 0, Null, Null, N'Easy DK', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 210508);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E807', 0, 0, Null, Null, N'Easy DK', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 300508);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E813', 0, 0, Null, Null, N'Easy DK', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 300508);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E896', 0, 0, Null, Null, N'Transponderscheiben', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 300608);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3683', 3, 2, N'5', N'KK', N'PDZ 5-stiftig', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3688', 3, 2, N'5', N'KK', N'PDZ 5-stiftig', Null, Null, Null, Null, Null, 0, N'SIMSCH', 220710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3650', 3, 1, Null, N' K', N'Typ 1250 SW', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3651', 3, 1, Null, N' K', N'Typ 1251 SW', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1356', 1, 1, Null, N' K', N'S&S Schaltzylinder', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 220708);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1309', 3, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 210808);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E873', 3, 0, Null, Null, N'Easy DK Aussenknauf', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 80908);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3607', 3, 1, N'5', N'KA', N'Kurzknaufzylinder', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3657', 3, 1, Null, N' K', N'Rundzylinder Renz', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 220710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E855', 0, 0, Null, Null, N'Easy DK-Software', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 181108);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1268', 3, 1, Null, N' K', N'Schraubrundzylinder', Null, N'D', Null, Null, Null, 35, N'SIMSCH', 271108);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3684', 3, 2, N'5', N'KA', N'Asym. PZ m. Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3652', 3, 1, Null, N' K', N'wie 0500', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6093', 3, 0, Null, Null, N'E240 Mifare + Tiris', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH', 70109);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6094', 3, 0, Null, Null, N'E240 Mifare + Tiris           NB', N'N', N'N', N'N', Null, N'N', 0, N'SIMSCH',
        70109);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0511', 4, 2, Null, N'KA', N'Sonderzylinder Schwepper', N'N', N'N', N'N', N'N', N'N', 21021, N'WEHNERT',
        200109);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3612', 3, 1, N'B', N' K', N'PHZ drehb. Nase', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3619', 3, 1, N'A', N' K', N'PHZ mit 2 Gewindeb.', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1247', 3, 1, Null, N' K', N'Ovalzylinder', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 260309);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E851', 3, 0, Null, Null, N'Easy DK Programmiergerät', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 70509);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K360', 3, 2, Null, N'KK', N'3ve-SKG-Doppelzylinder', Null, Null, Null, Null, Null, 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K363', 3, 2, Null, N'KK', N'3ve-SKG-Doppelzylinder N+G', Null, Null, Null, Null, Null, 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K365', 3, 1, Null, N'KA', N'3ve-SKG-Knaufzylinder N+G', Null, Null, Null, Null, Null, 0, N'WEHNERT', 10909);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K361', 3, 1, Null, N' K', N'3ve-SKG-Halbzylinder N+G', Null, Null, Null, Null, Null, 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E950', 3, 0, Null, Null, N'e-Link Programmiersoftware', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E932', 3, 0, Null, Null, N'e-Link Leser breit', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E913', 3, 0, Null, Null, N'e-Link Kaufhalbzyl.', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E908', 3, 0, Null, Null, N'e-Link Doppelknauf AP', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E907', 3, 0, Null, Null, N'e-Link Doppelknauf beids.', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E904', 3, 0, Null, Null, N'e-Link Doppelknauf', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E931', 3, 0, Null, Null, N'e-link Leser schmal', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 130709);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3623', 3, 2, Null, N'KK', N'PDZ mit Schliesszwang', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'07-9', 1, 2, Null, N'KA', N'Knaufzyl. LgA=Kern LgB=Achse GSV', Null, Null, Null, Null, Null, 12080, N'SIMSCH',
        221209);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E892', 0, 0, Null, Null, N'Easy DK Schlüsselanh.verschraubt', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT',
        250110);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3680', 3, 1, N'L', N' K', N'PDZ aussen blind', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B300', 3, 2, Null, N'KK', N'PDZ  VDS B 3ve', Null, Null, Null, Null, Null, 0, N'SIMSCH', 10210);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3613', 1, 2, Null, N'KK', N'Außen- und Innenzyl. f. 2626', Null, Null, Null, Null, Null, 26030, N'WEHNERT',
        310512);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1408', 3, 2, Null, N'KK', N'PDZ N+G FZG-Ausf.', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1406', 3, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Knauf FZG-Ausf.', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2106', 2, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Knauf FZG   WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2108', 2, 2, Null, N'KK', N'PDZ N+G FZG-Ausf.            WZ', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3606', 3, 2, Null, N'KA', N'Knaufzyl. FZG-Ausf.', Null, Null, Null, Null, Null, 0, N'SIMSCH', 190710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3608', 3, 2, Null, N'KK', N'PDZ N+G FZG-Ausf.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 200111);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3695', 3, 1, Null, N' K', N'Möbelschloss Rundzyl. w.0692', Null, N'D', Null, Null, Null, 30, N'SIMSCH',
        220710);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3632', 3, 1, Null, N' K', N'wie 500F', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 91110);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3675', 1, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 21210);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3620', 3, 1, Null, N' K', N'Thyssen Aufzug HZ', Null, Null, Null, Null, Null, 35, N'SIMSCH', 70211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M550', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M551', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M552', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M553', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M554', 0, 2, Null, N'AA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, N'D', 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M555', 0, 2, Null, N'AA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, N'D', 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M556', 0, 2, Null, N'AA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, N'D', 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M557', 0, 2, Null, N'AA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, N'D', 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'M558', 0, 2, Null, N'KA', N'Zylinder 1313 (Motorzyl. MZ02)', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        90211);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E878', 3, 0, Null, Null, N'Easy DK Regenschutz (Plexiglas)', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH',
        40411);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E897', 0, 0, Null, Null, N'Reset-Karte', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 30511);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1365', 3, 2, Null, N'KA', N'PDZ LgA=Kern LgB=Achse S+S Sond.', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        30511);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E951', 3, 0, Null, Null, N'Easy DK Programmiergerät', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 250511);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1063', 3, 2, Null, N'KK', N'PRIMUS DOPPELZYLINDER', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1005', 3, 2, Null, N'KA', N'PRIMUS KNAUFZYLINDER', Null, Null, Null, Null, Null, 0, N'WEHNERT', 80811);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1010', 3, 1, Null, N' K', N'PRIMUS HALBZYLINDER VDS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240811);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1022', 3, 2, Null, N'KK', N'PRIMUS DOPPELZYLINDER VDS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240811);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1052', 1, 1, Null, N' K', N'PRIMUS RUNDZYLINDER', Null, Null, Null, Null, Null, 0, N'WEHNERT', 20913);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1081', 3, 2, Null, N'KK', N'PRIMUS DOPPELZYLINDER ASYM.', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        240811);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1083', 3, 2, Null, N'KK', N'PRIMUS DOPPELZYL. ASYM. NOT+GEF.', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        240811);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1084', 3, 1, Null, N'KA', N'PRIMUS KNAUFZYL. l. Asym.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240811);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1088', 3, 2, N'5', N'KK', N'PRIMUS KURZZYLINDER', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240811);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1001', 3, 0, Null, Null, N'PRIMUS VORHANGSCHLOSS', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3603', 1, 1, Null, N' K', N'Aussenzyl. für 2621', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 190911);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2536', 1, 1, Null, N' K', N'Innenzylinder für 2524', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 230112);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1358', 1, 1, Null, N' K', N'S&S Schaltzylinder', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 270112);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3660', 1, 1, Null, N' K', N'Kontaktzyl. f. Aufzüge', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3624', 1, 2, Null, N'KK', N'Außen + Innenzyl. für 2524', Null, N'D', Null, Null, Null, 28022, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B305', 3, 2, Null, N'KA', N'PDZ  VDS B 3ve mit Knauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 70312);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B363', 3, 2, Null, N'KK', N'PDZ  VDS B 3ve', Null, Null, Null, Null, Null, 0, N'SIMSCH', 70312);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B310', 3, 2, Null, N' K', N'PHZ  VDS B 3ve', Null, Null, N'D', Null, Null, 0, N'SIMSCH', 70312);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3010', 3, 1, N'B', N' K', N'PRIMUS HX HALBZYL. VDS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 60612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3022', 3, 2, Null, N'KK', N'PRIMUS HX DOPPELZYL. VDS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 220512);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3052', 3, 1, Null, N' K', N'PRIMUS HX RUNDZYL.', Null, Null, Null, Null, Null, 30, N'SIMSCH', 130619);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3063', 3, 2, Null, N'KK', N'PRIMUS HX DOPPELZYL.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 220512);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3081', 3, 2, N'5', N'KK', N'PRIMUS HX DOPPELZYL. ASYM.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 60612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3083', 3, 2, N'5', N'KK', N'PRIMUS HX DOPPELZYL. ASYM.N.', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        60612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3084', 3, 1, N'5', N'KA', N'PRIMUS HX KNAUFZYL.  ASYM.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 60612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3088', 3, 2, N'5', N'KK', N'PRIMUS HX KURZZYL.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 220512);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3008', 3, 2, Null, N'KK', N'PRIMUS HX FZG-ZYL.', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3006', 3, 1, Null, N'KA', N'PRIMUS HX FZG-KNAUFZYL.', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3007', 3, 1, Null, N'KA', N'PRIMUS HX KURZKNAUFZYL.', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3050', 3, 1, Null, N' K', N'PRIMUS HX HEBELZYL.', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3051', 3, 1, Null, N' K', N'PRIMUS HX HEBELRUNDZYL.', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1381', 1, 2, N'5', N'KK', N'S&S PDZ 5-stiftig wie 1481', Null, Null, Null, Null, Null, 0, N'SIMSCH', 220612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E820', 0, 0, Null, Null, N'Easy handle', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E920', 3, 0, Null, Null, N'e-Link handle', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1474', 3, 2, Null, N'KA', N'AP - Knaufzyl.', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2174', 2, 2, Null, N'KA', N'AP - Knaufzyl.', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3674', 3, 1, Null, N'KA', N'AP - Knaufzyl.', Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E809', 0, 0, Null, Null, N'Easy DK beids. AP', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E909', 0, 0, Null, Null, N'eLink - beidseit. AP', Null, N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E805', 0, 0, Null, N'AK', N'Easy DK AP +mech.Schl.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E905', 0, 0, Null, N'AK', N'eLink AP +mech. Schl.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E823', 0, 0, Null, Null, N'Easy handle Notadapter', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E824', 0, 0, Null, Null, N'Batterie Easy handle', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E814', 0, 0, Null, N'AA', N'Easy DK AP +mech. Knauf', Null, N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E914', 0, 0, Null, N'AA', N'eLink AP +mech. Knauf', Null, N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E815', 0, 0, Null, N'AA', N'Easy Dk AP +blind', Null, N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E915', 0, 0, Null, N'AA', N'eLink AP +blind', Null, N'N', N'N', N'N', N'N', 0, N'WEHNERT', 260612);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B308', 3, 2, Null, N'KK', N'DZ FZG VDS-B', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30516);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E825', 0, 0, Null, Null, N'Unterlegplatte Easy handle', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 90712);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'XXXX', 0, 0, Null, Null, Null, Null, Null, Null, Null, Null, 0, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'H400', 3, 2, Null, N'KK', N'VDS-Home Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 270812);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'H405', 3, 2, Null, N'KA', N'VDS-Home Knaufzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 270812);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'H410', 3, 1, N'B', N' K', N'VDS-Home Halbzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 270812);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'H463', 3, 2, Null, N'KK', N'VDS-Home Doppelzyl. N+G', Null, Null, Null, Null, Null, 0, N'WEHNERT', 270812);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E898', 0, 0, Null, Null, N'Transponder Schlüsselanhänger', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT',
        270812);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E890', 0, 0, Null, Null, N'Transponder Schlüsselkopf Tacky', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3692', 1, 1, Null, N' K', N'TYP 3692', Null, N'D', Null, Null, Null, 30, Null, 0);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'EK84', 0, 0, Null, Null, N'EasyDK SKG', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 70213);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'EK94', 3, 0, Null, Null, N'ELink SKG', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 70213);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1363', 1, 2, Null, N'KK', N'S&S DOPPELZYL. N+G', Null, Null, Null, Null, Null, 0, N'WEHNERT', 90413);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1006', 3, 2, Null, N'KA', N'PRIMUS KNAUFZYLINDER FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 90413);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1008', 3, 2, Null, N'KK', N'PRIMUS DOPPELZYLINDER FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 90413);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K406', 3, 2, Null, N'KA', N'SKG ** FZG Ausführung KNAUFZYL.', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        90413);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K408', 3, 2, Null, N'KK', N'SKG ** - Doppelzyl. FZG Ausführ.', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        90413);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E806', 0, 0, Null, Null, N'Esay DK innen mech.', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 110413);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E906', 0, 0, Null, Null, N'eLink Doppelzyl. innen mech.', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT',
        240413);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1326', 3, 1, N'B', N' K', N'PHZ', Null, Null, Null, Null, Null, 0, N'WEHNERT', 60613);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1359', 1, 1, Null, N' K', N'Hebelzyl. S+S', Null, N'D', Null, Null, Null, 3, N'WEHNERT', 50713);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1271', 1, 1, Null, N' K', N'Hebelzyl. Stadler', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 50713);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1272', 1, 1, Null, N' K', N'Hebelzyl. Stadler', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 50713);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E203', 0, 0, Null, Null, N'Easy 2.0 einseitig blind', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 140814);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1273', 1, 1, Null, N' K', N'Hebelzyl. Stadler', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 50713);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1274', 1, 1, Null, N' K', N'Hebelzyl. Stadler', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 50713);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1275', 1, 1, Null, N' K', N'Hebelzyl. Stadler', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 50713);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1276', 1, 1, Null, N' K', N'Kontaktzyl. Stadler', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 50713);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3616', 1, 2, Null, N'KK', N'Außen + Innenzyl. f. 2516', Null, N'D', Null, Null, Null, 28022, N'WEHNERT',
        120713);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D400', 3, 2, Null, N'KK', N'Doppelzyl. DIN', Null, Null, Null, Null, Null, 0, N'WEHNERT', 50813);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D405', 3, 2, Null, N'KA', N'Knaufzyl. DIN', Null, Null, Null, Null, Null, 0, N'WEHNERT', 50813);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D406', 3, 2, Null, N'KA', N'Knaufzyl. FZG DIN', Null, Null, Null, Null, Null, 0, N'WEHNERT', 50813);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D408', 3, 2, Null, N'KK', N'Doppelzyl. FZG DIN', Null, Null, Null, Null, Null, 0, N'WEHNERT', 50813);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D410', 3, 1, N'B', N' K', N'Halbzyl. DIN', Null, Null, Null, Null, Null, 0, N'WEHNERT', 50813);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D463', 3, 2, Null, N'KK', N'Doppelzyl. N+G DIN', Null, Null, Null, Null, Null, 0, N'WEHNERT', 50813);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1323', 3, 2, Null, N'KK', N'Doppelzyl. mit Schließzwang', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        141013);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3615', 3, 1, N'A', N' K', N'PHZ mit Freilauf', Null, Null, Null, Null, Null, 0, N'SIMSCH', 151014);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1372', 1, 1, Null, N' K', N'Hebelzylinder S+S', Null, N'D', N'D', Null, Null, 30, N'WEHNERT', 171013);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1281', 3, 1, Null, N'K', N'Thyssen Schaltzylinder', Null, Null, Null, Null, Null, 30, N'WEHNERT', 310114);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E921', 3, 0, Null, Null, N'eLinkHandle FH-Ausführung', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 270214);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E821', 0, 0, Null, Null, N'EasyHandle FH-Ausführung', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 270214);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3685', 3, 1, Null, N' K', N'wie 0500', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 130314);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1354', 1, 1, Null, N' K', N'S+S Schaltzylinder', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 130314);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E204', 0, 0, Null, Null, N'Easy 2.0', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 30414);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E205', 0, 0, Null, N'AK', N'Easy 2.0 AP mech. Seite', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30414);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E207', 0, 0, Null, Null, N'Easy 2.0 beidseitig', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 30414);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E209', 0, 0, Null, Null, N'Easy 2.0 AP beidseitig', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 30414);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E213', 0, 0, Null, Null, N'Easy 2.0 Halb', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 30414);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E214', 0, 0, Null, Null, N'Easy 2.0 AP', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 30414);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E215', 0, 0, Null, N'AA', N'Easy 2.0 AP blind', Null, N'N', N'N', N'N', N'N', 0, N'WEHNERT', 30414);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E233', 0, 0, Null, Null, N'Batterie easy 2.0', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 230514);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E234', 0, 0, Null, Null, N'Montagewerkzeug easy 2.0', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 230514);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E235', 0, 0, Null, Null, N'Anschlußkabel easy 2.0', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 230514);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G360', 3, 2, Null, N'KK', N'Doppelzyl. SKG***', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G365', 3, 1, Null, N'KA', N'Knaufzyl. SKG***', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G366', 3, 1, Null, N'KA', N'Knaufzyl. SKG*** FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G368', 3, 2, Null, N'KK', N'Doppelzyl. SKG*** FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G361', 3, 1, Null, N' K', N'Halbzyl. SKG***', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G363', 3, 2, Null, N'KK', N'Doppelzyl. SKG*** N+G', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G400', 3, 2, Null, N'KK', N'Doppelzyl. SKG***', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G405', 3, 2, Null, N'KA', N'Knaufzyl. SKG***', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G406', 3, 2, Null, N'KA', N'Knaufzyl. SKG*** FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G408', 3, 2, Null, N'KK', N'Doppelzyl. SKG*** FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G410', 3, 1, Null, N' K', N'Halbzyl. SKG***', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'G463', 3, 2, Null, N'KK', N'Doppelzyl. SKG*** N+G', Null, Null, Null, Null, Null, 0, N'WEHNERT', 30614);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1245', 3, 1, Null, N' K', N'Hebelzylinder (rund)', Null, N'D', Null, Null, Null, 30, N'SIMSCH', 61014);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B408', 3, 2, Null, N'KK', N'PDZ  VDS B FZG', Null, Null, Null, Null, Null, 0, N'SIMSCH', 71014);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E236', 0, 0, Null, Null, N'NFC Programmieradapter', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 71014);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1282', 3, 1, Null, N'K', N'IKON - Rundzylinder', Null, Null, Null, Null, Null, 30, N'WEHNERT', 241014);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E297', 0, 0, Null, Null, N'Dauerinf. Berechtigungskarte', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT',
        291014);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E295', 0, 0, Null, Null, N'Programmierkarte Easy 2.0', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 291014);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6095', 0, 0, Null, Null, N'Eingabe E-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'WEHNERT', 191114);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'6096', 0, 0, Null, Null, N'Eingabe E-Schlüssel', N'N', N'N', N'N', Null, N'N', 0, N'WEHNERT', 191114);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1315', 1, 2, Null, N'KA', N'Zylinder für MZ02 3ve', Null, Null, Null, Null, Null, 0, N'SIMSCH', 260816);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3694', 1, 1, Null, N' K', N'3ve Möbelzylinder rund', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 210115);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0508', 1, 1, Null, N' K', N'S+S Rundzylinder', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 180315);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E856', 3, 0, Null, Null, N'Easy Codierstation', N'N', N'N', N'N', N'N', N'N', 0, N'SIMSCH', 290615);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K260', 3, 2, Null, N'KK', N'Carat P2 SKG-Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 50815);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K263', 3, 2, Null, N'KK', N'Carat P2 SKG-Doppelzyl. N+G', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        120815);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'Q360', 3, 2, Null, N'KK', N'Doppelzyl. SKG*** Snatens BE', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        190815);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3629', 3, 1, N'A', N' K', N'3619 mit abgefrästem Stift', Null, Null, Null, Null, Null, 0, N'WEHNERT', 70915);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1329', 3, 1, Null, N' K', N'1319 mit abgefrästem Stift', Null, Null, Null, Null, Null, 0, N'WEHNERT', 70915);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3690', 3, 1, Null, N' K', N'Für ABUS Kastenschloß', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 230915);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2190', 2, 1, Null, N' K', N'Für ABUS Kastenschloß', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 230915);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0580', 1, 1, Null, N' K', N'Für ABUS Kastenschloß', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 230915);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3682', 3, 2, Null, N'AK', N'DZ eins.blind m. frei drehb. SN', Null, Null, Null, Null, Null, 0, N'SIMSCH',
        91115);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'07-3', 1, 2, Null, N'KA', N'Knaufzylinder', Null, Null, Null, Null, Null, 48012, N'WEHNERT', 261115);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'07-4', 1, 2, Null, N'KA', N'Knaufzylinder', Null, Null, Null, Null, Null, 95012, N'WEHNERT', 261115);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'Q363', 3, 2, Null, N'KK', N'Doppelzyl. SKG - Santens', Null, Null, Null, Null, Null, 0, N'WEHNERT', 20216);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B406', 3, 2, Null, N'KA', N'PDZ  VDS-B FZG-Knaufzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        170216);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E279', 0, 0, Null, Null, N'Easy Starterset', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 190216);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3656', 1, 2, Null, N'KK', N'Rundzyl. 3ve beids. für 2616', Null, N'D', Null, Null, Null, 28022, N'WEHNERT',
        40316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E826', 0, 0, Null, Null, N'Easy Doppel-Elektronikbeschlag', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT',
        100316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E926', 3, 0, Null, Null, N'e-Link Doppel-Elektronikbeschlag', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT',
        100316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'Q361', 3, 1, Null, N' K', N'P3-SKG Halbzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 100316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'Q365', 3, 1, Null, N'KA', N'P3- SKG Knaufzyl. Santens', Null, Null, Null, Null, Null, 0, N'WEHNERT', 100316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K261', 3, 1, Null, N' K', N'P2- SKG Halbzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 100316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K265', 3, 1, Null, N'KA', N'P2- SKG Knaufzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 100316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K266', 3, 1, Null, N'KA', N'P2-SKG Knaufzylinder FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 100316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K268', 3, 2, Null, N'KK', N'P2- SKG Doppelzylinder FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 100316);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'B306', 3, 2, Null, N'KA', N'3VE KNAUFZYL. FZG VDS-B', Null, Null, Null, Null, Null, 0, N'WEHNERT', 70616);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1252', 1, 1, Null, N' K', N'Kontaktzyl. Schindler', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 290816);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E852', 0, 0, Null, Null, N'Programmiersoftware Easy Ligth', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT',
        90616);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E206', 0, 1, Null, N'AK', N'Easy 2.0 mit mech. Schließseite', Null, Null, Null, Null, Null, 0, N'WEHNERT',
        261016);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1473', 1, 2, Null, N'KA', N'AP-Kanufzyl. Rutschkupp.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 281016);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3673', 1, 2, Null, N'KA', N'AP-Knaufzyl. Rutschkupp.', Null, Null, Null, Null, Null, 0, N'WEHNERT', 281016);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3687', 1, 1, Null, N' K', N'TYP 3687', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 11216);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E953', 0, 0, Null, Null, N'Gateway - Modul', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 20317);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E952', 3, 0, Null, Null, N'elink Lizenzerweiterung', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 210317);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E827', 0, 0, Null, Null, N'ext. Spannungsvers. easyhandle', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT',
        160517);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0529', 0, 1, Null, N' K', N'OLIVE', N'N', N'N', Null, Null, N'N', 30, N'WEHNERT', 200617);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0564', 1, 1, Null, N' K', N'Rundzylinder S&S', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 181017);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2102', 2, 1, Null, N' K', N'Zylindereinsatz VHS', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 191017);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2202', 1, 1, Null, N' K', N'Zylindereinsatz VHS', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 191017);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3602', 3, 1, Null, N' K', N'Zylindereinsatz VHS', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 191017);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E219', 0, 0, Null, Null, N'Easy 2.0 Halb M4', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 230118);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'K368', 3, 2, Null, N'KK', N'3VE-SKG - FZG', Null, Null, Null, Null, Null, 0, N'WEHNERT', 200218);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E280', 0, 0, Null, Null, N'easy Now - Paket', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 50418);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E281', 0, 0, Null, Null, N'easy Now - Paket', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 50418);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0509', 1, 1, Null, N' K', N'S+S Rundzyl.', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 80618);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1314', 3, 1, N'B', N' K', N'Halbzyl. mit Schließzwang', Null, Null, Null, Null, Null, 0, N'WEHNERT', 20718);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E201', 0, 0, Null, Null, N'Easy Classic', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 50718);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D310', 3, 2, Null, N' K', N'HZ Din 3VS/2VS', Null, Null, N'D', Null, Null, 0, N'WEHNERT', 230718);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D308', 3, 2, Null, N'KK', N'PZ FZG DIN 3VS/2VS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 230718);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D306', 3, 2, Null, N'KA', N'Knaufzyl. FZG Din 3VS/2VS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 230718);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D305', 3, 2, Null, N'KA', N'Knaufzyl. DIN 3VS/2VS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 230718);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D300', 3, 2, Null, N'KK', N'PZ DIN 3VS/2VS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 230718);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'D363', 3, 2, Null, N'KK', N'PZ N+G DIN 3VS/2VS', Null, Null, Null, Null, Null, 0, N'WEHNERT', 230718);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3686', 1, 1, Null, N' K', N'Typ 3686', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 240918);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2537', 1, 1, Null, N' K', N'Innenzyl.f.2534/2616/2626', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 171018);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1283', 1, 1, Null, N' K', Null, Null, N'D', Null, Null, Null, 30, N'WEHNERT', 130319);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E282', 0, 0, Null, Null, N'Demo Set Easy App', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 200319);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3900', 3, 2, Null, N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240619);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3905', 3, 2, Null, N'KA', N'Modular Knaufzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240619);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3963', 3, 2, Null, N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240619);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1906', 3, 2, Null, N'KA', N'Modular Knaufzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240619);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3906', 3, 2, Null, N'KA', N'Modular Knaufzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240619);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1908', 3, 2, Null, N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240619);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3908', 3, 2, Null, N'KK', N'Modular Doppelzylinder', Null, Null, Null, Null, Null, 0, N'WEHNERT', 240619);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1409', 3, 1, N'B', N' K', N'PHZ', Null, Null, Null, Null, Null, 0, N'WEHNERT', 131119);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E218', 0, 0, Null, Null, N'ESAY 2.0', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 140520);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'2553', 1, 1, Null, N' K', N'Innenzylinder', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 200520);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1465', 3, 3, Null, N'KK', N'PDZ', Null, Null, Null, Null, Null, 0, N'WEHNERT', 160620);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3604', 3, 1, Null, N' K', N'wie 0500', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 60720);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'0565', 1, 1, Null, N' K', N'TYPE 0565', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 20920);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'1278', 1, 1, Null, N' K', N'TYPE 0500', Null, N'D', Null, Null, Null, 30, N'WEHNERT', 100920);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E231', 3, 0, Null, Null, N'e-link Leser schmal', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 191020);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E250', 3, 0, Null, Null, N'e-Link Programmiersoftware', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 191020);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E251', 3, 0, Null, Null, N'Easy DK Programmiergerät', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 191020);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E252', 3, 0, Null, Null, N'elink Lizenzerweiterung', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 191020);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'3611', 3, 1, N'B', N' K', N'PHZ', Null, Null, Null, Null, Null, 0, N'WEHNERT', 101220);
insert into SlsData (PartNumber, S160ST, S160AN, S160AZ, S160KZ, S160BE, S16061, S16063, S16065, S16066, S16071, S160AB,
                     S160LB, S160DA)
values (N'E858', 0, 0, Null, Null, N'Easy DK Schlüsselanhänger', N'N', N'N', N'N', N'N', N'N', 0, N'WEHNERT', 290121);
Go