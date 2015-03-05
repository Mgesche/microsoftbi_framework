/* Creation de la table avec sa structure modifiée */
USE [DWH]
GO
IF  EXISTS (SELECT * FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA_OLD]'))
DROP TABLE [dbo].[F_PMSI_MCO_RSA];
GO

/* Renommer la table existante : car ajout d'une colonne. Sinon, simlement supprimer /recréer l'index clustered */
USE [DWH]
GO

EXEC sp_rename 'F_PMSI_MCO_RSA_OLD', 'F_PMSI_MCO_RSA';
EXEC sp_rename N'F_PMSI_MCO_RSA.PK_F_PMSI_MCO_RSA_OLD', N'PK_F_PMSI_MCO_RSA', N'INDEX';

/* Renommer les foreign key */
USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_CIM10_DP_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DP_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DP] FOREIGN KEY([ID_DIAG_PRINCIPAL])
REFERENCES [dbo].[D_PMSI_CIM10] ([ID_DIAG])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DP]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_CIM10_DR_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DR_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DR] FOREIGN KEY([ID_DIAG_RELIE])
REFERENCES [dbo].[D_PMSI_CIM10] ([ID_DIAG])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_CIM10_DR]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_DEST_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_DEST_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_DEST] FOREIGN KEY([ID_DEST])
REFERENCES [dbo].[D_PMSI_DESTINATION] ([ID_DEST])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_DEST]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE] FOREIGN KEY([ID_CODE_GEO])
REFERENCES [dbo].[D_PMSI_GEO_COMMUNE] ([ID_CODE_GEO])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GEO_COMMUNE]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_GHM_IDT_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GHM_IDT_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GHM_IDT] FOREIGN KEY([IDT_GHM])
REFERENCES [dbo].[D_PMSI_MCO_GHM] ([IDT_GHM])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_GHM_IDT]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_MODE_ENTREE_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_ENTREE_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_ENTREE] FOREIGN KEY([ID_MODE_ENTREE])
REFERENCES [dbo].[D_PMSI_MODE_ENTREE] ([ID_MODE_ENTREE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_ENTREE]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_MODE_SORTIE_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_SORTIE_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_SORTIE] FOREIGN KEY([ID_MODE_SORTIE])
REFERENCES [dbo].[D_PMSI_MODE_SORTIE] ([ID_MODE_SORTIE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_MODE_SORTIE]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_PROV]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_PROV_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_PROV] FOREIGN KEY([ID_PROV])
REFERENCES [dbo].[D_PMSI_PROVENANCE] ([ID_PROV])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_PROV]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_SEXE_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_SEXE_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_SEXE] FOREIGN KEY([ID_SEXE])
REFERENCES [dbo].[D_PMSI_SEXE] ([ID_SEXE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_SEXE]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_STR_ET_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_STR_ET_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_STR_ET] FOREIGN KEY([ID_FINESS])
REFERENCES [dbo].[D_STR_ET] ([ID_FINESS_ET])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_STR_ET]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_TPS_MOIS_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TPS_MOIS_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TPS_MOIS] FOREIGN KEY([ID_MOIS])
REFERENCES [dbo].[D_TPS_MOIS] ([ID_MOIS])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TPS_MOIS]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE] FOREIGN KEY([ID_TRANCHE_AGE])
REFERENCES [dbo].[D_PMSI_TRANCHE_AGE] ([ID_TRANCHE_AGE])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TRANCHE_AGE]
GO

USE [DWH]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR_OLD]') AND parent_object_id = OBJECT_ID(N'[dbo].[F_PMSI_MCO_RSA]'))
ALTER TABLE [dbo].[F_PMSI_MCO_RSA] DROP CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR_OLD]
GO

USE [DWH]
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA]  WITH NOCHECK ADD  CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR] FOREIGN KEY([ID_TYPE_SEJOUR])
REFERENCES [dbo].[D_PMSI_TYPE_SEJOUR] ([ID_TYPE_SEJOUR])
GO

ALTER TABLE [dbo].[F_PMSI_MCO_RSA] CHECK CONSTRAINT [FK_F_PMSI_MCO_RSA_D_TYPE_SEJOUR]
GO

/* Lien via un schema avec les filegroup */
USE [DWH]
GO
DROP PARTITION SCHEME Scheme_Partition_Annee;

/* Creation des fichiers DB */
USE [master]
GO
ALTER DATABASE [DWH]
DROP FILE N'DWH_DIAMANT_2008'
GO

ALTER DATABASE [DWH]
DROP FILE N'DWH_DIAMANT_2009'
GO

ALTER DATABASE [DWH]
DROP FILE N'DWH_DIAMANT_2010'
GO

ALTER DATABASE [DWH]
DROP FILE N'DWH_DIAMANT_2011'
GO

ALTER DATABASE [DWH]
DROP FILE N'DWH_DIAMANT_2012'
GO

ALTER DATABASE [DWH]
DROP FILE  N'DWH_DIAMANT_2013'
GO

ALTER DATABASE [DWH]
DROP FILE N'DWH_DIAMANT_2014', 
GO

ALTER DATABASE [DWH]
DROP FILE N'DWH_DIAMANT_Other';
GO

/* Creation des filegroup */
USE [master]
GO
ALTER DATABASE [DWH] DROP FILEGROUP [DATA_2008]
GO
ALTER DATABASE [DWH] DROP FILEGROUP [DATA_2009]
GO
ALTER DATABASE [DWH] DROP FILEGROUP [DATA_2010]
GO
ALTER DATABASE [DWH] DROP FILEGROUP [DATA_2011]
GO
ALTER DATABASE [DWH] DROP FILEGROUP [DATA_2012]
GO
ALTER DATABASE [DWH] DROP FILEGROUP [DATA_2013]
GO
ALTER DATABASE [DWH] DROP FILEGROUP [DATA_2014]
GO
ALTER DATABASE [DWH] DROP FILEGROUP [DATA_Other]
GO

/* Creation de la fonction de partition pour dire comment les données vont se repartir */
USE [DWH]
GO
DROP PARTITION FUNCTION Func_Partition_Annee;