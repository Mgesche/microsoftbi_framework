/* Exemple :

	EXECUTE [dbo].ErrorTraitement 1, 'Erreur !!!'
	
	SELECT * FROM DSV.AuditPartition

*/
IF object_id(N'DSV.ErrorTraitement', N'P') IS NOT NULL
    DROP PROCEDURE DSV.ErrorTraitement
GO

CREATE  PROCEDURE [DSV].ErrorTraitement 
    @AuditTraitement_id INTEGER,
	@ErrorMEssage VARCHAR(500)

AS

UPDATE DSV.AuditPartition
SET DtFin = CURRENT_TIMESTAMP,
	StrMessageErreur = @ErrorMEssage
WHERE AuditTraitement_id = @AuditTraitement_id;

GO