SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
GO 
 
SELECT HIS.run_date
     ,MIN(HIS.run_time) as date_debut
     ,SUM((HIS.run_duration/10000)*3600+((HIS.run_duration/100)%100)*60+(HIS.run_duration)%100) as duree_secondes
     ,LEFT(CAST(DATEADD("s", SUM((HIS.run_duration/10000)*3600+((HIS.run_duration/100)%100)*60+(HIS.run_duration)%100), 0) as time), 8) AS Duree
FROM    msdb.dbo.sysjobs AS J 
INNER JOIN  msdb.dbo.sysjobsteps AS JS 
      ON J.job_id = JS.job_id 
INNER JOIN  msdb.dbo.syscategories AS C 
      ON J.category_id = C.category_id 
INNER JOIN msdb.dbo.sysjobhistory HIS
	  ON HIS.job_id = JS.job_id
	 AND HIS.step_id = JS.step_id
WHERE    1 = 1 
AND    J.name = 'Flux VENTE_STOCK'
GROUP BY HIS.run_date
HAVING MIN(HIS.run_status) = 1
ORDER BY  HIS.run_date desc