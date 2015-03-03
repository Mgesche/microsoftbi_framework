USE [BotanicDW_MEC]
GO

/****** Object:  StoredProcedure [dbo].[ActiveAllIndex]    Script Date: 11/24/2014 10:27:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ActiveAllIndex] (@SchemaName varchar(50), @TableName varchar(50), @Debug int = 0)
AS
  /* ===================================================================================== */
  /* Cette procédure reactive tout les index d'une table.                                  */
  /* DesctiveAllIndex permet de les desactiver. Surtout utile pour un trucate insert       */
  /*                                                                                       */
  /* @SchemaName : Schema de la table sur laquelle on reactive les index                   */
  /* @TableName : Table sur laquelle on reactive les index                                 */
  /* @Debug : 1 pour PRINT les requetes et 0 pour EXEC                                     */
  /*																		 		       */
  /* ===================================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@Return varchar(100)

EXEC	@Return = [dbo].[ActiveAllIndex] @SchemaName = 'dbo', @TableName = 'DSVLigneTicketCRM', @Debug = 1

SELECT	'Return Value' = @Return

GO
*/
BEGIN

DECLARE @query NVARCHAR(200)
 
DECLARE curseur_index CURSOR FOR
	SELECT N'ALTER INDEX ['+ind.name+'] ON '+sch.name+'.'+tab.name+' REBUILD' as query
	FROM sys.indexes ind 
	JOIN sys.tables tab
	  ON ind.object_id = tab.object_id 
	LEFT JOIN sys.schemas sch 
	  ON sch.schema_id = tab.schema_id 
	WHERE tab.name = @TableName
	  AND sch.name = @SchemaName
	  AND ind.Type_Desc <> 'CLUSTERED'
 
OPEN curseur_index
 
FETCH curseur_index INTO @query
 
WHILE @@FETCH_STATUS = 0
BEGIN

	/* Gestion Debug */
	IF @Debug = 0
	BEGIN
		EXEC sp_executesql @query;
	END
	ELSE
	BEGIN
		PRINT @query;
	END

	FETCH curseur_index INTO @query
END
 
CLOSE curseur_index
DEALLOCATE curseur_index

RETURN 0;

END
GO


