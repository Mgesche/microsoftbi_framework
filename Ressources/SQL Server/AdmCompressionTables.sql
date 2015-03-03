USE [BotanicDW_MEC]
GO

/****** Object:  StoredProcedure [dbo].[AdmCompressionTables]    Script Date: 07/31/2014 17:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[AdmCompressionTables]
	@Database varchar(50),
	@TailleMin int,
	@HeureMax int = 0,
	@MinutesMax int = 0,
	@TableSuivi varchar(50) = ''
AS
  /* =============================================================================== */
  /* Cette procédure compresse les tables au format PAGE                             */
  /* Attention : version Enterprise de SQL Server requise                            */
  /* On peux preciser une heure max pour lancer les ordres de compress si on veut    */
  /* limiter la charge machine. Par exemple, @HeureMax = 23 et @MinutesMax = 30      */
  /* signifie qu'un ordre de compression ne sera lancé aprés 23h30                   */
  /* On peux egalement specifier une table de suivi pour voir l'avancement des       */
  /* compress                                                                        */
  /*                                                                                 */
  /* @Database : Database sur laquelle les tables seront compressées                 */
  /* @TailleMin : Taille en dessous de laquelle les tables ne seront pas compressées */
  /* @HeureMax : Heure max pour les ordres de compression                            */
  /* @MinutesMax : Minute max pour les ordres de compression                         */
  /* @TableSuivi : Table ou seront stockée les table a compresser, elle sera purgé   */
  /* au prochain passage                                                             */
  /*																				 */
  /* =============================================================================== */
  
/*

*/

declare @sql varchar(4000)
declare @strTable varchar(100)
declare @strCompressSQL varchar(500)

/* Creation de la table de suivi */
IF @TableSuivi <> ''
BEGIN

IF NOT EXISTS(SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE table_name = @TableSuivi)
BEGIN
	SET @sql = 'CREATE TABLE '+@TableSuivi+ '(strTable varchar(100), strCompressSQL varchar(500), dtDebut DATETIME, dtFin DATETIME);';
	EXEC @sql;
END
ELSE
BEGIN
	SET @sql = 'TRUNCATE TABLE '+@TableSuivi;
	EXEC @sql;
END

END
ELSE
BEGIN
	CREATE TABLE #TableSuivi (strTable varchar(100), strCompressSQL varchar(500), dtDebut DATETIME, dtFin DATETIME);
END

/* Stockage des ordre de compress dans une table */
IF @TableSuivi <> ''
BEGIN
SET @sql =        'INSERT INTO '+@TableSuivi+' '
SET @sql = @sql + 'SELECT '
SET @sql = @sql + '    SCHEMA_NAME(OBJ.schema_id) + ''.'' + OBJECT_NAME(OBJ.object_id) AS [ObjectName], '
SET @sql = @sql + '    ''ALTER TABLE [''+SCHEMA_NAME(OBJ.schema_id)+''].[''+OBJECT_NAME(OBJ.object_id)+''] ''REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)'' AS Requete, '
SET @sql = @sql + '    NULL, '
SET @sql = @sql + '    NULL '
SET @sql = @sql + 'FROM sys.partitions PAR '
SET @sql = @sql + 'INNER JOIN sys.objects OBJ '
SET @sql = @sql + '   ON PAR.object_id = OBJ.object_id '
SET @sql = @sql + 'INNER JOIN sys.dm_db_partition_stats STA '
SET @sql = @sql + '  ON PAR.object_id = STA.object_id '
SET @sql = @sql + 'WHERE data_compression = 0 '
SET @sql = @sql + '  AND SCHEMA_NAME(OBJ.schema_id) <> ''SYS'' '
SET @sql = @sql + 'GROUP BY SCHEMA_NAME(OBJ.schema_id),OBJECT_NAME(OBJ.object_id) '
SET @sql = @sql + 'HAVING SUM(case when PAR.index_id < 2 then in_row_data_page_count+lob_used_page_count+row_overflow_used_page_count '
SET @sql = @sql + '                               else lob_used_page_count+row_overflow_used_page_count '
SET @sql = @sql + '        end) *8 > '+@TailleMin
EXEC @sql
END
ELSE
BEGIN
SET @sql =        'INSERT INTO #TableSuivi '
SET @sql = @sql + 'SELECT '
SET @sql = @sql + '    SCHEMA_NAME(OBJ.schema_id) + ''.'' + OBJECT_NAME(OBJ.object_id) AS [ObjectName], '
SET @sql = @sql + '    ''ALTER TABLE [''+SCHEMA_NAME(OBJ.schema_id)+''].[''+OBJECT_NAME(OBJ.object_id)+''] ''REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)'' AS Requete, '
SET @sql = @sql + '    NULL, '
SET @sql = @sql + '    NULL '
SET @sql = @sql + 'FROM sys.partitions PAR '
SET @sql = @sql + 'INNER JOIN sys.objects OBJ '
SET @sql = @sql + '   ON PAR.object_id = OBJ.object_id '
SET @sql = @sql + 'INNER JOIN sys.dm_db_partition_stats STA '
SET @sql = @sql + '  ON PAR.object_id = STA.object_id '
SET @sql = @sql + 'WHERE data_compression = 0 '
SET @sql = @sql + '  AND SCHEMA_NAME(OBJ.schema_id) <> ''SYS'' '
SET @sql = @sql + 'GROUP BY SCHEMA_NAME(OBJ.schema_id),OBJECT_NAME(OBJ.object_id) '
SET @sql = @sql + 'HAVING SUM(case when PAR.index_id < 2 then in_row_data_page_count+lob_used_page_count+row_overflow_used_page_count '
SET @sql = @sql + '                               else lob_used_page_count+row_overflow_used_page_count '
SET @sql = @sql + '        end) *8 > '+@TailleMin
EXEC @sql
END

/* Curseur */
DECLARE partition_cursor CURSOR FOR 
select DISTINCT strTable, strCompressSQL
from #TableSuivi
WHERE dtFin IS NULL;

OPEN partition_cursor

FETCH NEXT FROM partition_cursor 
INTO @strTable, @strCompressSQL

WHILE @@FETCH_STATUS = 0
BEGIN

	IF @TableSuivi <> ''
	BEGIN
		UPDATE #TableSuivi
		SET dtDebut = GETDATE()
		WHERE strTable = @strTable;
	END
	ELSE
	BEGIN
		SET @sql =        'UPDATE '+@TableSuivi+' '
		SET @sql = @sql + 'SET dtDebut = GETDATE() '
		SET @sql = @sql + 'WHERE strTable = @strTable; '
	END
	
	IF (@HeureMax <> 0 OR @MinutesMax <> 0)
	BEGIN
		SET @sql =        'if not exists(select 1 WHERE (DATEPART(hh, GETDATE()) > '+@HeureMax-1+ ' '
		SET @sql = @sql + ' AND DATEPART(mi, GETDATE()) > '+@MinutesMax+') OR (DATEPART(hh, GETDATE()) > '+@HeureMax+')) '
		SET @sql = @sql + 'BEGIN '
		SET @sql = @sql + @strCompressSQL + ' '
		SET @sql = @sql + 'END '
		SET @sql = @sql + 'GO '
		EXEC @sql
	END
	ELSE
	BEGIN
		SET @sql = @strCompressSQL + ' '
		SET @sql = @sql + 'GO '
		EXEC @sql
	END
	
	IF @TableSuivi <> ''
	BEGIN
		UPDATE #TableSuivi
		SET dtFin = GETDATE()
		WHERE strTable = @strTable;
	END
	ELSE
	BEGIN
		SET @sql =        'UPDATE '+@TableSuivi+' '
		SET @sql = @sql + 'SET dtFin = GETDATE() '
		SET @sql = @sql + 'WHERE strTable = @strTable; '
	END
		
    FETCH NEXT FROM partition_cursor 
	INTO @strTable, @strCompressSQL
	
END 
CLOSE partition_cursor;
DEALLOCATE partition_cursor;


GO


