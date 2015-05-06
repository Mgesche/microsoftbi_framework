/* Exemple 

  EXECUTE [Utils].[copieIndex] 'dbo', 'DSVDebitFamille', 'DSV', 'DSVDebitFamille_STRUCT'

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

DECLARE @Ind_name VARCHAR(50)
DECLARE @Ind_fill_factor INT
DECLARE @Ind_Type_Desc VARCHAR(50)

DECLARE @Col_Liste VARCHAR(500)
DECLARE @Col_name VARCHAR(50)
DECLARE @Col_isDescending INT

DECLARE ind_cursor CURSOR FOR 
SELECT ind.name, ind.fill_factor, 
CASE WHEN ind.Type_Desc = 'CLUSTERED' THEN 'CLUSTERED' ELSE
CASE WHEN ind.Type_Desc = 'NONCLUSTERED' THEN 'NONCLUSTERED' END END AS Type_Desc
FROM sys.indexes ind 
JOIN sys.tables tab
  ON ind.object_id = tab.object_id 
JOIN sys.schemas sch 
  ON sch.schema_id = tab.schema_id 
WHERE tab.name = @TableNameOrigine
  AND sch.name = @SchemaNameOrigine

/*
DECLARE ind_cursor CURSOR FOR 
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
  */

OPEN ind_cursor

FETCH NEXT FROM ind_cursor 
INTO @Ind_name, @Ind_fill_factor, @Ind_Type_Desc

WHILE @@FETCH_STATUS = 0
BEGIN

  SET @Col_Liste = ''
  
  DECLARE col_cursor CURSOR FOR
  SELECT col.name, ind_col.is_descending_key
  FROM sys.indexes ind 
  JOIN sys.index_columns ind_col 
    ON ind.object_id = ind_col.object_id 
   AND ind.index_id = ind_col.index_id
  JOIN sys.columns COL
    ON ind_col.object_id = COL.object_id 
   AND ind_col.column_id = COL.column_id 
  WHERE IND.name = @Ind_name
  ORDER BY ind_col.key_ordinal
  
  OPEN col_cursor

  FETCH NEXT FROM col_cursor 
  INTO @Col_name, @Col_isDescending
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
    
    SET @Col_Liste = @Col_Liste + @Col_name + ' ' + CASE WHEN @Col_isDescending = 1 THEN 'DESC' ELSE 'ASC' END + ', '
    
    FETCH NEXT FROM col_cursor 
    INTO @Col_name, @Col_isDescending
    
  END
  
  CLOSE col_cursor
  DEALLOCATE col_cursor
 
  SET @Col_Liste = SUBSTRING(@Col_Liste, 1, LEN(@Col_Liste)-1)

  SET @Query = 'CREATE '+@Ind_Type_Desc+' INDEX ['+@Ind_name+'] ON ['+@SchemaNameDestination+'].['+@TableNameDestination+'] ('+@Col_Liste+') WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = '+CAST(@Ind_fill_factor as VARCHAR)+') ON [PRIMARY]'

  EXECUTE sp_executesql @Query
  
  FETCH NEXT FROM ind_cursor 
  INTO @Ind_name, @Ind_fill_factor, @Ind_Type_Desc
  
END

CLOSE ind_cursor
DEALLOCATE ind_cursor

RETURN 0

GO