/* Ressources */
En partant de 0 : http://databases.about.com/od/sqlserver/a/partitioning.htm
Avec une table existante : http://www.mssqltips.com/sqlservertip/2888/how-to-partition-an-existing-sql-server-table/

/* Creation de la fonction de partition pour dire comment les données vont se repartir */
USE [DWH]
GO
CREATE PARTITION FUNCTION Func_Partition_Annee (int)
 AS RANGE LEFT
 FOR VALUES (2008, 2009, 2010, 2011, 2012, 2013, 2014);

/* Creation des filegroup */
USE [master]
GO
ALTER DATABASE [DWH] ADD FILEGROUP [DATA_2008]
GO
ALTER DATABASE [DWH] ADD FILEGROUP [DATA_2009]
GO
ALTER DATABASE [DWH] ADD FILEGROUP [DATA_2010]
GO
ALTER DATABASE [DWH] ADD FILEGROUP [DATA_2011]
GO
ALTER DATABASE [DWH] ADD FILEGROUP [DATA_2012]
GO
ALTER DATABASE [DWH] ADD FILEGROUP [DATA_2013]
GO
ALTER DATABASE [DWH] ADD FILEGROUP [DATA_2014]
GO
ALTER DATABASE [DWH] ADD FILEGROUP [DATA_Other]
GO

/* Creation des fichiers DB */
USE [master]
GO
ALTER DATABASE [DWH]
ADD FILE ( NAME = N'DWH_DIAMANT_2008', 
           FILENAME = N'D:\DEVBDD\SQL_DATA\USERDB\DBFILE\DWH_2008.mdf', 
		   SIZE = 1048576KB , 
		   FILEGROWTH = 262144KB ) TO FILEGROUP [DATA_2008]
GO

ALTER DATABASE [DWH]
ADD FILE ( NAME = N'DWH_DIAMANT_2009', 
           FILENAME = N'D:\DEVBDD\SQL_DATA\USERDB\DBFILE\DWH_2009.mdf', 
		   SIZE = 1048576KB , 
		   FILEGROWTH = 262144KB ) TO FILEGROUP [DATA_2009]
GO

ALTER DATABASE [DWH]
ADD FILE ( NAME = N'DWH_DIAMANT_2010', 
           FILENAME = N'D:\DEVBDD\SQL_DATA\USERDB\DBFILE\DWH_2010.mdf', 
		   SIZE = 1048576KB , 
		   FILEGROWTH = 262144KB ) TO FILEGROUP [DATA_2010]
GO

ALTER DATABASE [DWH]
ADD FILE ( NAME = N'DWH_DIAMANT_2011', 
           FILENAME = N'D:\DEVBDD\SQL_DATA\USERDB\DBFILE\DWH_2011.mdf', 
		   SIZE = 1048576KB , 
		   FILEGROWTH = 262144KB ) TO FILEGROUP [DATA_2011]
GO

ALTER DATABASE [DWH]
ADD FILE ( NAME = N'DWH_DIAMANT_2012', 
           FILENAME = N'D:\DEVBDD\SQL_DATA\USERDB\DBFILE\DWH_2012.mdf', 
		   SIZE = 1048576KB , 
		   FILEGROWTH = 262144KB ) TO FILEGROUP [DATA_2012]
GO

ALTER DATABASE [DWH]
ADD FILE ( NAME = N'DWH_DIAMANT_2013', 
           FILENAME = N'D:\DEVBDD\SQL_DATA\USERDB\DBFILE\DWH_2013.mdf', 
		   SIZE = 1048576KB , 
		   FILEGROWTH = 262144KB ) TO FILEGROUP [DATA_2013]
GO

ALTER DATABASE [DWH]
ADD FILE ( NAME = N'DWH_DIAMANT_2014', 
           FILENAME = N'D:\DEVBDD\SQL_DATA\USERDB\DBFILE\DWH_2014.mdf', 
		   SIZE = 1048576KB , 
		   FILEGROWTH = 262144KB ) TO FILEGROUP [DATA_2014]
GO

ALTER DATABASE [DWH]
ADD FILE ( NAME = N'DWH_DIAMANT_Other', 
           FILENAME = N'D:\DEVBDD\SQL_DATA\USERDB\DBFILE\DWH_Other.mdf', 
		   SIZE = 1048576KB , 
		   FILEGROWTH = 262144KB ) TO FILEGROUP [DATA_Other]
GO

/* Lien via un schema avec les filegroup */
USE [DWH]
GO
CREATE PARTITION SCHEME Scheme_Partition_Annee
 AS PARTITION Func_Partition_Annee
 TO (DATA_2008, DATA_2009, DATA_2010, DATA_2011, DATA_2012, DATA_2013, DATA_2014, DATA_Other);

/* Renommer la table existante : car ajout d'une colonne. Sinon, simlement supprimer /recréer l'index clustered */
USE [DWH]
GO

EXEC sp_rename 'F_PMSI_MCO_RSA', 'F_PMSI_MCO_RSA_OLD';
EXEC sp_rename N'F_PMSI_MCO_RSA_OLD.PK_F_PMSI_MCO_RSA', N'PK_F_PMSI_MCO_RSA_OLD', N'INDEX';

/* Renommer les foreign key */
USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_CIM10_DP]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DP]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DP_OLD] FOREIGN KEY([ID_DIAG_PRINCIPAL])
REFERENCES [dbo].[D_PMSI_CIM10] ([ID_DIAG])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DP_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_CIM10_DR]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DR]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DR_OLD] FOREIGN KEY([ID_DIAG_RELIE])
REFERENCES [dbo].[D_PMSI_CIM10] ([ID_DIAG])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DR_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_DEST]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_DEST]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_DEST_OLD] FOREIGN KEY([ID_DEST])
REFERENCES [dbo].[D_PMSI_DESTINATION] ([ID_DEST])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_DEST_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE_OLD] FOREIGN KEY([ID_CODE_GEO])
REFERENCES [dbo].[D_PMSI_GEO_COMMUNE] ([ID_CODE_GEO])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_GHM_IDT]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GHM_IDT]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GHM_IDT_OLD] FOREIGN KEY([IDT_GHM])
REFERENCES [dbo].[D_PMSI_MCO_GHM] ([IDT_GHM])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GHM_IDT_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_MODE_ENTREE]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_ENTREE]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_ENTREE_OLD] FOREIGN KEY([ID_MODE_ENTREE])
REFERENCES [dbo].[D_PMSI_MODE_ENTREE] ([ID_MODE_ENTREE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_ENTREE_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_MODE_SORTIE]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_SORTIE]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_SORTIE_OLD] FOREIGN KEY([ID_MODE_SORTIE])
REFERENCES [dbo].[D_PMSI_MODE_SORTIE] ([ID_MODE_SORTIE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_SORTIE_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_PROV]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_PROV]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_PROV_OLD] FOREIGN KEY([ID_PROV])
REFERENCES [dbo].[D_PMSI_PROVENANCE] ([ID_PROV])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_PROV_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_SEXE]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_SEXE]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_SEXE_OLD] FOREIGN KEY([ID_SEXE])
REFERENCES [dbo].[D_PMSI_SEXE] ([ID_SEXE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_SEXE_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_STR_ET]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_STR_ET]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_STR_ET_OLD] FOREIGN KEY([ID_FINESS])
REFERENCES [dbo].[D_STR_ET] ([ID_FINESS_ET])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_STR_ET_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_TPS_MOIS]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TPS_MOIS]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TPS_MOIS_OLD] FOREIGN KEY([ID_MOIS])
REFERENCES [dbo].[D_TPS_MOIS] ([ID_MOIS])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TPS_MOIS_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE_OLD] FOREIGN KEY([ID_TRANCHE_AGE])
REFERENCES [dbo].[D_PMSI_TRANCHE_AGE] ([ID_TRANCHE_AGE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE_OLD]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR_OLD] FOREIGN KEY([ID_TYPE_SEJOUR])
REFERENCES [dbo].[D_PMSI_TYPE_SEJOUR] ([ID_TYPE_SEJOUR])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA_OLD] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR_OLD]
GO

/* Creation de la table avec sa structure modifiée */
CREATE TABLE [dbo].[F_PMSI_MCO_RSA](
	[ID_ANNEE] [int] NOT NULL,
	[IDT_FINESS] [numeric](9, 0) NOT NULL,
	[IDT_RSA] [numeric](10, 0) NOT NULL,
	[IDT_PMSI_MCO] [numeric](23, 0) NOT NULL,
	[IDT_GHM] [numeric](12, 0) NOT NULL,
	[IDT_GHM_ORIGINE] [numeric](12, 0) NOT NULL,
	[ID_FINESS] [nvarchar](9) NOT NULL,
	[ID_RSA] [nvarchar](10) NOT NULL,
	[ID_MOIS] [int] NOT NULL,
	[ID_GHM] [nvarchar](6) NOT NULL,
	[ID_GHS] [nvarchar](4) NOT NULL,
	[ID_GHS_ORIGINE] [nvarchar](4) NOT NULL,
	[ID_MODE_ENTREE] [nvarchar](1) NOT NULL,
	[ID_MODE_SORTIE] [nvarchar](1) NOT NULL,
	[ID_PROV] [nvarchar](1) NOT NULL,
	[ID_DEST] [nvarchar](1) NOT NULL,
	[ID_SEXE] [nvarchar](1) NOT NULL,
	[ID_TYPE_SEJOUR] [nvarchar](1) NOT NULL,
	[ID_TRANCHE_AGE] [nvarchar](2) NOT NULL,
	[ID_CODE_GEO] [nvarchar](5) NOT NULL,
	[ID_DIAG_PRINCIPAL] [nvarchar](6) NOT NULL,
	[ID_DIAG_RELIE] [nvarchar](6) NOT NULL,
	[ID_IPP_ANO] [nvarchar](17) NOT NULL,
	[FLG_MULTI_SEJOUR] [int] NULL,
	[VERSION_RSA] [nvarchar](3) NULL,
	[VERSION_RSS] [nvarchar](3) NULL,
	[NUM_SEQ_TARIF] [nvarchar](3) NULL,
	[AGE_ANNEE] [int] NULL,
	[AGE_JOURS] [int] NULL,
	[DUREE_SEJOUR] [int] NULL,
	[NB_SEANCE] [int] NULL,
	[POIDS_GRAMME] [int] NULL,
	[AGE_GESTATIONNEL] [int] NULL,
	[META_DT_CREA] [datetime] NOT NULL,
	[META_DT_MAJ] [datetime] NOT NULL,
	[META_SOURCE] [nvarchar](100) NOT NULL,
	[ID_DIAG_ALL] [int] NULL,
	[ID_CCAM] [int] NULL,
	[ID_DAS] [int] NULL,
 CONSTRAINT [PK_F_PMSI_MCO_RSA] PRIMARY KEY CLUSTERED 
(
	[ID_ANNEE] ASC,
	[IDT_FINESS] ASC,
	[IDT_RSA] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON Scheme_Partition_Annee (ID_ANNEE)
) ON Scheme_Partition_Annee (ID_ANNEE)

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Année du RSA' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_ANNEE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Numéro FINESS de l''établissement (Technique)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'IDT_FINESS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' N° d''index du RSA (Technique)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'IDT_RSA'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Clé  Unique du RSA (Technique)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'IDT_PMSI_MCO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Identifiant du groupe homogène de Malades issu du groupage GENRSA (Technique)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'IDT_GHM'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Numéro FINESS de l''établissement' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_FINESS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' N° d''index du RSA' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_RSA'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Année-Mois de sortie du patient' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_MOIS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Identifiant du groupe homogène de Malades issu du groupage GENRSA' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_GHM'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Numéro de GHS (du GHM GENRSA)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_GHS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Code mode entrée' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_MODE_ENTREE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Code mode sortie' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_MODE_SORTIE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Code provenance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_PROV'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Code destination' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_DEST'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Sexe patient' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_SEXE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Code du type de séjour' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_TYPE_SEJOUR'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Code Tranche Age (année)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_TRANCHE_AGE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Code géographique PMSI de résidence  du patient' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_CODE_GEO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Diagnostic principal (DP) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_DIAG_PRINCIPAL'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Diagnostic relié (DR) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_DIAG_RELIE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' N° anonyme ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_IPP_ANO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Comptabilisation du nombre de patients ayant eu au moins 2 séjours dans la même année.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'FLG_MULTI_SEJOUR'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Numéro de version du format du RSA' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'VERSION_RSA'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Numéro de version du format du "RSS-groupé"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'VERSION_RSS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Numéro séquentiel de tarifs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'NUM_SEQ_TARIF'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Age en années ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'AGE_ANNEE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Age en jours ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'AGE_JOURS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Durée totale du séjour dans le champ du PMSI (vide si séances) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'DUREE_SEJOUR'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Nombre de séances ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'NB_SEANCE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Poids d''entrée (en grammes) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'POIDS_GRAMME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Age gestationnel' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'AGE_GESTATIONNEL'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Date de création  enregistrement' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'META_DT_CREA'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Date de mise à jour' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'META_DT_MAJ'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Origine de la donnée' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'META_SOURCE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Identifiant matriciel diagnostic unifié' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_DIAG_ALL'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Identifiant matriciel diagnostic associé' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_DAS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Identifiant matriciel CCAM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'F_PMSI_MCO_RSA', @level2type=N'COLUMN',@level2name=N'ID_CCAM'
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DP] FOREIGN KEY([ID_DIAG_PRINCIPAL])
REFERENCES [dbo].[D_PMSI_CIM10] ([ID_DIAG])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DP]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DR] FOREIGN KEY([ID_DIAG_RELIE])
REFERENCES [dbo].[D_PMSI_CIM10] ([ID_DIAG])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DR]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_DEST] FOREIGN KEY([ID_DEST])
REFERENCES [dbo].[D_PMSI_DESTINATION] ([ID_DEST])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_DEST]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE] FOREIGN KEY([ID_CODE_GEO])
REFERENCES [dbo].[D_PMSI_GEO_COMMUNE] ([ID_CODE_GEO])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GHM_IDT] FOREIGN KEY([IDT_GHM])
REFERENCES [dbo].[D_PMSI_MCO_GHM] ([IDT_GHM])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GHM_IDT]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_ENTREE] FOREIGN KEY([ID_MODE_ENTREE])
REFERENCES [dbo].[D_PMSI_MODE_ENTREE] ([ID_MODE_ENTREE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_ENTREE]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_SORTIE] FOREIGN KEY([ID_MODE_SORTIE])
REFERENCES [dbo].[D_PMSI_MODE_SORTIE] ([ID_MODE_SORTIE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_SORTIE]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_PROV] FOREIGN KEY([ID_PROV])
REFERENCES [dbo].[D_PMSI_PROVENANCE] ([ID_PROV])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_PROV]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_SEXE] FOREIGN KEY([ID_SEXE])
REFERENCES [dbo].[D_PMSI_SEXE] ([ID_SEXE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_SEXE]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_STR_ET] FOREIGN KEY([ID_FINESS])
REFERENCES [dbo].[D_STR_ET] ([ID_FINESS_ET])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_STR_ET]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TPS_MOIS] FOREIGN KEY([ID_MOIS])
REFERENCES [dbo].[D_TPS_MOIS] ([ID_MOIS])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TPS_MOIS]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE] FOREIGN KEY([ID_TRANCHE_AGE])
REFERENCES [dbo].[D_PMSI_TRANCHE_AGE] ([ID_TRANCHE_AGE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR] FOREIGN KEY([ID_TYPE_SEJOUR])
REFERENCES [dbo].[D_PMSI_TYPE_SEJOUR] ([ID_TYPE_SEJOUR])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] ADD  DEFAULT ((-1)) FOR [ID_DIAG_ALL]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] ADD  DEFAULT ((-1)) FOR [ID_DAS]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] ADD  DEFAULT ((-1)) FOR [ID_CCAM]
GO

/* Index pour les champs matriciels */
CREATE NONCLUSTERED INDEX WRK_F_PMSI_MCO_RSA_ID_DIAG_ALL
ON DWH.dbo.F_PMSI_MCO_RSA (ID_DIAG_ALL)
INCLUDE (ID_ANNEE, IDT_FINESS, IDT_RSA);

CREATE NONCLUSTERED INDEX WRK_F_PMSI_MCO_RSA_ID_DAS
ON DWH.dbo.F_PMSI_MCO_RSA (ID_DAS)
INCLUDE (ID_ANNEE, IDT_FINESS, IDT_RSA);

CREATE NONCLUSTERED INDEX WRK_F_PMSI_MCO_RSA_ID_CCAM
ON DWH.dbo.F_PMSI_MCO_RSA (ID_CCAM)
INCLUDE (ID_ANNEE, IDT_FINESS, IDT_RSA);

/* Repercuter la compression de données */
USE [DWH]
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] REBUILD PARTITION = 1 WITH(DATA_COMPRESSION = PAGE )
USE [DWH]
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] REBUILD PARTITION = 2 WITH(DATA_COMPRESSION = PAGE )
USE [DWH]
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] REBUILD PARTITION = 3 WITH(DATA_COMPRESSION = PAGE )
USE [DWH]
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] REBUILD PARTITION = 4 WITH(DATA_COMPRESSION = PAGE )
USE [DWH]
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] REBUILD PARTITION = 5 WITH(DATA_COMPRESSION = PAGE )
USE [DWH]
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] REBUILD PARTITION = 6 WITH(DATA_COMPRESSION = PAGE )
USE [DWH]
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] REBUILD PARTITION = 7 WITH(DATA_COMPRESSION = PAGE )
USE [DWH]
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] REBUILD PARTITION = 8 WITH(DATA_COMPRESSION = PAGE )

/* Passage en mode recovery simple pour diminuer l'impact sur le journal de log */
USE [master]
GO
ALTER DATABASE [DWH] SET RECOVERY SIMPLE WITH NO_WAIT
GO

/* Insertion des données */
USE [DWH]
GO
INSERT INTO F_PMSI_MCO_RSA
SELECT *, -1, -1, -1
FROM F_PMSI_MCO_RSA_OLD;

/* Remise en etat du mode de journalisation */
USE [master]
GO
ALTER DATABASE [DWH] SET RECOVERY BULK_LOGGED WITH NO_WAIT
GO