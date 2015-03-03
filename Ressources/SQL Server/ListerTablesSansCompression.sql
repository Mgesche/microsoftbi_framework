/* Quelques remarques */
/* Seulement disponible dans la version Enterprise */
/* Page compression (remplacer les données recurentes par des pointeur sur une instance unique) inclut row compression (supprimer les espaces dans les types de donénes fixes comme CHAR(50) */
/* Page coute plus de CPU que ROW */
/* Si peu de gain, prendre plutot ROW */
/* La compression coute du CPU et de l'ecriture disque mais economise IO, temps de requetes et espace disque. A voir ce qu'on veux privilegier */

/* Lister tables sans compressions d'une taille > 10 Mo */
SELECT
    SCHEMA_NAME(OBJ.schema_id) AS [SchemaName]
   ,OBJECT_NAME(OBJ.object_id) AS [ObjectName]
   ,SUM(case when PAR.index_id < 2 then in_row_data_page_count+lob_used_page_count+row_overflow_used_page_count
                               else lob_used_page_count+row_overflow_used_page_count
        end) *8 AS Taille
   ,SUM([rows]) AS Nb_Lignes
   ,[data_compression_desc]
   ,'ALTER TABLE ['+SCHEMA_NAME(OBJ.schema_id)+'].['+OBJECT_NAME(OBJ.object_id)+'] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)' AS Requete
FROM sys.partitions PAR
INNER JOIN sys.objects OBJ
   ON PAR.object_id = OBJ.object_id
INNER JOIN sys.dm_db_partition_stats STA
  ON PAR.object_id = STA.object_id
WHERE data_compression = 0
  AND SCHEMA_NAME(OBJ.schema_id) <> 'SYS'
GROUP BY SCHEMA_NAME(OBJ.schema_id), OBJECT_NAME(OBJ.object_id), [data_compression_desc]
HAVING SUM(case when PAR.index_id < 2 then in_row_data_page_count+lob_used_page_count+row_overflow_used_page_count
                               else lob_used_page_count+row_overflow_used_page_count
        end) *8 > 10000
ORDER BY 3 desc;

/* Prévoir StoreProc pour lancer la compression */

/* Voir idem pour les indexes */
SELECT
    SCHEMA_NAME(OBJ.schema_id) AS [SchemaName]
   ,OBJECT_NAME(OBJ.object_id) AS [ObjectName]
   ,IND.Name
   ,SUM(case when PAR.index_id < 2 then in_row_data_page_count+lob_used_page_count+row_overflow_used_page_count
                               else lob_used_page_count+row_overflow_used_page_count
        end) *8 AS Taille
   ,SUM([rows]) AS Nb_Lignes
   ,[data_compression_desc]
   ,'ALTER TABLE ['+SCHEMA_NAME(OBJ.schema_id)+'].['+OBJECT_NAME(OBJ.object_id)+'] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)' AS Requete
FROM sys.partitions PAR
INNER JOIN sys.objects OBJ
   ON PAR.index_id = OBJ.object_id
INNER JOIN sys.indexes IND
   ON PAR.index_id = IND.object_id
INNER JOIN sys.dm_db_partition_stats STA
  ON PAR.object_id = STA.object_id
WHERE data_compression = 0
  AND SCHEMA_NAME(OBJ.schema_id) <> 'SYS'
GROUP BY SCHEMA_NAME(OBJ.schema_id), OBJECT_NAME(OBJ.object_id), IND.Name, [data_compression_desc]
HAVING SUM(case when PAR.index_id < 2 then in_row_data_page_count+lob_used_page_count+row_overflow_used_page_count
                               else lob_used_page_count+row_overflow_used_page_count
        end) *8 > 10000
ORDER BY 3 desc;
