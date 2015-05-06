/* Exemple 

  EXECUTE [Utils].[copieIndex]('dbo', 'partitions', 'DSV', 'partitions)

*/
IF object_id(N'Utils.copieIndex', N'P') IS NOT NULL
    DROP PROCEDURE Utils.copieIndex
GO

CREATE PROCEDURE [Utils].[copieIndex](
	@SchemaNameOrigine  VARCHAR(50), 
  @TableNameOrigine  VARCHAR(50), 
	@SchemaNameDestination  VARCHAR(50), 
  @TableNameDestination  VARCHAR(50)
)
AS

DECLARE @Query NVARCHAR(MAX)

DECLARE req_cursor CURSOR FOR 
SELECT 'CREATE CLUSTERED INDEX ['+ind.name+'] ON ['+@SchemaNameDestination+'].['+@TableNameDestination+'] (['+col.name+'] '+CASE WHEN ind_col.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END +')WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = '+CAST(ind.fill_factor as VARCHAR)+') ON [PRIMARY]' as requete
FROM sys.indexes ind 
JOIN sys.index_columns ind_col 
  ON ind.object_id = ind_col.object_id 
 AND ind.index_id = ind_col.index_id
JOIN sys.columns COL
  ON ind_col.object_id = COL.object_id 
 AND ind_col.column_id = COL.column_id
JOIN sys.tables tab
  ON ind.object_id = tab.object_id 
JOIN sys.schemas sch 
  ON sch.schema_id = tab.schema_id 
WHERE tab.name = @TableNameDestination
  AND sch.name = @SchemaNameOrigine
  AND ind.Type_Desc = 'CLUSTERED'
UNION
SELECT 'CREATE NONCLUSTERED INDEX ['+ind.name+'] ON ['+@SchemaNameDestination+'].['+@TableNameDestination+'] (['+col.name+'] '+CASE WHEN ind_col.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END +')WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = '+CAST(ind.fill_factor as VARCHAR)+') ON [PRIMARY]' as requete
FROM sys.indexes ind 
JOIN sys.index_columns ind_col 
  ON ind.object_id = ind_col.object_id 
 AND ind.index_id = ind_col.index_id
JOIN sys.columns COL
  ON ind_col.object_id = COL.object_id 
 AND ind_col.column_id = COL.column_id
JOIN sys.tables tab
  ON ind.object_id = tab.object_id 
JOIN sys.schemas sch 
  ON sch.schema_id = tab.schema_id 
WHERE tab.name = @TableNameDestination
  AND sch.name = @SchemaNameOrigine
  AND ind.Type_Desc = 'NONCLUSTERED'

OPEN req_cursor

FETCH NEXT FROM req_cursor 
INTO @Query

WHILE @@FETCH_STATUS = 0
BEGIN
  
  EXECUTE sp_executesql @Query
  
  FETCH NEXT FROM req_cursor 
  INTO @Query
  
END

CLOSE req_cursor
DEALLOCATE req_cursor

RETURN 0

GO