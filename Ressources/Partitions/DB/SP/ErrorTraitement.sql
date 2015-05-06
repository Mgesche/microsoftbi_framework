/* Exemple :

	EXECUTE [dbo].ErrorTraitement 1, 'Erreur !!!'
	
	SELECT * FROM DSV.AuditPartition

*/
CREATE  PROCEDURE [dbo].ErrorTraitement 
    @AuditTraitement_id INTEGER,
	@ErrorMEssage VARCHAR(500)

AS

UPDATE DSV.AuditPartition
SET DtFin = CURRENT_TIMESTAMP,
	StrMessageErreur = @ErrorMEssage
WHERE AuditTraitement_id = @AuditTraitement_id;

GO