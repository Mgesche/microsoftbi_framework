DECLARE @DBName VARCHAR(100)  
DECLARE @TableName VARCHAR(100)  
--If this line is commented in, the missing index list will only contain  
--missing indexes for the given database  
--SET @DBName = 'MyDatabase'  
--SET @TableName = 'MyTable'  
;WITH CTE  
AS  
(  
SELECT  
DB_NAME(d.database_id) AS DatabaseName,  
user_seeks,  
user_scans,  
avg_total_user_cost,  
avg_user_impact,  
d.equality_columns,  
d.inequality_columns,  
d.included_columns,  
'USE ' + DB_NAME(d.database_id) + '; CREATE NONCLUSTERED INDEX IX_' +  
replace(replace(replace(replace(isnull(equality_columns, '') +  
isnull(inequality_columns, ''), ',', '_'), '[', ''),']', ''), ' ', '') +  
CASE WHEN included_columns IS NOT NULL  
THEN '_INC_' + replace(replace(replace(replace(included_columns, ',', '_'), '[', ''),']', ''), ' ', '')  
ELSE '' END + ' ON ' + statement + ' (' +  
CASE  
WHEN equality_columns IS NOT NULL AND inequality_columns IS NOT NULL  
THEN equality_columns + ', ' + inequality_columns  
WHEN equality_columns IS NOT NULL AND inequality_columns IS NULL  
THEN equality_columns  
WHEN equality_columns IS NULL AND inequality_columns IS NOT NULL  
THEN inequality_columns  
END + ')' +  
CASE WHEN included_columns IS NOT NULL THEN ' INCLUDE (' +  
replace(replace(replace(included_columns, '[', ''),']', ''), ' ', '') + ')'  
ELSE '' END +  
CASE WHEN @@Version LIKE '%Enterprise%' THEN ' WITH (ONLINE = ON)'  
ELSE '' END AS CreateIndex  
FROM  
sys.dm_db_missing_index_groups g  
INNER JOIN sys.dm_db_missing_index_group_stats gs on gs.group_handle = g.index_group_handle  
INNER JOIN sys.dm_db_missing_index_details d on g.index_handle = d.index_handle  
WHERE  
(DB_NAME(d.database_id) = @DBName  
OR @DBName IS NULL)  
)  
SELECT * FROM CTE  
WHERE CreateIndex LIKE '%'+@TableName+'%' OR @TableName IS NULL  
ORDER BY user_seeks DESC  