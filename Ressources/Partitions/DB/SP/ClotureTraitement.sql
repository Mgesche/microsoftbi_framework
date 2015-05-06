/* Exemple :

	EXECUTE [dbo].ClotureTraitement 1
	
	SELECT * FROM DSV.AuditPartition

*/
IF object_id(N'DSV.ClotureTraitement', N'P') IS NOT NULL
    DROP PROCEDURE DSV.ClotureTraitement
GO

CREATE PROCEDURE DSV.ClotureTraitement 
    @AuditTraitement_id INTEGER

AS

/* Cloture etape */
UPDATE DSV.AuditPartition
SET DtFin = CURRENT_TIMESTAMP
WHERE AuditTraitement_id = @AuditTraitement_id;

GO