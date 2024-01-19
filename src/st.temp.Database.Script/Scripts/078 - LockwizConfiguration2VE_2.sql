-- 2veZ5
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D0A6',
        '08E53D25-D843-4F60-BB56-448E0C16D082',
        '2veZ5',
        '{
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

-- 2veZ6
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D0A7',
        '08E53D25-D843-4F60-BB56-448E0C16D082',
        '2veZ6',
        '{
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

-- 2veplusZ
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('18E53D25-D843-4F60-BB56-448E0C16D0A8',
        '08E53D25-D843-4F60-BB56-448E0C16D082',
        '2veplusZ',
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
      "21": "a1"
    }
  }')

-- Fix wrong type Id
GO
Update LockwizKeyingSystemProfileConfigurations
set KeyingSystemTypeId = '08E53D25-D843-4F60-BB56-448E0C16D082'
where Id in ('18E53D25-D843-4F60-BB56-448E0C16D0A5', '18E53D25-D843-4F60-BB56-448E0C16D0A4')

Go

