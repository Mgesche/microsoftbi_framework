/* Exemple :

	EXECUTE [DSV].PurgeJobPartition

*/
IF object_id(N'DSV.PurgeJobPartition ', N'P') IS NOT NULL
    DROP PROCEDURE DSV.PurgeJobPartition 
GO

CREATE PROCEDURE [DSV].PurgeJobPartition 

AS

DECLARE @jobId BINARY(16)

DECLARE job_cursor CURSOR FOR
SELECT JOB.job_id
FROM msdb.dbo.sysjobactivity ACT
JOIN msdb.dbo.sysjobs JOB
  on job.job_id = ACT.job_id
WHERE JOB.name like 'Exploitation - Process Partition%'
  AND job_history_id IS NOT NULL

OPEN job_cursor

FETCH NEXT FROM job_cursor 
INTO @jobId
  
WHILE @@FETCH_STATUS = 0
BEGIN
  
  EXEC msdb.dbo.sp_delete_job @job_id=@jobId, @delete_unused_schedule=1

  FETCH NEXT FROM job_cursor 
  INTO @jobId
    
END
  
CLOSE job_cursor
DEALLOCATE job_cursor
	  
GO

