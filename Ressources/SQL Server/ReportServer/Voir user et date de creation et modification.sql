SELECT Name
      ,CreatedBy = U.UserName
      ,CreationDate = C.CreationDate
      ,ModifiedBy = UM.UserName
      ,ModifiedDate
  FROM Reportserver.dbo.Catalog C
  JOIN Reportserver.dbo.Users U
    ON C.CreatedByID = U.UserID
  JOIN Reportserver.dbo.Users UM
    ON c.ModifiedByID = UM.UserID
 WHERE Name = 'ReportName'