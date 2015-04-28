WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition', 'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd )
SELECT  ReportName     = name
       ,DataSourceName   = x.value('(@Name)[1]', 'VARCHAR(250)')
       ,DataProvider   = x.value('(ConnectionProperties/DataProvider)[1]','VARCHAR(250)')
       ,ConnectionString = x.value('(ConnectionProperties/ConnectString)[1]','VARCHAR(250)')
  FROM (  SELECT C.Name,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
           FROM  ReportServer.dbo.Catalog C
          WHERE  C.Content is not null
            AND  C.Type  = 2
      AND  C.Name  = 'ReportName'
        ) a
  CROSS APPLY reportXML.nodes('/Report/DataSources/DataSource') r ( x )
 ORDER BY name ;