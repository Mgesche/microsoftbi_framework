/* Exemple :

	EXECUTE [dbo].ClotureTraitement 1
	
	SELECT * FROM DSV.AuditPartition

*/
CREATE  PROCEDURE [dbo].ClotureTraitement 
    @AuditTraitement_id INTEGER

AS

/* Cloture etape */
UPDATE DSV.AuditPartition
SET DtFin = CURRENT_TIMESTAMP
WHERE AuditTraitement_id = @AuditTraitement_id;

GO