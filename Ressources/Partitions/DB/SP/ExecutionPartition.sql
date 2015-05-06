/* Exemple :

	EXECUTE [DSV].ExecutionPartition 369

*/
IF object_id(N'DSV.ExecutionPartition ', N'P') IS NOT NULL
    DROP PROCEDURE DSV.ExecutionPartition 
GO

CREATE PROCEDURE [DSV].ExecutionPartition 
    @id_Partition INTEGER

AS

/* Purge des jobs termine precedement */
EXECUTE [DSV].PurgeJobPartition

BEGIN TRANSACTION

DECLARE @jobId BINARY(16)

DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @job_name NVARCHAR(100)
SET @job_name = N'Exploitation - Process Partition - '+CAST(@id_Partition AS VARCHAR)

/* Creation du job */
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@job_name, 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Pas de description disponible.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'BOTANIC\mgesche', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

DECLARE @Command NVARCHAR(500)
SET @Command = N'/FILE "C:\Users\mgesche\Documents\Visual Studio 2008\Projects\Partitions\SSIS\Process_Partition.dtsx" /CHECKPOINTING OFF '
SET @Command = @Command + '/SET "\Package.Variables[User::idPartition].Properties[Value]";' + CAST(@id_Partition AS NVARCHAR) + ' /REPORTING E'

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Package', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=@Command,
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXECUTE msdb.dbo.sp_start_job @job_id = @jobId

COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

