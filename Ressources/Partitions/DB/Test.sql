/* RAZ */
TRUNCATE TABLE DSV.AuditPartition;

DBCC CHECKIDENT ('DSV.AuditPartition', reseed, 1);

/* Creation */
DECLARE @AuditTraitement_id int
EXECUTE [dbo].initTraitement @AuditTraitement_id OUTPUT, 1, 'DOMAINE\User'
SELECT @AuditTraitement_id

/* Etape 2 */
EXECUTE [dbo].EtapeSuivante @AuditTraitement_id OUTPUT, 2
SELECT * FROM DSV.AuditPartition
SELECT @AuditTraitement_id

/* Etape 3 */
EXECUTE [dbo].EtapeSuivante @AuditTraitement_id OUTPUT, 3
SELECT * FROM DSV.AuditPartition
SELECT @AuditTraitement_id

/* Cloture */
EXECUTE [dbo].ClotureTraitement @AuditTraitement_id
SELECT * FROM DSV.AuditPartition