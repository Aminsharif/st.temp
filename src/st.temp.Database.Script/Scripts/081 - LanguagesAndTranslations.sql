CREATE TABLE [dbo].[Languages](
	[Id] [uniqueidentifier] NOT NULL,
	[LanguageName] [nvarchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](255) NOT NULL,
	[LastUpdated] [datetime2](7) NOT NULL,
	[UpdatedBy] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Languages] ([Id], [LanguageName], [IsActive], [Created], [CreatedBy], [LastUpdated], [UpdatedBy]) VALUES (N'b6b5c6c6-1010-4918-9506-c5e8189fb1e9', N'English', 1, CAST(N'2022-05-07T00:00:00.0000000' AS DateTime2), N'jaros@wilka.de', CAST(N'2022-05-07T00:00:00.0000000' AS DateTime2), N'jaros@wilka.de')
GO
INSERT [dbo].[Languages] ([Id], [LanguageName], [IsActive], [Created], [CreatedBy], [LastUpdated], [UpdatedBy]) VALUES (N'7ef9ea9e-99e4-4d82-b32d-f9381b20b6c7', N'Deutsch', 1, CAST(N'2022-05-07T00:00:00.0000000' AS DateTime2), N'jaros@wilka.de', CAST(N'2022-05-07T00:00:00.0000000' AS DateTime2), N'jaros@wilka.de')
GO
ALTER TABLE [dbo].[Languages] ADD  CONSTRAINT [DF_Languages_Id]  DEFAULT (newid()) FOR [Id]
GO

CREATE TABLE [dbo].[TranslationBase](
	[Id] [uniqueidentifier] NOT NULL,
	[TextKey] [nvarchar](255) NOT NULL,
	[AdminContact] [nvarchar](255) NOT NULL,
	[RedirectLink] [nvarchar](255) NOT NULL,
	[HelpLink] [nvarchar](255) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](255) NOT NULL,
	[LastUpdated] [datetime2](7) NOT NULL,
	[UpdatedBy] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_TranslationBase] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TranslationBase] ADD  CONSTRAINT [DF_TranslationBase_Id]  DEFAULT (newid()) FOR [Id]
GO

CREATE TABLE [dbo].[TranslationTexts](
	[Id] [uniqueidentifier] NOT NULL,
	[TranslationBaseId] [uniqueidentifier] NOT NULL,
	[LanguageId] [uniqueidentifier] NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_TranslationTexts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TranslationTexts] ADD  CONSTRAINT [DF_TranslationTexts_Id]  DEFAULT (newid()) FOR [Id]
GO