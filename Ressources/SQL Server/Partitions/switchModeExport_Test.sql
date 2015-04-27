BEGIN TRANSACTION TestTransaction

SET NOCOUNT ON

DECLARE @Resulat VARCHAR(50)

/* Cas sans modifications */
INSERT INTO export_differentiel.nopartition
SELECT 'XXX_TestSansModif', 'RIEN'

EXECUTE [export_differentiel].[switchModeExport] -2, 'XXX_TestSansModif', 'DIFF'

SET @Resulat = (SELECT export_RAPP FROM export_differentiel.partitions WHERE Fact = 'XXX_TestSansModif')
IF @Resulat != 'RIEN'
RAISERROR('switchModeExport ne renvois pas la bonne valeur pour la cas sans modifications',1,1)

/* Cas non partitionné */
INSERT INTO export_differentiel.nopartition
SELECT 'XXX_TestNonPartition', 'RIEN'

EXECUTE [export_differentiel].[switchModeExport] -1, 'XXX_TestNonPartition', 'DIFF'

SET @Resulat = (SELECT export_RAPP FROM export_differentiel.partitions WHERE Fact = 'XXX_TestNonPartition')
IF @Resulat != 'DIFF'
RAISERROR('switchModeExport ne renvois pas la bonne valeur pour la cas non partitionné',1,1)

/* Cas partitionné */
SET IDENTITY_INSERT dbo.partitions ON
INSERT INTO dbo.partitions (Id, Fact, [StartD], [EndD], [export_rapp])
SELECT -9, 'XXX_TestPartition', 20120101, 20120102, 'RIEN'
SET IDENTITY_INSERT dbo.partitions OFF

EXECUTE [export_differentiel].[switchModeExport] -9, 'XXX_TestPartition', 'DIFF'

SET @Resulat = (SELECT export_RAPP FROM export_differentiel.partitions WHERE Fact = 'XXX_TestPartition')
IF @Resulat != 'DIFF'
RAISERROR('switchModeExport ne renvois pas la bonne valeur pour la cas partitionné',1,1)

SET NOCOUNT OFF

ROLLBACK TRANSACTION TestTransaction