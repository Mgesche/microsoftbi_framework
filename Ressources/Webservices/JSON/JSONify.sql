IF object_id(N'Utils.JSONify', N'P') IS NOT NULL
    DROP PROCEDURE Utils.JSONify;
GO

CREATE PROCEDURE [Utils].[JSONify](
	@Request     VARCHAR(MAX),
  @ListColonne VARCHAR(MAX)
)
as
  /* =============================================================================== */
  /* Renvois le resultat de la requete au format JSON                                */
  /*                                                                                 */
  /* @Request : Requete origine des donnees                                          */
  /* @ListColonne : Liste des colonnes du resultat, separé par des ','               */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

EXEC [BotanicDW_MEC].[Utils].[JSONify] 'SELECT TOP 10 Fact, StartD FROM dbo.partitions', 'Fact, StartD';

GO
*/
BEGIN
  
  DECLARE @Result VARCHAR(MAX)
  
  DECLARE @Query NVARCHAR(MAX)
  SET @Query = 'SELECT ''{'' UNION ALL '
  SET @Query = @Query + 'SELECT CASE WHEN RANK() OVER (ORDER BY '+@ListColonne+') = 1 THEN '''' ELSE '','' END + '
  SET @Query = @Query + '''['
  
  -- Decomposition de la liste des colonnes
  DECLARE @Item VARCHAR(50)
  DECLARE cur_ListColonne CURSOR FOR 
  SELECT Item FROM [Utils].[StringToTable](@ListColonne, ',')
  
  OPEN cur_ListColonne
  
  FETCH NEXT FROM cur_ListColonne 
  INTO @item

  WHILE @@FETCH_STATUS = 0
  BEGIN
    
    SET @Query = @Query + '"' + @item + '" : "''+CAST(' + @item + ' AS VARCHAR) + ''", '

    FETCH NEXT FROM cur_ListColonne 
    INTO @item
  
  END 
  CLOSE cur_ListColonne;
  DEALLOCATE cur_ListColonne;
  
  SET @Query = SUBSTRING(@Query, 0, LEN(@Query)-2)
  SET @Query = @Query + '''"] '' FROM ('+@Request+') RES UNION ALL SELECT ''}'''

  EXECUTE sp_executesql @Query

  RETURN 0

END

GO