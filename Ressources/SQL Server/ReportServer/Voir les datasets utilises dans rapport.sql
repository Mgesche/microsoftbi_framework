WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition', 'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd )
SELECT  ReportName    = name
       ,DataSetName    = x.value('(@Name)[1]', 'VARCHAR(250)')
       ,DataSourceName  = x.value('(Query/DataSourceName)[1]','VARCHAR(250)')
       ,CommandText    = x.value('(Query/CommandText)[1]','VARCHAR(250)')
       ,Fields      = df.value('(@Name)[1]','VARCHAR(250)')
       ,DataField    = df.value('(DataField)[1]','VARCHAR(250)')
       ,DataType    = df.value('(rd:TypeName)[1]','VARCHAR(250)')
  FROM (  SELECT C.Name,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
           FROM  ReportServer.dbo.Catalog C
          WHERE  C.Content is not null
            AND  C.Type = 2
         AND  C.Name = 'ReportName'
     ) a
  CROSS APPLY reportXML.nodes('/Report/DataSets/DataSet') r ( x )
  CROSS APPLY x.nodes('Fields/Field') f(df)
ORDER BY name