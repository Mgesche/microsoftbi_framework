SELECT D.Name
       ,'Using Report '
      = CASE
        WHEN D.Name IS NOT NULL THEN  C.Name
        ELSE 'Shared Data Source'
        END
      ,'IsSharedDataSource' = CLink.Name
     FROM DataSource D
     JOIN Catalog C
     ON D.ItemID = C.ItemID
LEFT JOIN Catalog CLink
     ON Clink.ItemID = D.Link
  WHERE C.Name = 'ReportName'

/* Liste des rapports et de leurs datasources utilisée */
SELECT 	DTS.Name as DataSource,
		CASE WHEN DTS.Name IS NOT NULL THEN CAT.Name
			 ELSE 'Shared Data Source'
        END AS Rapport,
       ,'Using Report '
      = CASE
        WHEN D.Name IS NOT NULL THEN  C.Name
        ELSE 'Shared Data Source'
        END
      ,'IsSharedDataSource' = CLink.Name
FROM DataSource DTS
JOIN Catalog CAT
  ON DTS.ItemID = CAT.ItemID
LEFT JOIN Catalog CLink
     ON Clink.ItemID = DTS.Link
  