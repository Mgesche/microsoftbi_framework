WITH 
TD AS (SELECT  create_date AS DEPUIS 
       FROM    sys.databases 
       WHERE   database_id = DB_ID('tempdb')), 
       idc AS (SELECT ic.object_id, index_id,  
               ROW_NUMBER() OVER(PARTITION BY ic.object_id, index_id, is_included_column 
                                 ORDER BY index_column_id) AS index_column_id, 
               is_included_column,  
               c.name, CASE WHEN is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END AS ord 
        FROM   sys.index_columns AS ic 
               INNER JOIN sys.columns AS c 
                     ON ic.object_id = c.object_id 
                        AND ic.column_id = c.column_id), 
idk AS (SELECT object_id, index_id,  index_column_id, 1 as cols, 
               CAST('[' + name + '] ' + ord AS NVARCHAR(max)) AS KEY_DEF 
        FROM   idc        
        WHERE  is_included_column = 0 
          AND  index_column_id = 1 
        UNION ALL 
        SELECT idc.object_id, idc.index_id, idc.index_column_id, cols + 1, 
               KEY_DEF + ', ' + '[' + idc.name + '] ' + ord 
        FROM   idc 
               INNER JOIN idk 
                     ON idc.object_id = idk.object_id AND 
                     idc.index_id = idk.index_id AND 
                     idc.index_column_id = idk.index_column_id + 1 
        WHERE  idc.is_included_column = 0), 
idi AS (SELECT object_id, index_id,  index_column_id, 1 as coli, 
               CAST('[' + name + '] ' + ord AS NVARCHAR(max)) AS COL_DEF 
        FROM   idc        
        WHERE  is_included_column = 1 
          AND  index_column_id = 1 
        UNION ALL 
        SELECT idc.object_id, idc.index_id, idc.index_column_id, coli + 1, 
               COL_DEF + ', ' + '[' +  idc.name + '] ' + ord 
        FROM   idc 
               INNER JOIN idi 
                     ON idc.object_id = idi.object_id AND 
                     idc.index_id = idi.index_id AND 
                     idc.index_column_id = idi.index_column_id + 1 
        WHERE  idc.is_included_column = 1), 
dfi AS (SELECT idk.*, COL_DEF,  
               ROW_NUMBER() OVER(PARTITION BY idk.object_id, idk.index_id  
                                 ORDER BY cols DESC) AS N 
        FROM   idk 
               LEFT OUTER JOIN idi 
                    ON idk.object_id = idi.object_id 
                       AND idk.index_id = idi.index_id), 
dfj AS (SELECT dfi.object_id, dfi.index_id, 
               KEY_DEF AS KEY_COLUMNS, 
               COL_DEF AS INCLUDED_COLUMNS, i.filter_definition AS FILTER, 
               'CREATE INDEX [' + i.name + '] + ON [' + o.name +'].[' + s.name 
               +'] (' + KEY_DEF +')'  
               + COALESCE(' INCLUDE (' + COL_DEF + ')', '') 
               + COALESCE(' WHERE (' + i.filter_definition + ')', '') + ';' AS LOGICAL_DEFINITION                       
        FROM   dfi 
               INNER JOIN sys.indexes AS i 
                     ON dfi.object_id = i.object_id 
                        AND dfi.index_id = i.index_id 
               INNER JOIN sys.objects AS o 
                     ON i.object_id = o.object_id 
               INNER JOIN sys.schemas AS s 
                     ON o.schema_id = s.schema_id 
WHERE  N = 1)               
SELECT DEPUIS, s.name AS TABLE_SCHEMA, o.name AS TABLE_NAME, i.name AS INDEX_NAME, 
       user_seeks, user_scans, user_lookups, user_updates, 
       KEY_COLUMNS, INCLUDED_COLUMNS, FILTER, LOGICAL_DEFINITION 
FROM   sys.dm_db_index_usage_stats AS ius 
       CROSS JOIN TD 
       INNER JOIN sys.indexes AS i 
             ON ius.object_id = i.object_id 
                AND ius.index_id = i.index_id 
       INNER JOIN sys.objects AS o 
             ON i.object_id = o.object_id 
       INNER JOIN sys.schemas AS s 
             ON o.schema_id = s.schema_id 
       LEFT OUTER JOIN dfj 
             ON dfj.object_id = i.object_id 
                AND dfj.index_id = i.index_id                       
WHERE  database_id = DB_ID() 
  AND  i.index_id > 1 
  AND  user_seeks = 0 
  AND  user_scans = 0 
  AND  user_lookups = 0 
  AND  is_unique = 0 
  AND  is_primary_key = 0 
  AND  is_unique_constraint = 0 
ORDER BY user_updates, i.index_id DESC;