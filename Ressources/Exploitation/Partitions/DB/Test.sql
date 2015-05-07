BEGIN TRANSACTION TestTransaction

SET NOCOUNT ON

DECLARE @Resulat VARCHAR(50)

/* RAZ */
TRUNCATE TABLE DSV.AuditPartition;

DBCC CHECKIDENT ('DSV.AuditPartition', reseed, 1);

/* Creation d'un traitement */
DECLARE @AuditTraitement_id int
EXECUTE [dbo].initTraitement @AuditTraitement_id OUTPUT, 1, 'DOMAINE\User'
IF @AuditTraitement_id != 1
RAISERROR('La création du traitement ne renvois pas le bon id',1,1);

/* Etape 2 */
SET @AuditTraitement_id = EXECUTE [dbo].EtapeSuivante @AuditTraitement_id, 2
SET @Resulat = (SELECT COUNT(*) FROM DSV.AuditPartition);
IF @Resulat != 2
RAISERROR('Le passage a l''etape 2 ne crée pas une nouvelle étape',1,1)
IF @AuditTraitement_id != 2
RAISERROR('Le passage a l''etape 2 ne renvois pas le bon id',1,1);

/* Etape 3 */
SET @AuditTraitement_id = EXECUTE [dbo].EtapeSuivante @AuditTraitement_id, 3
SET @Resulat = (SELECT COUNT(*) FROM DSV.AuditPartition);
IF @Resulat != 3
RAISERROR('Le passage a l''etape 3 ne crée pas une nouvelle étape',1,1)
IF @AuditTraitement_id != 3
RAISERROR('Le passage a l''etape 3 ne renvois pas le bon id',1,1);

/* Cloture */
EXECUTE [dbo].ClotureTraitement @AuditTraitement_id
SET @Resulat = (SELECT COUNT(*) FROM DSV.AuditPartition);
IF @Resulat != 3
RAISERROR('La cloture crée une nouvelle étape, ce qui n''est pas prévu',1,1);

/* Creation d'une table inexistante */
/* Preparation de la table struct */
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DSVDebitTotauxCRM_Struct' AND TABLE_SCHEMA = 'DSV')
BEGIN
	SELECT TOP 0 *
	INTO DSV.DSVDebitTotauxCRM_Struct
	FROM dbo.DSVDebitTotauxCRM
END
EXECUTE [dbo].CreateTableDsv 369
SET @Resulat = (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DSVDebitTotauxCRM_369' AND TABLE_SCHEMA = 'DSV')
IF @Resulat != 1
RAISERROR('La table DSV.DSVDebitTotauxCRM n''a pas été crée',1,1);
SET @Resulat = (SELECT COUNT(*) FROM DSV.DSVDebitTotauxCRM_369);
IF @Resulat != 0
RAISERROR('La table DSV.DSVDebitTotauxCRM n''est pas vide',1,1);

/* Creation d'une table existante */
/* Preparation de la table struct */
EXECUTE [dbo].CreateTableDsv 369
SET @Resulat = (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DSVDebitTotauxCRM_369' AND TABLE_SCHEMA = 'DSV')
IF @Resulat != 1
RAISERROR('La table DSV.DSVDebitTotauxCRM n''a pas été crée',1,1);
SET @Resulat = (SELECT COUNT(*) FROM DSV.DSVDebitTotauxCRM_369);
IF @Resulat != 0
RAISERROR('La table DSV.DSVDebitTotauxCRM n''est pas vide',1,1);

/* Gestion des erreurs */
EXECUTE [dbo].initTraitement @AuditTraitement_id OUTPUT, 2, 'DOMAINE\User'
SET @AuditTraitement_id = EXECUTE [dbo].EtapeSuivante @AuditTraitement_id, 2
EXECUTE [dbo].ErrorTraitement @AuditTraitement_id, 'Erreur !!!'
SET @Resulat = (SELECT COUNT(*) FROM DSV.AuditPartition WHERE Id_Partition = 2);
IF @Resulat != 2
RAISERROR('La gestion des erreurs ne renvoie pas le bon nombre de lignes',1,1);
SET @Resulat = (SELECT StrMessageErreur FROM DSV.AuditPartition WHERE Id_Partition = 2 AND Id_Etape = 1);
IF @Resulat IS NOT NULL
RAISERROR('La gestion des erreurs stocke un message d''erreur sur la mauvaise ligne',1,1);
SET @Resulat = (SELECT StrMessageErreur FROM DSV.AuditPartition WHERE Id_Partition = 2 AND Id_Etape = 2);
IF @Resulat != 'Erreur !!!'
RAISERROR('La gestion des erreurs renvoie un mauvais message d''erreur',1,1);

SET NOCOUNT OFF

ROLLBACK TRANSACTION TestTransaction