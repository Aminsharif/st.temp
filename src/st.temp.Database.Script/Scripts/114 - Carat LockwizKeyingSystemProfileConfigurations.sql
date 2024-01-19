insert into KeyingSystemTypes(Id, ProAlphaReferenceForCylinders, Caption, SequenceName,
                              ProAlphaReferenceForSuperordinateKeys, CardCaption, IsLegacy, IsCarat)
values ('08E53D25-D843-4F60-BB56-448E0C16D0A0',
        N'S5-Profil(SKG)',
        N'S5-Profil(SKG)',
        N'Carat_S5',
        N'S5-Profil(SKG)',
        N'CARAT S5',
        0,
        1)
Go

-- 2veCarat
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D000',
        '08e53d25-d843-4f60-bb56-448e0c16d099',
        '2veCarat',
        '{
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
      "5": "a2",
      "6": "b2",
      "7": "b3",
      "8": "d2",
      "9": "d3",
      "10": "d4",
      "11": "c1",
      "12": "c2",
      "13": "c3"      
    }
   }')

-- 2veCSKC
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D001',
        '08e53d25-d843-4f60-bb56-448e0c16d09b',
        '2veCSKC',
        '{
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
      "5": "a2",
      "6": "b2",
      "7": "b3",
      "8": "d2",
      "9": "d3",
      "10": "d4",
      "11": "c1",
      "12": "c2",
      "13": "b1",
      "14": "d1"
    }
  }')

-- S1Carat
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D002',
        '08e53d25-d843-4f60-bb56-448e0c16d092',
        'S1 Carat',
        '{
    "Series": [
      {
        "1": "A1"
      },
      {
        "2": "B1"
      },
      {
        "3": "C1"
      }
    ],
    "Group": {
      "4": "1"
    },
    "Complement": {
      "5": "1"
    },
    "Stylus": {
      "6": "c1",
      "7": "c2",
      "8": "c3",
      "9": "b1",
      "10": "b2",
      "11": "b3",
      "12": "a1"      
    }
  }')

-- S4Carat
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D003',
        '08e53d25-d843-4f60-bb56-448e0c16d094',
        'S4Carat',
        '{
    "Series": [
      {
        "1": "A1"
      },
      {
        "2": "B1"
      },
      {
        "3": "C1"
      }
    ],
    "Group": {
      "4": "1"
    },
    "Complement": {
      "5": "1"
    },
    "Stylus": {
      "6": "c1",
      "7": "c2",
      "8": "c3",
      "9": "b1",
      "10": "b2",
      "11": "b3",
      "12": "a1"      
    }
  }')

-- S5Carat
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D004',
        '08e53d25-d843-4f60-bb56-448e0c16d095',
        'S5Carat',
        '{
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
      "6": "b2",
      "7": "b3",
      "8": "d2",
      "9": "d3",
      "10": "d4",
      "11": "c1",
      "12": "c2",      
      "13": "c3",      
      "14": "a1"      
    }
  }')

-- S5 CSKG 
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D005',
        '08E53D25-D843-4F60-BB56-448E0C16D0A0',
        'S5 CSKG',
        '{
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
      "6": "b2",
      "7": "b3",
      "8": "d2",
      "9": "d3",
      "10": "d4",
      "11": "c1",
      "12": "c2",      
      "13": "c3",      
      "14": "b1",      
      "15": "d1",      
      "16": "a1"      
    }
  }')

-- TH6Carat
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D007',
        '08e53d25-d843-4f60-bb56-448e0c16d098',
        'TH6Carat',
        '{
    "Series": [
      {
        "1": "A2"
      },
      {
        "2": "B1"
      },
      {
        "3": "C1"
      }       
    ],
    "Group": {
      "4": "1"
    },
    "Complement": {
      "5": "Z1"
    },
    "Stylus": {
      "6": "c1",
      "7": "c2",
      "8": "c3",
      "9": "b1",
      "10": "b2",
      "11": "b3"
    }
  }')

-- 3veCarat
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D008',
        '08e53d25-d843-4f60-bb56-448e0c16d09a',
        '3veCarat',
        '{
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
      "5": "d2",
      "6": "d3",
      "7": "d4",
      "8": "c1",
      "9": "c2",
      "10": "c3"
    }
  }')

-- 3veCSKG 
insert into LockwizKeyingSystemProfileConfigurations (Id, KeyingSystemTypeId, KeyingSystemSpecificationName, Configuration)
VALUES ('28E53D25-D843-4F60-BB56-448E0C16D009',
        '08e53d25-d843-4f60-bb56-448e0c16d09c',
        '3veCSKG',
        '{
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
      "5": "b2",
      "6": "b3",
      "7": "a1",
      "8": "a2",
      "9": "d3",
      "10": "d4"
    }
  }')

GO

Update LockwizKeyingSystemProfileConfigurations
set KeyingSystemSpecificationName = 'S3Carat'
where Id = '18E53D25-D843-4F60-BB56-448E0C16D0A0'

Update LockwizKeyingSystemProfileConfigurations
set KeyingSystemSpecificationName = 'S3CSKG'
where Id = '18E53D25-D843-4F60-BB56-448E0C16D0A1'




