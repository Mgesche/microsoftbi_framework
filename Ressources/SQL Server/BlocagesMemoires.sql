/* Bilan des blocages memoires */
SELECT	CASE WHEN resource_semaphore_id = 0 THEN 'Grosses requetes (>5MB)' ELSE 'Petites requetes' END AS Type_Requete,
		SUM(waiter_Count) as Nb_Requete_Attente, SUM(grantee_count) AS Nb_Requete_Pourvue,
		SUM(available_memory_kb)/1000 AS Memoire_Dispo,
		CASE WHEN SUM(granted_memory_kb) <> 0 
			 THEN CAST(CAST(SUM(used_memory_kb)*100 as decimal(18,2))/CAST(SUM(granted_memory_kb) as decimal(18,2)) as decimal(18,2))
			 ELSE 0 END AS Pourcent_Utilise
FROM sys.dm_exec_query_resource_semaphores
GROUP BY resource_semaphore_id

/* Detail des requetes en attentes */
select req.text AS Requete, Requested_memory_kb/1000 as Memoire_necessaire,
	   Query_cost as Cout, wait_order as ordre_file_attente
from sys.dm_exec_query_memory_grants MEM
CROSS APPLY sys.dm_exec_sql_text(MEM.sql_handle) AS req
WHERE grant_time IS NULL
ORDER BY wait_order