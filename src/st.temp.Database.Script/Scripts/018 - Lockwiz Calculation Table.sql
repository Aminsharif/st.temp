CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_CylinderEntries_KeyingSystemId_Locking
    ON CylinderEntries (KeyingSystemId, Locking)
    WHERE Locking IS NOT NULL;
go

create table LockwizProductionCalculations
(
    Id                           uniqueidentifier primary key not null,
    OrderId                      uniqueidentifier             not null foreign key references Orders,
    [Schliessungsnummer]         nvarchar(255)                not null,
    [IdNrdAusrechnung]           nvarchar(255),
    [SchliessungSchluessel]      nvarchar(255)                not null,
    [ProfilgruppeSchluessel]     nvarchar(255)                not null,
    [ErganzungSchluessel]        nvarchar(255)                not null,
    [Serie1bzwASchluessel]       nvarchar(255),
    [Serie2bzwBSchluessel]       nvarchar(255),
    [Serie3bzwCSchluessel]       nvarchar(255),
    [BohrungenFTaststSchluessel] nvarchar(255)                not null,
    [SchliessungKern]            nvarchar(255),
    [Aufbau1Kern]                nvarchar(255),
    [Aufbau2Kern]                nvarchar(255),
    [Aufbau3Kern]                nvarchar(255),
    [Aufbau4Kern]                nvarchar(255),
    [Aufbau5Kern]                nvarchar(255),
    [ProfilgruppeKern]           nvarchar(255),
    [ErgaenzungKern]             nvarchar(255),
    [Serie1bzwAKern]             nvarchar(255),
    [Serie2bzwBkern]             nvarchar(255),
    [Serie3bzwCKern]             nvarchar(255),
    [TaststifteKern]             nvarchar(255),
    [UpdatedAt]                  datetime2
)
GO

Create View Ausrechnung as
select ks.KeyingSystemNumber                  Anlagennummer,
       [Schliessungsnummer],
       isNull([IdNrdAusrechnung], 0)          IdNrdAusrechnung,
       SchliessungSchluessel,
       ProfilgruppeSchluessel,
       ErganzungSchluessel,
       Serie1bzwASchluessel,
       Serie2bzwBSchluessel,
       isNull(Serie3bzwCSchluessel, Space(5)) Serie3bzwCSchluessel,
       BohrungenFTaststSchluessel,
       isNull(SchliessungKern, Space(7))      SchliessungKern,
       isNull(Aufbau1Kern, Space(7))          Aufbau1Kern,
       isNull(Aufbau2Kern, Space(7))          Aufbau2Kern,
       isNull(Aufbau3Kern, Space(7))          Aufbau3Kern,
       isNull(Aufbau4Kern, Space(7))          Aufbau4Kern,
       isNull(ProfilgruppeKern, Space(6))     ProfilgruppeKern,
       isNull(ErgaenzungKern, Space(5))       ErgaenzungKern,
       isNull(Serie1bzwAKern, Space(5))       Serie1bzwAKern,
       isNull(Serie2bzwBKern, Space(5))       Serie2bzwBKern,
       isNull(Serie3bzwCKern, Space(5))       Serie3bzwCKern,
       isNull(TaststifteKern, Space(12))      TaststifteKern,
       kst.ProAlphaReference                  Anlagensystem,
       ksk.ProAlphaReference                  Anlagenart,
       calc.UpdatedAt
from LockwizProductionCalculations calc
         inner join Orders o on calc.OrderId = o.Id
         inner join KeyingSystems ks on ks.Id = o.KeyingSystemId
         inner join KeyingSystemTypes kst on kst.Id = ks.KeyingSystemTypeId
         left outer join KeyingSystemKinds ksk on ksk.Id = ks.KeyingSystemKindId
GO

create table LockwizKeyingSystemProfileConfigurations
(
    Id                            uniqueidentifier primary key not null,
    KeyingSystemTypeId            uniqueidentifier             not null foreign key references KeyingSystemTypes,
    KeyingSystemSpecificationName nvarchar(255)                not null unique,
    Configuration                 nvarchar(max)                not null
)

Go
Alter Table LockwizKeyingSystemProfileConfigurations
    add CONSTRAINT Constraint_Configuration_Is_Json Check (ISJSON(Configuration) = 1)
Go

-- Si6 GHS6
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D060',
        '08E53D25-D843-4F60-BB56-448E0C16D087',
        'Si6GHS6',
        '{
     "Series": [
         {
             "1": "A1",
             "2": "A2"             
         },
         {
             "3": "B1",
             "4": "B1"             
         },
        {
             "5": "C1",
             "6": "C2"             
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
         "18": "c1",
         "19": "c2",
         "20": "c3",
         "21": "b1",
         "22": "b2",
         "23": "b3",
         "24": "a1",
         "25": "a2"
     }
    }')

-- Si6 GHS5
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D061',
        '08E53D25-D843-4F60-BB56-448E0C16D087',
        'Si6GHS5',
        '{
     "Series": [
         {
             "1": "A1",
             "2": "A2"             
         },
         {
             "3": "B1",
             "4": "B2"             
         },
        {
             "5": "C1",
             "6": "C2"             
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
         "18": "c1",
         "19": "c2",
         "20": "c3",
         "21": "b1",
         "22": "b2",
         "23": "b3",
         "24": "a1",
         "25": "a2"
     }
    }')

-- Si6 Z
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D062',
        '08E53D25-D843-4F60-BB56-448E0C16D087',
        'Si6Z',
        '{
     "Series": [
         {             
             "1": "A2"           
         },
         {
             "2": "B1",
             "3": "B2"             
         },
        {
             "4": "C1",
             "5": "C2"             
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
         "17": "c1",
         "18": "c2",
         "19": "c3",
         "20": "b1",
         "21": "b2",
         "23": "b3",
         "24": "a1",
         "25": "a2"
     }
    }')

-- Si6 VDS GHS
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D063',
        '08E53D25-D843-4F60-BB56-448E0C16D087',
        'Si6VDSGHS',
        '{
     "Series": [
         {
             "1": "A1",
             "2": "A2"             
         },
         {
             "3": "B1",
             "4": "B1"             
         },
        {
             "5": "C1",
             "6": "C2"             
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
         "18": "c1",
         "19": "c2",
         "20": "c3",
         "21": "b1",
         "22": "b2",
         "23": "b3",
         "24": "a1",
         "25": "a2",
         "26": "d1",
         "27": "d2",
         "28": "d3"
     }
    }')

-- Si6 VDS Z
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D064',
        '08E53D25-D843-4F60-BB56-448E0C16D087',
        'Si6VDSZ',
        '{
     "Series": [
         {             
             "1": "A2"             
         },
         {
             "2": "B1",
             "3": "B2"             
         },
        {
             "4": "C1",
             "5": "C2"             
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
         "17": "c1",
         "18": "c2",
         "19": "c3",
         "20": "b1",
         "21": "b2",
         "23": "b3",
         "24": "a1",
         "25": "a2",
         "26": "d1",
         "27": "d2",
         "28": "d3"
     }
    }')

-- 2VS GHS6
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D070',
        '08E53D25-D843-4F60-BB56-448E0C16D088',
        '2VSGHS6',
        '{
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
         "13": "b2",
         "14": "b3",
         "15": "d2",
         "16": "d3",
         "17": "d4",
         "18": "c1",
         "19": "c2",
         "20": "c3",
         "21": "b1",
         "22": "d1",
         "23": "d1",
         "24": "d1"
     }
    }')

-- 2VSGHS5
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D071',
        '08E53D25-D843-4F60-BB56-448E0C16D088',
        '2VSGHS5',
        '{
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
         "13": "b2",
         "14": "b3",
         "15": "d2",
         "16": "d3",
         "17": "d4",
         "18": "c1",
         "19": "c2",
         "20": "c3",
         "21": "a1",
         "22": "a2"
     }
    }')

-- 2VS Z6
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D072',
        '08E53D25-D843-4F60-BB56-448E0C16D088',
        '2VSZ6',
        '{
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
         "11": "b2",
         "12": "b3",
         "13": "d2",
         "14": "d3",
         "15": "d4",
         "16": "c1",
         "17": "c2",
         "18": "c3",
         "19": "b1",
         "20": "d1",
         "21": "a1",
         "22": "a2"
     }
    }')

-- 2VS Z5
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D073',
        '08E53D25-D843-4F60-BB56-448E0C16D088',
        '2VSZ5',
        '{
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
         "11": "b2",
         "12": "b3",
         "13": "d2",
         "14": "d3",
         "15": "d4",
         "16": "c1",
         "17": "c2",
         "18": "c3",
         "19": "a1",
         "20": "a2"
     }
    }')

-- 2VS plus GHS
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D074',
        '08E53D25-D843-4F60-BB56-448E0C16D088',
        '2VSplusGHS',
        '{
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
         "13": "b2",
         "14": "b3",
         "15": "d2",
         "16": "d3",
         "17": "d4",
         "18": "c1",
         "19": "c2",
         "20": "c3",
         "21": "b1",
         "22": "d1",
         "23": "a1",
         "24": "a2"
     }
    }')

-- 2VS plus Z

insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D075',
        '08E53D25-D843-4F60-BB56-448E0C16D088',
        '2VSplusZ',
        '{
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
         "13": "b2",
         "14": "b3",
         "15": "d2",
         "16": "d3",
         "17": "d4",
         "18": "c1",
         "19": "c2",
         "20": "c3",
         "21": "b1",
         "22": "d1",
         "23": "a1",
         "24": "a2"
     }
    }')


-- 3veGHS5E4
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D080',
        '08E53D25-D843-4F60-BB56-448E0C16D084',
        '3veGHS5E4',
        '{
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
         "9": "a1",
         "10": "b2",
         "11": "b3",
         "12": "d2",
         "13": "d3",
         "14": "d4",
         "15": "c1",
         "16": "c2",
         "17": "c3"
     }
    }')

-- 3veGHS5E5
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D081',
        '08E53D25-D843-4F60-BB56-448E0C16D084',
        '3veGHS5E5',
        '{
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
         "9": "a1",
         "10": "b2",
         "11": "b3",
         "12": "d2",
         "13": "d3",
         "14": "d4",
         "15": "c1",
         "16": "c2",
         "17": "c3"
     }
    }')

-- 3veGHS6E6
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D082',
        '08E53D25-D843-4F60-BB56-448E0C16D084',
        '3veGHS6E6',
        '{
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
         "9": "a1",
         "10": "b2",
         "11": "b3",
         "12": "d2",
         "13": "d3",
         "14": "d4",
         "15": "c1",
         "16": "c2",
         "17": "c3",
         "18": "b1",
         "19": "d1"
     }
    }')

-- 3veZ5E4
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D083',
        '08E53D25-D843-4F60-BB56-448E0C16D084',
        '3veZ5E4',
        '{
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
         "9": "a2",
         "10": "b2",
         "11": "b3",
         "12": "d2",
         "13": "d3",
         "14": "d4",
         "15": "c1",
         "16": "c2",
         "17": "c3"
     }
    }')

-- 3veZ5E5
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D084',
        '08E53D25-D843-4F60-BB56-448E0C16D084',
        '3veZ5E5',
        '{
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
         "9": "a2",
         "10": "b2",
         "11": "b3",
         "12": "d2",
         "13": "d3",
         "14": "d4",
         "15": "c1",
         "16": "c2",
         "17": "c3"
     }
    }')

-- 3veZ6E6
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D085',
        '08E53D25-D843-4F60-BB56-448E0C16D084',
        '3veZ6E6',
        '{
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
         "9": "a2",
         "10": "b2",
         "11": "b3",
         "12": "d2",
         "13": "d3",
         "14": "d4",
         "15": "c1",
         "16": "c2",
         "17": "c3",
        "18": "b1",
        "19": "d1"
     }
    }')


--3veplusGHS
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D086',
        '08E53D25-D843-4F60-BB56-448E0C16D084',
        '3veplusGHS',
        '{
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
        "11": "a1",
        "12": "b2",
        "13": "b3",
        "14": "d2",
        "15": "d3",
        "16": "d4",
        "17": "c1",
        "18": "c2",
        "19": "c3",
        "20": "b1",
        "21": "d1"
     }
    }')

-- 3veCarat10000
-- Zu klären

-- 3ve SKG GHS
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D087',
        '08E53D25-D843-4F60-BB56-448E0C16D084',
        '3veSKGGHS',
        '{
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
        "11": "b1",
        "12": "b2",
        "13": "b3",
        "14": "a1",
        "15": "a2",
        "16": "d3",
        "17": "d4",
        "18": "c1",
        "19": "c2",
        "20": ""
     }
    }')
GO