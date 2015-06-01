/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'Webservices.ListReports', N'TF') IS NOT NULL
    DROP FUNCTION Webservices.ListReports
GO

CREATE FUNCTION [Webservices].[ListReports]() 
RETURNS @ListReports TABLE (Nom varchar(255), 
                            Chemin varchar(255), 
                            DtsExtension varchar(10), 
                            DtsDatasource varchar(50), 
                            DtsInitialCatalog varchar(50),
                            isVisible int)
as
  /* =============================================================================== */
  /* Recupere la liste des rapports se basant sur une source de données              */
  /*                                                                                 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT * FROM [BotanicDW_MEC].[Webservices].[ListReports]();

GO
*/
BEGIN

/* Divers namespaces pour les rapports */
/*
SELECT DISTINCT dbo.ExtractChaine(LEFT(CAST(CONVERT(XML,CONVERT(VARBINARY(MAX),Content)) AS VARCHAR(MAX)), 500), '<Report ', '>')
FROM ReportServer.dbo.Catalog
WHERE Type = 2
*/

;
WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition', 
                             'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd,
							 'http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition' AS cl)
INSERT INTO @ListReports
SELECT REP.Nom, REP.Chemin, DTS.DtsExtension, DTS.DataSource as DtsDataSource, DTS.InitialCatalog as DtsInitialCatalog,
       IsVisible
FROM (SELECT C.Name as Nom, SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1) as Chemin, 
             CASE WHEN R.Hidden = 1 THEN 0 ELSE 1 END AS IsVisible,
             CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
      FROM  ReportServer.dbo.Catalog C
      LEFT JOIN ReportServer.dbo.Catalog R
        ON R.Path = SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1)
      WHERE  C.Content is not null
        AND  C.Type  = 2
    ) REP
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/DataSourceReference') r ( REF )
LEFT JOIN [Webservices].[ListDatasources]() DTS
  ON DTS.Nom = REF.value('.', 'VARCHAR(250)')

;
WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition', 
                             'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd,
							 'http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition' AS cl)
INSERT INTO @ListReports
SELECT REP.Nom, REP.Chemin, DTP.value('.', 'VARCHAR(250)') AS DtsExtension, 
      dbo.ExtractChaine(CNS.value('.', 'VARCHAR(250)'), 'Data Source=', ';') as DtsDataSource,
	    dbo.ExtractChaine(CNS.value('.', 'VARCHAR(250)'), 'Initial Catalog=', '') as DtsInitialCatalog,
      IsVisible
FROM (SELECT C.Name as Nom, SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1) as Chemin, 
             CASE WHEN R.Hidden = 1 THEN 0 ELSE 1 END AS IsVisible,
             CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
      FROM  ReportServer.dbo.Catalog C
      LEFT JOIN ReportServer.dbo.Catalog R
        ON R.Path = SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1)
      WHERE  C.Content is not null
        AND  C.Type  = 2
    ) REP
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/ConnectionProperties/DataProvider') r ( DTP )
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/ConnectionProperties/ConnectString') s ( CNS )

;
WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition', 
                             'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd)
INSERT INTO @ListReports
SELECT REP.Nom, REP.Chemin, DTS.DtsExtension, DTS.DataSource as DtsDataSource, DTS.InitialCatalog as DtsInitialCatalog,
       IsVisible
FROM (SELECT C.Name as Nom, SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1) as Chemin, 
             CASE WHEN R.Hidden = 1 THEN 0 ELSE 1 END AS IsVisible,
             CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
      FROM  ReportServer.dbo.Catalog C
      LEFT JOIN ReportServer.dbo.Catalog R
        ON R.Path = SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1)
      WHERE  C.Content is not null
        AND  C.Type  = 2
    ) REP
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/DataSourceReference') r ( REF )
LEFT JOIN [Webservices].[ListDatasources]() DTS
  ON DTS.Nom = REF.value('.', 'VARCHAR(250)')

;
WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition', 
                             'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd)
INSERT INTO @ListReports
SELECT REP.Nom, REP.Chemin, DTP.value('.', 'VARCHAR(250)') AS DtsExtension, 
      dbo.ExtractChaine(CNS.value('.', 'VARCHAR(250)'), 'Data Source=', ';') as DtsDataSource,
	    dbo.ExtractChaine(CNS.value('.', 'VARCHAR(250)'), 'Initial Catalog=', '') as DtsInitialCatalog,
      IsVisible
FROM (SELECT C.Name as Nom, SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1) as Chemin, 
             CASE WHEN R.Hidden = 1 THEN 0 ELSE 1 END AS IsVisible,
             CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
      FROM  ReportServer.dbo.Catalog C
      LEFT JOIN ReportServer.dbo.Catalog R
        ON R.Path = SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1)
      WHERE  C.Content is not null
        AND  C.Type  = 2
    ) REP
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/ConnectionProperties/DataProvider') r ( DTP )
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/ConnectionProperties/ConnectString') s ( CNS )

;
WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition', 
                             'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd)
INSERT INTO @ListReports
SELECT REP.Nom, REP.Chemin, DTS.DtsExtension, DTS.DataSource as DtsDataSource, DTS.InitialCatalog as DtsInitialCatalog,
       IsVisible
FROM (SELECT C.Name as Nom, SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1) as Chemin, 
             CASE WHEN R.Hidden = 1 THEN 0 ELSE 1 END AS IsVisible,
             CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
      FROM  ReportServer.dbo.Catalog C
      LEFT JOIN ReportServer.dbo.Catalog R
        ON R.Path = SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1)
      WHERE  C.Content is not null
        AND  C.Type  = 2
    ) REP
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/DataSourceReference') r ( REF )
LEFT JOIN [Webservices].[ListDatasources]() DTS
  ON DTS.Nom = REF.value('.', 'VARCHAR(250)')

;
WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition', 
                             'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd)
INSERT INTO @ListReports
SELECT REP.Nom, REP.Chemin, DTP.value('.', 'VARCHAR(250)') AS DtsExtension, 
      dbo.ExtractChaine(CNS.value('.', 'VARCHAR(250)'), 'Data Source=', ';') as DtsDataSource,
	    dbo.ExtractChaine(CNS.value('.', 'VARCHAR(250)'), 'Initial Catalog=', '') as DtsInitialCatalog,
      IsVisible
FROM (SELECT C.Name as Nom, SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1) as Chemin, 
             CASE WHEN R.Hidden = 1 THEN 0 ELSE 1 END AS IsVisible,
             CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
      FROM  ReportServer.dbo.Catalog C
      LEFT JOIN ReportServer.dbo.Catalog R
        ON R.Path = SUBSTRING(C.Path, 1, LEN(C.Path)-LEN(C.Name)-1)
      WHERE  C.Content is not null
        AND  C.Type  = 2
    ) REP
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/ConnectionProperties/DataProvider') r ( DTP )
CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource/ConnectionProperties/ConnectString') s ( CNS )

RETURN 

END

GO