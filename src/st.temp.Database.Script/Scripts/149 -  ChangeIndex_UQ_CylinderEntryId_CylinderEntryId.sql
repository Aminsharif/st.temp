DROP INDEX [dbo].[CylinderEntriesToCylinderEntries].[UQ_CylinderEntryId_CylinderEntryId]

CREATE UNIQUE NONCLUSTERED INDEX [UQ_CylinderEntryId_CylinderEntryId] ON [dbo].[CylinderEntriesToCylinderEntries]
(
	[SourceCylinderEntryId] ASC,
	[TargetCylinderEntryId] ASC,
	[ConnectionGroup] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
