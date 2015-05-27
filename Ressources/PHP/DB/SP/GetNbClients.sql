/*
sp_configure 'show advanced options', 1;
RECONFIGURE;
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
*/

USE [BotanicDW_MEC]
GO

CREATE PROCEDURE [WebServices].[GetNbClients]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
DECLARE @SQLString nvarchar(500);
DECLARE @ParmDefinition nvarchar(500);
DECLARE @output1 int;

SET @SQLString = N'
SELECT  @output=  a."[Measures].[NB CLIENT]"  FROM  
OpenRowset(''MSOLAP'',
''DATASOURCE=DECSQLDEV;Initial Catalog=Cube CRM;'',
''SELECT NON EMPTY {[NB CLIENT]} ON COLUMNS 
FROM [CRM]'') as a'
print @SQLString

SET @ParmDefinition = N'
    @output float OUTPUT';

EXECUTE sp_executesql
    @SQLString
    ,@ParmDefinition
    ,@output = @output1 OUTPUT;

SELECT @output1 as CA

END

GO


