WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition', 'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd )
SELECT  ReportName     = name
	   ,ReportPath = path
       ,DataSourceName   = x.value('(@Name)[1]', 'VARCHAR(250)')
       ,DataProvider   = x.value('(ConnectionProperties/DataProvider)[1]','VARCHAR(250)')
       ,ConnectionString = x.value('(ConnectionProperties/ConnectString)[1]','VARCHAR(250)')
   INTO BotanicDW_MEC.dbo.ASuppr_ListRapport_DataSource
  FROM (  SELECT C.Name, C.Path, CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
           FROM  ReportServer.dbo.Catalog C
          WHERE  C.Content is not null
            AND  C.Type  = 2
        ) a
  CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource') r ( x )
 ORDER BY name ;

SELECT  Name = Paravalue.value('Name[1]', 'VARCHAR(250)')
       ,Type = Paravalue.value('Type[1]', 'VARCHAR(250)')
       ,Nullable = Paravalue.value('Nullable[1]', 'VARCHAR(250)')
       ,AllowBlank = Paravalue.value('AllowBlank[1]', 'VARCHAR(250)')
       ,MultiValue = Paravalue.value('MultiValue[1]', 'VARCHAR(250)')
       ,UsedInQuery = Paravalue.value('UsedInQuery[1]', 'VARCHAR(250)')
       ,Prompt = Paravalue.value('Prompt[1]', 'VARCHAR(250)')
       ,DynamicPrompt = Paravalue.value('DynamicPrompt[1]', 'VARCHAR(250)')
       ,PromptUser = Paravalue.value('PromptUser[1]', 'VARCHAR(250)')
       ,State = Paravalue.value('State[1]', 'VARCHAR(250)'),
	   Name as Nom, 
	   SUBSTRING(Path, 1, LEN(Path)-LEN(Name)-1) as Chemin
   INTO BotanicDW_MEC.dbo.ASuppr_ListRapport_Parametres
 FROM (
     SELECT C.Name, C.Path, CONVERT(XML,C.Parameter) AS ParameterXML
       FROM  ReportServer.dbo.Catalog C
      WHERE  C.Content is not null
        AND  C.Type  = 2
    ) a
CROSS APPLY ParameterXML.nodes('//Parameters/Parameter') p ( Paravalue )

SELECT DISTINCT Chemin COLLATE French_CI_AS, Nom COLLATE French_CI_AS
FROM [Webservices].[ListReports]() 
WHERE DtsDatasource = 'decsqlprod' AND DtsInitialCatalog = 'BaseOLAP_MEC'
INTERSECT
SELECT DISTINCT Chemin COLLATE French_CI_AS, Nom COLLATE French_CI_AS
FROM BotanicDW_MEC.dbo.ASuppr_ListRapport_Parametres
WHERE Name IN (
'DDebutN1',
'DFinN1',
'DDebut2',
'DDOpeCo2',
'DFin2',
'ToTempsDateRef',
'FromTempsDateRef',
'OpeCo2',
'OpeCo2',
'pTempsReferenceDebut',
'pTempsReferenceFin',
'ToTempsDateRef',
'DateClicheStock2',
'FromTempsDate2',
'FromTempsreferenceDateComplete',
'FromTempsRefDate',
'FromTempsDateRef',
'pTempsReferenceDebut',
'pTempsReferenceFin',
'TempsDateRef',
'ToTempsDate2',
'ToTempsDateRef',
'ToTempsRefDate',
'ToTempsreferenceDateComplete'
)