SELECT
	OBJ.name,
    FRA.object_id AS objectid,
    index_id AS indexid,
	index_type_desc,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') FRA
JOIN sys.all_objects OBJ
  ON OBJ.object_id = FRA.object_id
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0
ORDER BY OBJ.name;

/* Gestion des HEAP */
SELECT OBJECT_NAME(OBJECT_ID), index_id,index_type_desc,index_level,
avg_fragmentation_in_percent,avg_page_space_used_in_percent,page_count
FROM sys.dm_db_index_physical_stats
(DB_ID(), NULL, NULL, NULL , 'SAMPLED')
WHERE index_type_desc = 'HEAP'
  AND avg_fragmentation_in_percent > 10.0
ORDER BY avg_fragmentation_in_percent DESC