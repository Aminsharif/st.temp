insert into KeyingSystemTypes (Id, Caption, SequenceName) values ('00000000-0000-0000-0000-000000000001', 'None', 'None')

Go

Create table LockwizKeyingSystemSpecificationNames
(
    Id                 uniqueIdentifier not null primary key,
    KeyingSystemTypeId uniqueIdentifier not null
        constraint FK_LockwizKeyingSystemSpecificationNames_KeyingSystemTypes references KeyingSystemTypes,
    SpecificationName  nvarchar(255)    not null
        CONSTRAINT UQ_AdditionalEquipments_Classification UNIQUE (SpecificationName)
)

Go

Create Table CalculationConfigurations
(
    Id                                     uniqueidentifier primary key not null,
    LockwizKeyingSystemSpecificationNameId uniqueidentifier             not null
        constraint FK_CalculationConfigurations_LockwizKeyingSystemSpecificationNames references LockwizKeyingSystemSpecificationNames,
    LockwizValue                           int                          not null,
    ProductionValue                        nvarchar(255)                not null,
    ProfileEntryType                       int                          not null,
    [Index]                                int                          not null,
    [Key]                                  nvarchar(255)                not null,
    ProdCode                               nvarchar(255)                not null,
    CustomerInformationId                  nvarchar(255)
)

Go

INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'37f7e41c-8a96-4eb9-b68c-38f7f4f844ed', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veCarat');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'87f3864a-1a8f-439f-b7da-3196ae5ab78e', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2veCSKC');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'b7e3470b-1fa5-4ee7-a2f8-fd852e5ae246', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2veCSKG');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'c3871421-e23b-4c06-9f89-709943b6203b', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veGHS5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'b0c02659-134c-46f2-a5c3-476094cad0f9', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veGHS6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'68895c76-04e9-47f4-bc1d-676ede62ffa7', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veplusGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'48c4f944-b714-4e13-8ade-92f9a2bc893c', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veplusZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'ca6b9f77-08f2-4709-977e-e9204dd905d7', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veZ5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'6b549cff-0616-449f-9c29-08582847df39', N'08e53d25-d843-4f60-bb56-448e0c16d082', N'2veZ6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'1793b7d3-4d63-49b0-abe3-43dc187b9efa', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2VSGHS5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'726757ca-06a1-48bb-9812-10f045910b1a', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2VSGHS6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'e8adea6f-c014-4c0f-b836-87b6fbf0abd9', N'08e53d25-d843-4f60-bb56-448e0c16d088', N'2VSplusGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'46bb3eb1-fc6c-4fa8-962a-200dfc7c6c8c', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2VSplusSoprf.');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'beab83e0-e65f-4d5e-a6e2-3a0607210763', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2VSplusZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'1d2e83ea-8682-47ee-a4e9-cff3f48ebb73', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2VSSoprof.');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'641ef69c-6c22-48b4-909e-1e0cf294d21b', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2VSZ5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'81322deb-0e77-4ef9-8ec0-32b69d64aeba', N'08e53d25-d843-4f60-bb56-448e0c16d09b', N'2VSZ6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'b67708e2-b981-490f-bee5-60abe29aa897', N'08e53d25-d843-4f60-bb56-448e0c16d09a', N'3veCarat');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'90b1c3a8-9a85-4bbd-9299-93b1305e9aac', N'08e53d25-d843-4f60-bb56-448e0c16d09c', N'3veCSKG');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'7b746a39-9706-4ff5-bde7-983accfa157a', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veGHS5E4');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'58939c46-894c-4c1a-a9b2-86338eb2faac', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veGHS5E5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'1333e70f-65f4-40a1-8fe8-4b62222e9496', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veGHS6E6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'd90d3e79-7802-496c-809a-19964f898e97', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veplusGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'dc49448f-bfae-4b53-9bd2-f735c0cf2418', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veSKGGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'a1f134d2-bbaf-4c89-8b87-e01a08c4cb0a', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veSKGZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'7cbc560f-cbd2-493e-88da-3aacdf81d6e5', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veVDSGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'926e67f2-965e-4830-8892-7174f23e00bb', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veVDSZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'9257787a-25a8-4b62-8cc1-2ddbdf3c1a33', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veZ5E4');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'b0108004-0b0f-4696-b92a-9a078ef63f39', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veZ5E5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'a582348a-12be-48ff-a66e-f86165353b3e', N'08e53d25-d843-4f60-bb56-448e0c16d084', N'3veZ6E6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'28f2eb6b-1cae-462e-83d3-6f3a8071ec8d', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSGHS5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'26c532b7-4fe2-4097-a0fe-5d767749945d', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSGHS6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'86923b64-d5a6-40a9-8aba-cd92ac18ee8d', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSplusGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'4b117011-a99e-4962-9503-2f568b2b9cb0', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSplusSoprf.');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'b160b1df-a76e-49f3-af0e-fb540fa5d146', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSplusZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'd44ffbc1-ceaf-4c18-b16b-4e723d4e9f21', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSSoprof.');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'7013964d-4017-4920-8668-07f132ee8653', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSVDSGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'fcd18aa3-bbcb-41e9-99cf-e10de7b034aa', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSVDSSoprof.');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'd309c48c-6d76-4010-b8f3-541afc0d05d4', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSVDSZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'1208fecf-ea2c-41e1-bb74-7bdfa1d38766', N'08e53d25-d843-4f60-bb56-448e0c16d089', N'3VSZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'7d3104dc-0ab9-43a5-8c12-63821bb02947', N'08e53d25-d843-4f60-bb56-448e0c16d092', N'S1Carat');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'132e7156-7a62-4b0e-8160-45e7de1c1a05', N'08e53d25-d843-4f60-bb56-448e0c16d093', N'S3Carat');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'7503e6cc-fbb4-40ca-ba02-de1be9e69c25', N'08e53d25-d843-4f60-bb56-448e0c16d093', N'S3CSKG');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'cb9c4a05-ea03-4f1d-8302-9073121f09dc', N'08e53d25-d843-4f60-bb56-448e0c16d094', N'S4Carat');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'd2910ca9-8e31-4ce1-be07-2ec7e7a91f38', N'08e53d25-d843-4f60-bb56-448e0c16d095', N'S5Carat');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'16f69e03-bf35-4b7d-b9c3-6233d0d17e09', N'08e53d25-d843-4f60-bb56-448e0c16d0a0', N'S5CSKG');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'88ee7cca-140e-4241-82b2-ff85ecd465f5', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6GHS5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'89c42b21-cc94-4649-ba83-1189cbf99730', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6GHS6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'1d0217db-f947-4b25-8a97-7f306c486363', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6SKGSoprof.');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'17de9907-6756-443e-8a9d-40788f42245d', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6Soprof.');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'4b84e2a2-d3df-4c65-9b59-c1f797276653', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6VDSGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'3023ed73-0de7-4afb-8b34-6ac8b9f8974d', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6VDSSoprof.');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'9663f24e-28a5-42ba-a3e8-f56f38273d96', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6VDSZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'4263d415-4eb8-4148-a03c-20ca07a1608e', N'08e53d25-d843-4f60-bb56-448e0c16d087', N'Si6Z');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'1f6e4f95-609d-440b-8c3f-1c64e6630a8b', N'08e53d25-d843-4f60-bb56-448e0c16d098', N'TH6Carat');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'556d9b45-f083-453b-bfc6-590e5acb48c4', N'00000000-0000-0000-0000-000000000001', N'TH6VDSGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'e8961a58-d50e-4c0f-b060-6ebcf9477862', N'00000000-0000-0000-0000-000000000001', N'TH6VDSZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'11a79aea-75d7-4f1f-a8e0-517df573670c', N'00000000-0000-0000-0000-000000000001', N'TH7VDSGHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'49ef1ceb-766a-4682-9c06-475e4e1a70bd', N'00000000-0000-0000-0000-000000000001', N'TH7VDSZ');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'f67a9360-a450-4b15-83f0-2035f4319610', N'08e53d25-d843-4f60-bb56-448e0c16d086', N'Thales6GHS5');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'91889584-38c9-4b09-9aa8-70ae7ce4db5c', N'08e53d25-d843-4f60-bb56-448e0c16d086', N'Thales6GHS52');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'a9e87b3d-7e99-4c62-a6f7-9db788a4bc46', N'08e53d25-d843-4f60-bb56-448e0c16d086', N'Thales6GHS53');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'78f636b5-ba2b-4b50-ba6a-66a2df9155d0', N'08e53d25-d843-4f60-bb56-448e0c16d086', N'Thales6GHS6');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'61a28dd6-3502-4ee6-9270-622bacde2e14', N'08e53d25-d843-4f60-bb56-448e0c16d086', N'Thales6GHS62');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'd92bf83b-10f9-4cb0-afb3-bdf0230c516f', N'08e53d25-d843-4f60-bb56-448e0c16d086', N'Thales6GHS63');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'f1f62e24-9790-4e6b-b089-291666650bf6', N'00000000-0000-0000-0000-000000000001', N'Thales6Z');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'1d617c4b-85d4-4f0f-ad18-7de88cd8261f', N'00000000-0000-0000-0000-000000000001', N'Thales7GHS');
INSERT INTO LockwizKeyingSystemSpecificationNames (Id, KeyingSystemTypeId, SpecificationName) VALUES (N'36234117-7d78-46e9-b66a-6b2f44baea5a', N'00000000-0000-0000-0000-000000000001', N'Thales7Z');

Go