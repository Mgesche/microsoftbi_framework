/* Exemple :

	EXECUTE [dbo].ExecutionPartition 369

*/
CREATE PROCEDURE [dbo].ExecutionPartition 
    @id_Partition INTEGER

AS

DECLARE @Command NVARCHAR(500)
SET @Command = N'/FILE "C:\Users\mgesche\Documents\Visual Studio 2008\Projects\Partitions\SSIS\Process_Partition.dtsx" /CHECKPOINTING OFF '
SET @Command = @Command + '/SET "\Package.Variables[User::idPartition].Properties[Value]";' + CAST(@id_Partition AS NVARCHAR) + ' /REPORTING E'

EXECUTE msdb.dbo.sp_update_jobstep 
	@job_name = N'Exploitation - Process Partition', 
	@step_id = 1, 
	@subsystem=N'SSIS', 
	@command=@Command
	
EXECUTE msdb.dbo.sp_start_job @job_name = N'Exploitation - Process Partition'

GO

