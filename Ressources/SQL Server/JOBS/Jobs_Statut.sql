USE [BotanicDW_MEC]
GO

/****** Object:  UserDefinedFunction [dbo].[Jobs_Statut]    Script Date: 06/16/2015 10:01:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ===================================================================
-- Lister les jobs actifs ou non et recuperation de leurs informations
-- ===================================================================
ALTER FUNCTION [dbo].[Jobs_Statut]()
RETURNS TABLE 
AS
RETURN 
(

SELECT 	DISTINCT JOB.name as Nom,
		CASE CAT.name WHEN '[Uncategorized (Local)]' THEN 'Aucune' ELSE CAT.name END AS Categorie,
		CASE WHEN JOB.enabled = 0 THEN 'Inactif' ELSE
		CASE WHEN SCE.enabled = 0 THEN 'Non planifi�' ELSE
		CASE HIS_STT.last_run_status
			WHEN 0 THEN 'Succ�s'
			WHEN 1 THEN 'Reprise'
			WHEN 2 THEN 'Annulation'
			WHEN 3 THEN '�chec' 
			ELSE 'Inconnu' 
		END END END as Job_Status,
		CASE WHEN JOB.enabled = 1 AND SCE.enabled = 1 AND HIS_STT.last_run_status <> 0 THEN HIS_STT.message ELSE NULL END as Job_Message,
		LEFT(CAST(DATEADD("s", HIS_TPS.run_duration*3600, 0) as time), 8) AS Duree_Moyenne,
		CASE SCE.freq_type 
			WHEN 1 THEN 'Unique'
			WHEN 4 THEN 'Quotidien'
			WHEN 8 THEN 'Hebdomadaire'
			WHEN 16 THEN 'Mensuel'
			WHEN 32 THEN 'Mensuel relatif'
			WHEN 64 THEN 'Au d�marrage de SQL Agent'
			WHEN 128 THEN 'D�marre quand le CPU est inactif'
		END AS Frequence,
		CASE SCE.freq_type 
			WHEN 1 THEN 'Une fois seulement' 
			WHEN 4 THEN 'Tous les ' + CASE CONVERT(varchar, SCE.freq_interval) WHEN '1' THEN 'jour' ELSE 'jours' END 
			WHEN 8 THEN 'Tous les ' + CASE CONVERT(varchar, SCE.freq_recurrence_factor) WHEN '1' THEN 'semaine' ELSE 'semaines' END + ' le ' + JOU.freq_day_concat 
			WHEN 16 THEN 'Jour ' + CONVERT(varchar, SCE.freq_interval) + ' de chaque ' 
					+ CASE CONVERT(varchar, SCE.freq_recurrence_factor) WHEN '1' THEN ' mois' ELSE ' mois' END 
			WHEN 32 THEN 'Le ' + CASE SCE.freq_relative_interval 
					WHEN 1 THEN 'premier' 
					WHEN 2 THEN 'deuxi�me' 
					WHEN 4 THEN 'troisi�me' 
					WHEN 8 THEN 'quatri�me' 
					WHEN 16 THEN 'dernier' 
			END + ' ' + CASE SCE.freq_interval 
					WHEN 1 THEN 'Dimanche' 
					WHEN 2 THEN 'Lundi' 
					WHEN 3 THEN 'Mardi' 
					WHEN 4 THEN 'Mercredi' 
					WHEN 5 THEN 'Jeudi' 
					WHEN 6 THEN 'Vendredi' 
					WHEN 7 THEN 'Samedi' 
					WHEN 8 THEN 'Jour' 
					WHEN 9 THEN 'Jour de la semaine' 
					WHEN 10 THEN 'Jour du WE' 
			END + ' de chaque ' + CASE CONVERT(varchar, SCE.freq_recurrence_factor) WHEN '1' THEN ' mois' ELSE ' mois' END END + 
			CASE SCE.freq_subday_type 
					WHEN 1 THEN ', une fois, a ' + AT.start_time 
					WHEN 2 THEN ', chaque ' + CONVERT(varchar(10), SCE.freq_subday_interval) 
							+ ' secondes, a partir de ' + AT.start_time 
							+ ' terminant a '  + AT.end_time 
					WHEN 4 THEN ', chaque ' + CONVERT(varchar(10), SCE.freq_subday_interval) + ' minutes, a partir de ' 
							+ AT.start_time + ', jusqu''a ' + AT.end_time 
					WHEN 8 THEN ', chaque ' + CONVERT(varchar(10), SCE.freq_subday_interval) + ' heures, a partir de ' 
							+ AT.start_time + ', jusqu''a ' + AT.end_time 
		END AS Frequence_Detail,
		CASE WHEN SCE.freq_type = 1 THEN 'Date: ' + AD.active_start_date + ' Heure: ' + AT.start_time 
			WHEN SCE.freq_type < 64 THEN 'Date de d�but: ' + AD.active_start_date + CASE AD.active_end_date 
					WHEN '31/12/9999' THEN ' - Aucune date de fin'
					ELSE ' - Date de fin: ' + AD.active_end_date
			END
		END AS Intervalle_Date,
		NR.next_run_date_time as Prochaine_execution,
		JSCE.next_run_time/10000+((JSCE.next_run_time%10000)/100)/60.00 as Prochaine_execution_Heure_Debut,
		(JSCE.next_run_time/10000+((JSCE.next_run_time%10000)/100)/60.00)+HIS_TPS.run_duration as Prochaine_execution_Heure_Fin,
		HIS_LAST.date_derniere_execution AS Derniere_execution,
		HIS_ECHEC.NB_Exec_OK,
		HIS_ECHEC.NB_Exec,
		dbo.ExtractChaine(JOB.description, 'Description:', 'Procedure de reprise:') As Description,
		dbo.ExtractChaine(JOB.description, 'Procedure de reprise:', 'Impacts:') AS Procedure_Reprise,
		dbo.ExtractChaine(JOB.description, 'Impacts:', 'Alerte:') AS Impact,
		dbo.ExtractChaine(JOB.description, 'Alerte:', '') AS Alerte

FROM msdb.dbo.sysjobs JOB
JOIN msdb.dbo.sysjobsteps JSTP
  ON JOB.job_id = JSTP.job_id
JOIN msdb.dbo.sysjobschedules JSCE
  ON JOB.job_id = JSCE.job_id
JOIN msdb.dbo.sysschedules SCE
  ON JSCE.schedule_id = SCE.schedule_id
JOIN (
SELECT job_id, last_run_status, message
FROM (
SELECT job_id, last_run_status, message,
RANK() OVER (PARTITION BY job_id ORDER BY last_run_status DESC, step_id DESC) AS Rank
FROM (
SELECT job_id, step_id, 
/*
0 = Succ�s
1 = Reprise
2 = Annulation
3 = �chec
*/
CASE WHEN run_status = 1 THEN 0 ELSE 
CASE WHEN run_status = 2 THEN 1 ELSE
CASE WHEN run_status = 3 THEN 2 ELSE 3 END END END as last_run_status, 
message,
RANK() OVER (PARTITION BY job_id, step_id ORDER BY run_date DESC, run_time DESC) AS Rank
FROM msdb.dbo.sysjobhistory
) HIS
WHERE Rank = 1
) HIS2
WHERE Rank = 1) HIS_STT
  ON HIS_STT.job_id = JOB.job_id
JOIN (
SELECT job_id, SUM(run_duration) as run_duration
FROM (
SELECT job_id, step_id, AVG((run_duration/10000+((run_duration%10000)/100)/60.00)) as run_duration
FROM msdb.dbo.sysjobhistory
WHERE run_status = 1
GROUP BY job_id, step_id
) HIS
GROUP BY job_id) HIS_TPS
  ON HIS_TPS.job_id = JOB.job_id
JOIN (
SELECT job_id, 
MAX(DATEADD("s", (run_time/10000)*3600+((run_time/100)%100)*60+(run_time)%100, CONVERT(datetime, CAST(run_date as varchar), 111))) as date_derniere_execution
FROM msdb.dbo.sysjobhistory
GROUP BY job_id
) HIS_LAST
  ON HIS_LAST.job_id = JOB.job_id
JOIN (
SELECT job_id, SUM(CASE WHEN run_status = 1 THEN 1 ELSE 0 END) AS NB_Exec_OK,
COUNT(*) AS NB_Exec
FROM msdb.dbo.sysjobhistory
WHERE step_id = 0
  AND run_date > dbo.DateToInt(DATEADD(M, -2, GETDATE()))
GROUP BY job_id
) HIS_ECHEC
  ON HIS_ECHEC.job_id = JOB.job_id
OUTER APPLY  ( 
      SELECT  freq_day + ', ' 
      FROM  ( 
          SELECT CASE WHEN SCE.freq_interval & 1 = 1 THEN 'Dimanche' ELSE '' END AS freq_day 
          UNION ALL SELECT CASE WHEN SCE.freq_interval & 2 = 2 THEN 'Lundi' ELSE '' END 
          UNION ALL SELECT CASE WHEN SCE.freq_interval & 4 = 4 THEN 'Mardi' ELSE '' END 
          UNION ALL SELECT CASE WHEN SCE.freq_interval & 8 = 8 THEN 'Mercredi' ELSE '' END 
          UNION ALL SELECT CASE WHEN SCE.freq_interval & 16 = 16 THEN 'Jeudi' ELSE '' END 
          UNION ALL SELECT CASE WHEN SCE.freq_interval & 32 = 32 THEN 'Vendredi' ELSE '' END 
          UNION ALL SELECT CASE WHEN SCE.freq_interval & 64 = 64 THEN 'Samedi' ELSE '' END 
        ) AS SCE 
      WHERE  LEN(freq_day) > 0 
      FOR  XML PATH ('') 
    ) AS JOU (freq_day_concat)
OUTER APPLY  ( 
      SELECT  STUFF(STUFF(REPLICATE('0', 6 - LEN(SCE.active_start_time))  
          + CAST(SCE.active_start_time AS varchar(6)), 3, 0, ':'), 6, 0, ':') AS start_time 
        , STUFF(STUFF(REPLICATE('0', 6 - LEN(SCE.active_end_time))  
          + CAST(SCE.active_end_time AS varchar(6)), 3, 0, ':'), 6, 0, ':') AS end_time 
    ) AS AT 
OUTER APPLY  ( 
      SELECT  CONVERT(char(10), CAST(CAST(SCE.active_start_date AS char(8)) AS date), 103) AS active_start_date 
        , CONVERT(char(10), CAST(CAST(SCE.active_end_date AS char(8)) AS date), 103) AS active_end_date 
    ) AS AD 
OUTER APPLY  ( 
      SELECT  NULLIF(CAST(CONVERT(date, CAST(next_run_date as varchar), 111) as varchar), '') + ' ' 
        + STUFF(STUFF(REPLICATE('0', 6 - LEN(JSCE.next_run_time)) + CAST(JSCE.next_run_time AS char(6)), 3, 0, ':'), 6, 0, ':') AS next_run_date_time 
    ) AS NR
JOIN msdb.dbo.syscategories CAT
  ON JOB.category_id = CAT.category_id
WHERE CAT.Name <> 'Report Server'

)


GO


