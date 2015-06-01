SELECT  Name, Convert(XML,(Convert(VARBINARY(MAX),Content))) AS ReportXML
  FROM  ReportServer.dbo.Catalog
 WHERE  Content IS NOT NULL
   AND  [Type] = 2 -- For Report objects alone