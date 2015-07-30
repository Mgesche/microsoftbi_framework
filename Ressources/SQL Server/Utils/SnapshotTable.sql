/* Exemple 

  EXECUTE [Utils].[SnapshotTable] 'dbo', 'DSVDebitFamille'

*/
IF object_id(N'Utils.SnapshotTable', N'P') IS NOT NULL
    DROP PROCEDURE Utils.SnapshotTable
GO

CREATE PROCEDURE [Utils].[SnapshotTable](
	@SchemaNameOrigine  VARCHAR(50), 
	@TableNameOrigine  VARCHAR(50), 
	@Debug int = 0
)
AS

DECLARE @Query NVARCHAR(MAX)

DECLARE @strNomTable VARCHAR(255)
DECLARE @strNomTableSnapshot VARCHAR(255)
DECLARE @strDateJour VARCHAR(10)

SET @strDateJour = (SELECT CAST(Utils.DateToInt(GETDATE()) AS VARCHAR))
SET @strNomTable = @SchemaNameOrigine + '.' + @TableNameOrigine
SET @strNomTableSnapshot = @strNomTable + '_' + @strDateJour

SET @Query = 'IF object_id(N'''+@strNomTableSnapshot+''', N''U'') IS NOT NULL BEGIN DROP TABLE '+@strNomTableSnapshot+' END'

IF @Debug = 1
BEGIN
  print @Query
END
ELSE
BEGIN
  EXECUTE sp_executesql @Query
END

SET @Query = 'SELECT * INTO '+@strNomTableSnapshot+' FROM '+@strNomTable

IF @Debug = 1
BEGIN
  print @Query
END
ELSE
BEGIN
  EXECUTE sp_executesql @Query
END

RETURN 0

GO