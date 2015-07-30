USE [BotanicDW_MEC]
GO

/****** Object:  Table [Test].[Ref_TablesTests]    Script Date: 07/22/2015 10:24:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Test].[Ref_TablesTests](
	[idTablesTests] [int] IDENTITY(1,1) NOT NULL,
	[strSchemaOrigine] [varchar](50) NULL,
	[strTableOrigine] [varchar](50) NULL,
	[strSchemaTest] [varchar](50) NULL,
	[strTableTest] [varchar](50) NULL,
	[iEtatTest] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


