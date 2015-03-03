select 
db_name(ddmid.database_id) as databasename,
object_name(ddmid.object_id,ddmid.database_id) as TableName,
ddmid.equality_columns,
ddmid.inequality_columns,
ddmid.statement,
ddmid.included_columns,
ddmigs.avg_total_user_cost,ddmigs.avg_user_impact,ddmigs.user_seeks,ddmigs.user_scans,
ddmigs.last_user_scan,ddmigs.last_user_seek,
ddmigs.unique_compiles,
'CREATE NONCLUSTERED INDEX WRK_'+ddmid.statement+'_'+ddmid.included_columns+' ON '+ddmid.statement+' ('+ddmid.equality_columns+') INCLUDE ('+ddmid.included_columns+');' AS Requete
into #missingindexes
from 
sys.dm_db_missing_index_group_stats ddmigs
inner join sys.dm_db_missing_index_groups  ddmig
on ddmigs.group_handle = ddmig.index_group_handle
inner join sys.dm_db_missing_index_details ddmid
on ddmig.index_handle = ddmid.index_handle

SET STATISTICS IO ON
SET STATISTICS TIME ON

/* Ajouter la requete */
SELECT TOP 1000000 ID_ANNEE, IDT_FINESS, IDT_RSA, ID_DIAG_KEY
FROM (
SELECT  RSA.ID_ANNEE, RSA.IDT_FINESS, RSA.IDT_RSA, DIA.ID_DIAG_ASSOCIE AS ID_DIAG
FROM F_PMSI_MCO_DIAG DIA
JOIN F_PMSI_MCO_RSA RSA
  ON DIA.IDT_PMSI_MCO = RSA.IDT_PMSI_MCO
WHERE RSA.ID_DAS = -1
) RES
JOIN F_PMSI_MCO_RSA_DIAG_INT INT
ON RES.ID_DIAG = INT.ID_DIAG
ORDER BY ID_ANNEE, IDT_FINESS, IDT_RSA, ID_DIAG_KEY

UPDATE F_PMSI_MCO_RSA
SET ID_DAS = [F_PMSI_MCO_RSA_DAS_MTX_Lookup].MATRIX_KEY
FROM [F_PMSI_MCO_RSA_DAS_MTX_Lookup]
WHERE F_PMSI_MCO_RSA.ID_ANNEE = [F_PMSI_MCO_RSA_DAS_MTX_Lookup].ID_ANNEE
  AND F_PMSI_MCO_RSA.IDT_FINESS = [F_PMSI_MCO_RSA_DAS_MTX_Lookup].IDT_FINESS
  AND F_PMSI_MCO_RSA.IDT_RSA = [F_PMSI_MCO_RSA_DAS_MTX_Lookup].IDT_RSA;

SET STATISTICS IO OFF
SET STATISTICS TIME OFF

select 
db_name(ddmid.database_id) as databasename,
object_name(ddmid.object_id,ddmid.database_id) as TableName,
ddmid.equality_columns,
ddmid.inequality_columns,
ddmid.statement,
ddmid.included_columns,
ddmigs.avg_total_user_cost,ddmigs.avg_user_impact,ddmigs.user_seeks,ddmigs.user_scans,
ddmigs.last_user_scan,ddmigs.last_user_seek,
ddmigs.unique_compiles,
'CREATE NONCLUSTERED INDEX WRK_'+ddmid.statement+'_'+ddmid.included_columns+' ON '+ddmid.statement+' ('+ddmid.equality_columns+') INCLUDE ('+ddmid.included_columns+');' AS Requete

from 
sys.dm_db_missing_index_group_stats ddmigs
inner join sys.dm_db_missing_index_groups  ddmig
on ddmigs.group_handle = ddmig.index_group_handle
inner join sys.dm_db_missing_index_details ddmid
on ddmig.index_handle = ddmid.index_handle
except
select * from #missingindexes