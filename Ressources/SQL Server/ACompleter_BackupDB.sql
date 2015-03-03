SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE BackupDB
	-- Add the parameters for the stored procedure here
	@BackupFolder varchar(100) = 'D:\PRODBDD\SQL_DATA\BACKUP',
	@Execute integer = 0,
	@BackupDB varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @v_sql_cmd NVARCHAR(4000)

	SET @v_sql_cmd = N'BACKUP DATABASE ['+@BackupDB+'] TO  DISK = N'''+@BackupFolder+'\'+@BackupDB+'.BAK'' WITH NOFORMAT, NOINIT,  NAME = N'''+@BackupDB+'-Complète Base de données Sauvegarde'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10, CHECKSUM'
	IF @Execute = 1 begin
		EXECUTE sp_executesql @v_sql_cmd
	END
	ELSE BEGIN
		PRINT @v_sql_cmd
	END
	
	declare @backupSetId as int
	select @backupSetId = position
	from msdb..backupset
	where database_name=N'master'
	  and backup_set_id=(select max(backup_set_id)
						 from msdb..backupset
						 where database_name=N'master')
	
	if @backupSetId is null begin
		raiserror(N'Échec de la vérification. Les informations de sauvegarde pour la base de données « master » sont introuvables.', 16, 1)
	end
	
	RESTORE VERIFYONLY FROM DISK = N'D:\PRODBDD\SQL_DATA\BACKUP\master.BAK'
	WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND

END
GO
