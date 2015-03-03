DECLARE @SQL NVARCHAR(max) 
SET @SQL = '' 
 
SELECT @SQL = @SQL + 
       'CREATE INDEX X_' + REPLACE(CAST(NEWID() AS VARCHAR(64)), '-', '_') 
       + ' ON ' + statement +' ('  
       + CASE WHEN equality_columns IS NOT NULL  
                   AND inequality_columns IS NOT NULL  
                 THEN equality_columns + ', ' + inequality_columns 
              WHEN equality_columns IS NOT NULL THEN equality_columns 
              WHEN inequality_columns IS NOT NULL THEN inequality_columns 
         END  + ') '  
       + CASE WHEN included_columns IS NOT NULL 
              THEN ' INCLUDE (' + included_columns +') ' 
         END 
       + ';'  
FROM   sys.dm_db_missing_index_details m 
 
PRINT(@SQL);