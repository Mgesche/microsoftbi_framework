/* Exemple :

	DECLARE @AuditTraitement_id int
	EXECUTE [dbo].initTraitement @AuditTraitement_id OUTPUT, 1, 'DOMAINE\User'
	
	SELECT @AuditTraitement_id

*/
IF object_id(N'DSV.initTraitement ', N'P') IS NOT NULL
    DROP PROCEDURE DSV.initTraitement 
GO

CREATE PROCEDURE [DSV].initTraitement 
    @AuditTraitement_id INTEGER OUTPUT
,	@id_Partition INTEGER  
,	@StrUser VARCHAR(50)

AS

INSERT INTO DSV.AuditPartition (
	id_Partition,
	id_Etape,
	DtDebut,
	StrUser
)
VALUES (
	@id_Partition,
	1,
	CURRENT_TIMESTAMP,
	@StrUser
);

SET @AuditTraitement_id = @@IDENTITY;

GO