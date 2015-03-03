/*
USE AdventureWorks
GO
----Diable Index
ALTER INDEX [IX_StoreContact_ContactTypeID] ON Sales.StoreContact DISABLE
GO
----Enable Index
ALTER INDEX [IX_StoreContact_ContactTypeID] ON Sales.StoreContact REBUILD
GO

SELECT 'ALTER INDEX ['+ind.name+'] ON '+sch.name+'.'+tab.name+' DISABLE' as query
FROM sys.indexes ind 
JOIN sys.tables tab
  ON ind.object_id = tab.object_id 
LEFT JOIN sys.schemas sch 
  ON sch.schema_id = tab.schema_id 
WHERE tab.name = 'DSVTicketCRM'
*/
