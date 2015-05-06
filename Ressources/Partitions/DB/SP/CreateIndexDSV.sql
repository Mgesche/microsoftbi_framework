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

DECLARE @strNomTable VARCHAR(100)
SET @strNomTable = @strFact + '_' + CAST(@id_Partition AS VARCHAR)

DECLARE @strNomTableStruct VARCHAR(100)
SET @strNomTableStruct = @strNomTable+'_Struct'

EXECUTE [Utils].[copieIndex] 'DSV', @strNomTableStruct, 'DSV', @strNomTable

GO