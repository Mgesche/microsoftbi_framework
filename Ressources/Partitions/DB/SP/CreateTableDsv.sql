/* Exemple :

	EXECUTE [dbo].ClotureTraitement 1
	
	SELECT * FROM DSV.AuditPartition

*/
CREATE  PROCEDURE [dbo].CreateTableDsv 
    @id_Partition INTEGER

AS

DECLARE @strFact VARCHAR(50)
SET @strFact = (SELECT Fact FROM DSV.partitions WHERE id = @id_Partition);

DECLARE @strNomTable VARCHAR(50)
SET @strNomTable = @strFact + '_' + CAST(@id_Partition AS VARCHAR)

DECLARE @Query NVARCHAR(4000)

/* Creation de la table si elle n'existe pas */
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @strNomTable AND TABLE_SCHEMA = 'DSV')
BEGIN
	SET @Query = 'DROP TABLE DSV.'+@strNomTable
	EXECUTE sp_executesql @Query
END

/* Creation de la table */
SET @Query =		  'SELECT TOP 0 * '
SET @Query = @Query + 'INTO Dsv.'+@strNomTable+' '
SET @Query = @Query + 'FROM Dsv.'+@strFact+'_Struct'
	
EXECUTE sp_executesql @Query

GO