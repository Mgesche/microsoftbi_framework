/* Exemple :

	EXECUTE [dbo].CreateIndexDsv 1
	
*/
IF object_id(N'DSV.CreateIndexDsv', N'P') IS NOT NULL
    DROP PROCEDURE DSV.CreateIndexDsv
GO

CREATE  PROCEDURE [dbo].CreateIndexDsv 
    @id_Partition INTEGER

AS

DECLARE @strFact VARCHAR(50)
SET @strFact = (SELECT Fact FROM DSV.partitions WHERE id = @id_Partition);

DECLARE @strNomTable VARCHAR(50)
SET @strNomTable = @strFact + '_' + CAST(@id_Partition AS VARCHAR)

EXECUTE [Utils].[copieIndex]('DSV', @strNomTable+'_Struct', 'DSV', @strNomTable)

GO