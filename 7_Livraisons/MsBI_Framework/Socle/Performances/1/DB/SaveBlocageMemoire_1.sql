/*
USE [BI_FMK]

EXEC	[Adm].[SaveBlocageMemoire]

*/
CREATE PROCEDURE [Adm].[SaveBlocageMemoire] AS 
BEGIN 

	INSERT INTO Perf_BlocageMemoire
	SELECT 	GETDATE() AS DtCreation,
			resource_semaphore_id as idTypeRequete,
			SUM(waiter_Count) as Nb_Requete_Attente, 
			SUM(grantee_count) AS Nb_Requete_Pourvue,
			SUM(available_memory_kb) AS Memoire_Dispo,
			SUM(granted_memory_kb) AS Memoire_Alloue,
			SUM(used_memory_kb) AS Memoire_Utilisee
	FROM sys.dm_exec_query_resource_semaphores
	GROUP BY resource_semaphore_id

END