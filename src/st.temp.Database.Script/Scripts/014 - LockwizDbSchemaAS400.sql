CREATE SCHEMA Lockwiz
GO

CREATE TABLE Lockwiz.CountryCodeMappings (
	LockwizCountryCode NVARCHAR(255) NOT NULL UNIQUE
	,AsmCountryCode NVARCHAR(255) NOT NULL UNIQUE
	)
GO

Insert into Lockwiz.CountryCodeMappings (LockwizCountryCode, AsmCountryCode)
Values ('D', 'DE'),
       ('A', 'AT'),
       ('AE', 'AE'),
       ('BE', 'BE'),
       ('CH', 'CH'),
       ('ES', 'ES'),     
       ('FR', 'FR'),
       ('GB', 'GB'),
       ('GR', 'GR'),       
       ('HR', 'HR'),
       ('IC', 'IC'),
       ('IT', 'IT'),
       ('LU', 'LU'),
       ('NL', 'NL'),
       ('OM', 'OM'),
       ('PL', 'PL'),
       ('PT', 'PT'),
       ('QA', 'QA'),
       ('SA', 'SA'),
       ('SE', 'SE'),
       ('SG', 'SG'),
       ('Sl', 'Sl')
Go