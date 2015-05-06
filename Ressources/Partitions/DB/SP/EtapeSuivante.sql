/* Exemple :

	EXECUTE [dbo].EtapeSuivante 1, 2
	
	SELECT * FROM DSV.AuditPartition

*/
ALTER PROCEDURE [dbo].EtapeSuivante
	@AuditTraitement_id INTEGER 
,	@id_Etape INTEGER  

AS

DECLARE @DtCourant DATETIME
SET @DtCourant = CURRENT_TIMESTAMP;

DECLARE @strUser VARCHAR(50)
SET @strUser = (SELECT TOP 1 strUser FROM DSV.AuditPartition WHERE AuditTraitement_id = @AuditTraitement_id);

DECLARE @id_partition int
SET @id_partition = (SELECT TOP 1 id_partition FROM DSV.AuditPartition WHERE AuditTraitement_id = @AuditTraitement_id);

/* Cloture etape precedante */
UPDATE DSV.AuditPartition
SET DtFin = @DtCourant
WHERE AuditTraitement_id = @AuditTraitement_id;

/* Creation  nouvelle etape */
INSERT INTO DSV.AuditPartition (
	id_Partition,
	id_Etape,
	DtDebut,
	StrUser
)
VALUES (
	@id_Partition,
	@id_Etape,
	@DtCourant,
	@strUser
);

SET @AuditTraitement_id = @@IDENTITY;

SELECT @AuditTraitement_id AS AuditTraitement_id 

RETURN

GO