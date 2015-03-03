SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
GO 
 
SELECT J.name AS job_name 
     ,CASE C.name WHEN '[Uncategorized (Local)]' THEN 'Uncategorized' ELSE C.name END AS job_category_name 
     ,J.description AS job_description 
     ,JS.step_name 
     ,CASE WHEN HIS.run_status = 1 THEN 'OK' ELSE 'KO' END AS run_status
     ,HIS.message AS message
     ,HIS.run_date
     ,HIS.run_time
     ,HIS.run_duration
FROM    msdb.dbo.sysjobs AS J 
INNER JOIN  msdb.dbo.sysjobsteps AS JS 
      ON J.job_id = JS.job_id 
INNER JOIN  msdb.dbo.syscategories AS C 
      ON J.category_id = C.category_id 
INNER JOIN msdb.dbo.sysjobhistory HIS
	  ON HIS.job_id = JS.job_id
	 AND HIS.step_id = JS.step_id
WHERE    1 = 1 
--AND    J.name LIKE '%unMot%' 
--AND    JS.database_name = 'uneBD' 
--AND    J.enabled  = 1 
ORDER BY  J.name, JS.step_id