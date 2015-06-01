/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'Webservices.ListDatasources', N'TF') IS NOT NULL
    DROP FUNCTION Webservices.ListDatasources
GO

CREATE FUNCTION [Webservices].[ListDatasources]() 
RETURNS @ListDatasources TABLE (Nom varchar(255), 
                                Chemin varchar(255), 
								DtsExtension varchar(50), 
								ConnectionString varchar(255), 
								DataSource varchar(50),
								InitialCatalog varchar(50),
								Description varchar(255), 
								isEnabled int)
as
  /* =============================================================================== */
  /* Recupere les infos des datasources de RS                                        */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT * FROM [BotanicDW_MEC].[Webservices].[ListDatasources]();

GO
*/
BEGIN
    
/* Divers namespaces pour les rapports */
/*
SELECT DISTINCT dbo.ExtractChaine(LEFT(CAST(CONVERT(XML,CONVERT(VARBINARY(MAX),Content)) AS VARCHAR(MAX)), 500), '<Report ', '>')
FROM ReportServer.dbo.Catalog
WHERE Type = 5
*/

;
WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2006/03/reportdatasource')
INSERT INTO @ListDatasources
SELECT A.Nom, A.Chemin, x.value('(/DataSourceDefinition/Extension)[1]', 'VARCHAR(50)') as DtsExtension,
	    x.value('(/DataSourceDefinition/ConnectString)[1]', 'VARCHAR(255)') as ConnectionString,
	    dbo.ExtractChaine(x.value('(/DataSourceDefinition/ConnectString)[1]', 'VARCHAR(255)'), 'Data Source=', ';') as DataSource,
	    dbo.ExtractChaine(x.value('(/DataSourceDefinition/ConnectString)[1]', 'VARCHAR(255)'), 'Initial Catalog=', '') as InitialCatalog,
	    A.Description, 
	    CASE WHEN x.value('(/DataSourceDefinition/Enabled)[1]', 'VARCHAR(10)') = 'True' THEN 1 ELSE 0 END as isEnabled
	    
FROM (  SELECT Name as Nom, SUBSTRING(Path, 1, LEN(Path)-LEN(Name)-1) as Chemin, Description,
               CONVERT(XML,CONVERT(VARBINARY(MAX),Content)) AS reportXML
        FROM  ReportServer.dbo.Catalog Dts
        WHERE Type  = 5
        ) a
OUTER APPLY reportXML.nodes('.') r ( x )

RETURN 

END

GO