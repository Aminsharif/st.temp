ALTER View vwAusrechnung as
    select l.LockwizName                             KeyingSystemName,
           ks.KeyingSystemNumber                     Anlagennummer,
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
           kskm.LockwizName                          AnlagenartLockwiz,
           kst.IsCarat                               IstCarat,
           o.CustomerIdProAlpha                      Kundennummer,
           calc.UpdatedAt
    from LockwizProductionCalculations calc
             inner join Orders o on calc.OrderId = o.Id
             inner join KeyingSystems ks on ks.Id = o.KeyingSystemId
             inner join KeyingSystemTypes kst on kst.Id = ks.KeyingSystemTypeId
             left outer join KeyingSystemKinds ksk on ksk.Id = ks.KeyingSystemKindId
             left outer join Lockwiz.KeyingSystemKindMappings l
                             on ks.KeyingSystemKindId = l.KeyingSystemKindId and
                                ks.KeyingSystemTypeId = l.KeyingSystemTypeId
             left outer join Lockwiz.KeyingSystemKindMappings kskm
                             on ks.KeyingSystemTypeId = kskm.KeyingSystemTypeId and
                                ks.KeyingSystemTypeId = kskm.KeyingSystemTypeId
Go

Delete
from LockwizKeyingSystemProfileConfigurations
Go

INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d000', N'08e53d25-d843-4f60-bb56-448e0c16d099', N'2veCarat', N'{
"Series": [
{
"1": "A"
},
{
"2": "1"
}
],
"Group": {
"3": "3"
},
"Complement": {
"4": "4"
},
"Stylus": {
"5": "a 2",
"6": "b 2",
"7": "b 3",
"8": "d 2",
"9": "d 3",
"10": "d 4",
"11": "c 1",
"12": "c 2",
"13": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d001', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2veCSKC', N'{
"Series": [
{
"1": "A"
},
{
"2": "1"
}
],
"Group": {
"3": "3"
},
"Complement": {
"4": "4"
},
"Stylus": {
"5": "a 2",
"6": "b 2",
"7": "b 3",
"8": "d 2",
"9": "d 3",
"10": "d 4",
"11": "c 1",
"12": "c 2",
"13": "b 1",
"14": "d 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d002', N'08e53d25-d843-4f60-bb56-448e0c16d092', N'S1 Carat', N'{
"Series": [
{
"1": "A 1"
},
{
"2": "B 1"
},
{
"3": "C 1"
}
],
"Group": {
"4": "1"
},
"Complement": {
"5": "1"
},
"Stylus": {
"6": "c 1",
"7": "c 2",
"8": "c 3",
"9": "b 1",
"10": "b 2",
"11": "b 3",
"12": "a 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d003', N'08e53d25-d843-4f60-bb56-448e0c16d094', N'S4Carat', N'{
"Series": [
{
"1": "A 1"
},
{
"2": "B 1"
},
{
"3": "C 1"
}
],
"Group": {
"4": "1"
},
"Complement": {
"5": "1"
},
"Stylus": {
"6": "c 1",
"7": "c 2",
"8": "c 3",
"9": "b 1",
"10": "b 2",
"11": "b 3",
"12": "a 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d004', N'08e53d25-d843-4f60-bb56-448e0c16d095', N'S5Carat', N'{
"Series": [
{
"1": "A"
},
{
"2": "1"
},
{
"3": "1"
}
],
"Group": {
"4": "3"
},
"Complement": {
"5": "1"
},
"Stylus": {
"6": "b 2",
"7": "b 3",
"8": "d 2",
"9": "d 3",
"10": "d 4",
"11": "c 1",
"12": "c 2",
"13": "c 3",
"14": "a 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d005', N'08e53d25-d843-4f60-bb56-448e0c16d0a0', N'S5 CSKG', N'{
"Series": [
{
"1": "A"
},
{
"2": "1"
},
{
"3": "1"
}
],
"Group": {
"4": "3"
},
"Complement": {
"5": "1"
},
"Stylus": {
"6": "b 2",
"7": "b 3",
"8": "d 2",
"9": "d 3",
"10": "d 4",
"11": "c 1",
"12": "c 2",
"13": "c 3",
"14": "b 1",
"15": "d 1",
"16": "a 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d007', N'08e53d25-d843-4f60-bb56-448e0c16d098', N'TH6Carat', N'{
"Series": [
{
"1": "A 2"
},
{
"2": "B 1"
},
{
"3": "C 1"
}
],
"Group": {
"4": "1"
},
"Complement": {
"5": "Z1"
},
"Stylus": {
"6": "c 1",
"7": "c 2",
"8": "c 3",
"9": "b 1",
"10": "b 2",
"11": "b 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d008', N'08e53d25-d843-4f60-bb56-448e0c16d09a', N'3veCarat', N'{
"Series": [
{
"1": "A"
},
{
"2": "3"
}
],
"Group": {
"3": "2"
},
"Complement": {
"4": "4"
},
"Stylus": {
"5": "d 2",
"6": "d 3",
"7": "d 4",
"8": "c 1",
"9": "c 2",
"10": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'28e53d25-d843-4f60-bb56-448e0c16d009', N'08e53d25-d843-4f60-bb56-448e0c16d09c', N'3veCSKG', N'{
"Series": [
{
"1": "A"
},
{
"2": "2"
}
],
"Group": {
"3": "1"
},
"Complement": {
"4": "4"
},
"Stylus": {
"5": "b 2",
"6": "b 3",
"7": "a 1",
"8": "a 2",
"9": "d 3",
"10": "d 4"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d060', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6GHS6', N'{
"Series": [
{
"1": "A 1",
"2": "A 2"
},
{
"3": "B 1",
"4": "B 1"
},
{
"5": "C 1",
"6": "C 2"
}
],
"Group": {
"7": "1",
"8": "2",
"9": "3",
"10": "4",
"11": "5",
"12": "6"
},
"Complement": {
"13": "1",
"14": "2",
"15": "3",
"16": "4",
"17": "5"
},
"Stylus": {
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "b 2",
"23": "b 3",
"24": "a 1",
"25": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d061', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6GHS5', N'{
"Series": [
{
"1": "A 1",
"2": "A 2"
},
{
"3": "B 1",
"4": "B 2"
},
{
"5": "C 1",
"6": "C 2"
}
],
"Group": {
"7": "1",
"8": "2",
"9": "3",
"10": "4",
"11": "5",
"12": "6"
},
"Complement": {
"13": "1",
"14": "2",
"15": "3",
"16": "4",
"17": "5"
},
"Stylus": {
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "b 2",
"23": "b 3",
"24": "a 1",
"25": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d062', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6Z', N'{
"Series": [
{
"1": "A 2"
},
{
"2": "B 1",
"3": "B 2"
},
{
"4": "C 1",
"5": "C 2"
}
],
"Group": {
"6": "1",
"7": "2",
"8": "3",
"9": "4",
"10": "5",
"11": "6"
},
"Complement": {
"12": "1",
"13": "2",
"14": "3",
"15": "4",
"16": "5"
},
"Stylus": {
"17": "c 1",
"18": "c 2",
"19": "c 3",
"20": "b 1",
"21": "b 2",
"22": "b 3",
"23": "a 1",
"24": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d063', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6VDSGHS', N'{
"Series": [
{
"1": "A 1",
"2": "A 2"
},
{
"3": "B 1",
"4": "B 1"
},
{
"5": "C 1",
"6": "C 2"
}
],
"Group": {
"7": "1",
"8": "2",
"9": "3",
"10": "4",
"11": "5",
"12": "6"
},
"Complement": {
"13": "1",
"14": "2",
"15": "3",
"16": "4",
"17": "5"
},
"Stylus": {
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "b 2",
"23": "b 3",
"24": "a 1",
"25": "a 2",
"26": "d 1",
"27": "d 2",
"28": "d 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d064', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6VDSZ', N'{
"Series": [
{
"1": "A 2"
},
{
"2": "B 1",
"3": "B 2"
},
{
"4": "C 1",
"5": "C 2"
}
],
"Group": {
"6": "1",
"7": "2",
"8": "3",
"9": "4",
"10": "5",
"11": "6"
},
"Complement": {
"12":"1",
"13": "2",
"14": "3",
"15": "4",
"16": "5"
},
"Stylus": {
"17": "c 1",
"18": "c 2",
"19": "c 3",
"20": "b 1",
"21": "b 2",
"23": "b 3",
"24": "a 1",
"25": "a 2",
"26": "d 1",
"27": "d 2",
"28": "d 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d070', N'08e53d25-d843-4f60-bb56-448e0c16d088', N'2VSGHS6', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "2"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 2",
"14": "b 3",
"15": "d 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "d 1",
"23": "d 1",
"24": "d 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d071', N'08e53d25-d843-4f60-bb56-448e0c16d088', N'2VSGHS5', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "3"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 2",
"14": "b 3",
"15": "d 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "a 1",
"22": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d072', N'08e53d25-d843-4f60-bb56-448e0c16d088', N'2VSZ6', N'{
"Series": [
{
"1": "A"
},
{
"2": "1",
"3": "2",
"4": "3"
},
{
"5": "1",
"6": "2"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "1",
"9": "2",
"10": "3"
},
"Stylus": {
"11": "b 2",
"12": "b 3",
"13": "d 2",
"14": "d 3",
"15": "d 4",
"16": "c 1",
"17": "c 2",
"18": "c 3",
"19": "b 1",
"20": "d 1",
"21": "a 1",
"22": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d073', N'08e53d25-d843-4f60-bb56-448e0c16d088', N'2VSZ5', N'{
"Series": [
{
"1": "B"
},
{
"2": "1",
"3": "2",
"4": "3"
},
{
"5": "1",
"6": "2"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "1",
"9": "2",
"10": "3"
},
"Stylus": {
"11": "b 2",
"12": "b 3",
"13": "d 2",
"14": "d 3",
"15": "d 4",
"16": "c 1",
"17": "c 2",
"18": "c 3",
"19": "a 1",
"20": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d074', N'08e53d25-d843-4f60-bb56-448e0c16d088', N'2VSplusGHS', N'{
"Series": [
{
"1": "A",
"1": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "1"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 2",
"14": "b 3",
"15": "d 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "d 1",
"23": "a 1",
"24": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d075', N'08e53d25-d843-4f60-bb56-448e0c16d088', N'2VSplusZ', N'{
"Series": [
{
"1": "A",
"1": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "2"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 2",
"14": "b 3",
"15": "d 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "d 1",
"23": "a 1",
"24": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d080', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veGHS5E4', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "4"
},
"Stylus": {
"9": "a 1",
"10": "b 2",
"11": "b 3",
"12": "d 2",
"13": "d 3",
"14": "d 4",
"15": "c 1",
"16": "c 2",
"17": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d081', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veGHS5E5', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "5"
},
"Stylus": {
"9": "a 1",
"10": "b 2",
"11": "b 3",
"12": "d 2",
"13": "d 3",
"14": "d 4",
"15": "c 1",
"16": "c 2",
"17": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d082', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veGHS6E6', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "6"
},
"Stylus": {
"9": "a 1",
"10": "b 2",
"11": "b 3",
"12": "d 2",
"13": "d 3",
"14": "d 4",
"15": "c 1",
"16": "c 2",
"17": "c 3",
"18": "b 1",
"19": "d 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d083', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veZ5E4', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "4"
},
"Stylus": {
"9": "a 2",
"10": "b 2",
"11": "b 3",
"12": "d 2",
"13": "d 3",
"14": "d 4",
"15": "c 1",
"16": "c 2",
"17": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d084', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veZ5E5', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "5"
},
"Stylus": {
"9": "a 2",
"10": "b 2",
"11": "b 3",
"12": "d 2",
"13": "d 3",
"14": "d 4",
"15": "c 1",
"16": "c 2",
"17": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d085', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veZ6E6', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "6"
},
"Stylus": {
"9": "a 2",
"10": "b 2",
"11": "b 3",
"12": "d 2",
"13": "d 3",
"14": "d 4",
"15": "c 1",
"16": "c 2",
"17": "c 3",
"18": "b 1",
"19": "d 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d086', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veplusGHS', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "4",
"9": "5",
"10": "6"
},
"Stylus": {
"11": "a 1",
"12": "b 2",
"13": "b 3",
"14": "d 2",
"15": "d 3",
"16": "d 4",
"17": "c 1",
"18": "c 2",
"19": "c 3",
"20": "b 1",
"21": "d 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d087', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veSKGGHS', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "3"
},
"Complement": {
"8": "4",
"9": "5",
"10": "6"
},
"Stylus": {
"11": "b 1",
"12": "b 2",
"13": "b 3",
"14": "a 1",
"15": "a 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": ""
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d090', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSGHS6', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "1"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 2",
"14": "b 3",
"15": "d 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "d 1",
"23": "a 1",
"24": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d091', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSGHS5', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "2"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 2",
"14": "b 3",
"15": "d 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "a 1",
"22": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d092', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSZ', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1"
}
],
"Group": {
"8": "3"
},
"Complement": {
"9": "1",
"10": "2",
"11": "3"
},
"Stylus": {
"12": "b 2",
"13": "b 3",
"14": "d 2",
"15": "d 3",
"16": "d 4",
"17": "c 1",
"18": "c 2",
"19": "c 3",
"20": "a 1",
"21": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d093', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSplusGHS', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "1"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 2",
"14": "b 3",
"15": "d 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "d 1",
"23": "a 1",
"24": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d094', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSplusZ', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "2"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 2",
"14": "b 3",
"15": "d 2",
"16": "d 3",
"17": "d 4",
"18": "c 1",
"19": "c 2",
"20": "c 3",
"21": "b 1",
"22": "d 1",
"23": "a 1",
"24": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d095', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSVDSGHS', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "1"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 1",
"14": "b 2",
"15": "b 3",
"16": "a 2",
"17": "d 1",
"18": "d 2",
"19": "d 3",
"20": "d 4",
"21": "c 1",
"22": "c 2",
"23": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d096', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSVDSZ', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
},
{
"7": "1",
"8": "2"
}
],
"Group": {
"9": "2"
},
"Complement": {
"10": "1",
"11": "2",
"12": "3"
},
"Stylus": {
"13": "b 1",
"14": "b 2",
"15": "b 3",
"16": "a 2",
"17": "d 1",
"18": "d 2",
"19": "d 3",
"20": "d 4",
"21": "c 1",
"22": "c 2",
"23": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a0', N'08e53d25-d843-4f60-bb56-448e0c16d093', N'S3Carat', N'{
"Series": [
{
"1": "A"
},
{
"2": "1"
},
{
"3": "1"
}
],
"Group": {
"4": "3"
},
"Complement": {
"5": "1"
},
"Stylus": {
"6": "b 2",
"7": "b 3",
"8": "d 2",
"9": "d 3",
"10": "d 4",
"11": "c 1",
"12": "c 2",
"13": "c 3",
"14": "a 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a1', N'08e53d25-d843-4f60-bb56-448e0c16d093', N'S3CSKG', N'{
"Series": [
{
"1": "A"
},
{
"2": "1"
},
{
"3": "1"
}
],
"Group": {
"4": "3"
},
"Complement": {
"5": "1"
},
"Stylus": {
"6": "b 2",
"7": "b 3",
"8": "d 2",
"9": "d 3",
"10": "d 4",
"11": "c 1",
"12": "c 2",
"13": "c 3",
"14": "b 1",
"15": "d 1",
"16": "a 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a2', N'08e53d25-d843-4f60-bb56-448e0c16d086', N'Thales6GHS5', N'{
"Series": [
{
"1": "A 1",
"2": "A 2"
},
{
"3": "B 1",
"4": "B 2"
},
{
"5": "C 1"
}
],
"Group": {
"6": "1",
"7": "2",
"8": "3",
"9": "4",
"10": "5"
},
"Complement": {
"11": "1",
"12": "2",
"13": "3",
"14": "4",
"15": "5"
},
"Stylus": {
"16": "b 1",
"17": "b 2",
"18": "b 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a3', N'08e53d25-d843-4f60-bb56-448e0c16d086', N'Thales6GHS6', N'{
"Series": [
{
"1": "A 1",
"2": "A 2"
},
{
"3": "B 1",
"4": "B 2"
},
{
"5": "C 2"
}
],
"Group": {
"6": "1",
"7": "2",
"8": "3",
"9": "4",
"10": "5"
},
"Complement": {
"11": "1",
"12": "2",
"13": "3",
"14": "4",
"15": "5"
},
"Stylus": {
"16": "b 1",
"17": "b 2",
"18": "b 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a4', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veGHS5', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "1"
},
"Complement": {
"8": "4",
"9": "5",
"10": "6"
},
"Stylus": {
"11": "b 2",
"12": "b 3",
"13": "d 2",
"14": "d 3",
"15": "d 4",
"16": "c 1",
"17": "c 2",
"18": "c 3",
"19": "a 1",
"20": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a5', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veGHS6', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "2"
},
"Complement": {
"8": "4",
"9": "5",
"10": "6"
},
"Stylus": {
"11": "b 2",
"12": "b 3",
"13": "d 2",
"14": "d 3",
"15": "d 4",
"16": "c 1",
"17": "c 2",
"18": "c 3",
"19": "b 1",
"20": "d 1",
"21": "a 1",
"22": "a 2"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a6', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veZ5', N'{
"Series": [
{
"1": "A"
},
{
"2": "1",
"3": "2",
"4": "3"
}
],
"Group": {
"5": "3"
},
"Complement": {
"6": "4",
"7": "5",
"8": "6"
},
"Stylus": {
"9": "a 1",
"10": "b 2",
"11": "b 3",
"12": "d 2",
"13": "d 3",
"14": "d 4",
"15": "c 1",
"16": "c 2",
"17": "c 3"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a7', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veZ6', N'{
"Series": [
{
"1": "B"
},
{
"2": "1",
"3": "2",
"4": "3"
}
],
"Group": {
"5": "3"
},
"Complement": {
"6": "4",
"7": "5",
"8": "6"
},
"Stylus": {
"9": "a 1",
"10": "b 2",
"11": "b 3",
"12": "d 2",
"13": "d 3",
"14": "d 4",
"15": "c 1",
"16": "c 2",
"17": "c 3",
"18": "b 1",
"19": "d 1"
}
}');
INSERT INTO LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES (N'18e53d25-d843-4f60-bb56-448e0c16d0a8', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veplusZ', N'{
"Series": [
{
"1": "A",
"2": "B",
"3": "C"
},
{
"4": "1",
"5": "2",
"6": "3"
}
],
"Group": {
"7": "3"
},
"Complement": {
"8": "4",
"9": "5",
"10": "6"
},
"Stylus": {
"11": "b 2",
"12": "b 3",
"13": "d 2",
"14": "d 3",
"15": "d 4",
"16": "c 1",
"17": "c 2",
"18": "c 3",
"19": "b 1",
"20": "d 1",
"21": "a 1"
}
}');
GO