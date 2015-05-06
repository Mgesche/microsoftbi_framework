IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Partitions' AND TABLE_SCHEMA = 'DSV')
BEGIN
	DROP TABLE DSV.Partitions
END

CREATE TABLE [DSV].[partitions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Fact] [varchar](50) NULL,
	[Period] [varchar](50) NULL,
	[StartD] [int] NOT NULL,
	[EndD] [int] NOT NULL,
	[SousPeriod] [varchar](50) NULL,
	[ToProcess] [int] NULL,
	[CreateXMLA] [varchar](5000) NULL,
	[UpdateXMLA] [varchar](5000) NULL,
	[DatabaseID] [varchar](50) NULL,
	[CubeID] [varchar](50) NULL,
	[MeasureGroupID] [varchar](50) NULL,
	[MeasureGroupIDReference] [varchar](50) NULL,
	[ChampsTableName] [varchar](50) NULL,
	[CreateXMLARef] [varchar](5000) NULL,
	[UpdateXMLARef] [varchar](5000) NULL,
	[PartitionTableQuery] [varchar](5000) NULL,
	[PartitionTableGlobal] [varchar](100) NULL,
	[PartitionTableUnitaire] [varchar](100) NULL,
	[ProcessAction] [varchar](5000) NULL,
	[ProcessActionRef] [varchar](5000) NULL,
	[ToProcessRef] [int] NULL,
	[ProcessActionIndex] [varchar](5000) NULL,
	[ProcessActionRefIndex] [varchar](5000) NULL,
	[DataSourceID] [varchar](50) NULL,
	[TypePlanif] [char](1) NULL,
	[export_rapp] [char](5) NULL,
 CONSTRAINT [PK_partitions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [DSV].[partitions] ADD  CONSTRAINT [DF_partitions_DatabaseID]  DEFAULT ('BaseOLAP_MEC') FOR [DatabaseID]
GO

ALTER TABLE [DSV].[partitions] ADD  CONSTRAINT [DF_partitions_CubeID]  DEFAULT ('Botanic DW1 1') FOR [CubeID]
GO

ALTER TABLE [DSV].[partitions] ADD  CONSTRAINT [DF_partitions_DataSourceID]  DEFAULT ('Botanic DW1') FOR [DataSourceID]
GO

CREATE TRIGGER [DSV].[TRIG_CREATEPARTITION]

ON [DSV].[partitions]


AFTER UPDATE 
AS 
IF ( UPDATE (Fact) 
	OR UPDATE (Period)
	OR UPDATE (SousPeriod)
	OR UPDATE (StartD)
	OR UPDATE (EndD)
	OR UPDATE (toprocess) 
	OR UPDATE (toprocessref)
	OR UPDATE (datasourceid)
	)
BEGIN
			update 	partitions 
			set CreateXMLA = DSV.createxmlafield(i.id),
			UpdateXMLA = DSV.updatexmlafield(i.id),
			CreateXMLARef = DSV.createxmlareffield(i.id),
			UpdateXMLARef = DSV.updatexmlareffield(i.id),
			ProcessAction = DSV.processxmlafield(i.id),
			ProcessActionRef = DSV.processxmlareffield(i.id),
			ProcessActionIndex = DSV.processIndexxmlafield(i.id),
			ProcessActionRefIndex = DSV.processIndexxmlareffield(i.id)
			from partitions p, inserted i
			where p.id = i.id
			
--from inserted where partitions.id  = inserted.id

END;
