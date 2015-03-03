/* Executer en Dev */
SELECT COALESCE(sch.name, '') as SCHEMA_NAME, COALESCE(tab.name, '') as TABLE_NAME, COALESCE(ind.name, '') as INDEX_NAME
INTO Adm_Index_Dev
FROM sys.indexes ind 
JOIN sys.tables tab
  ON ind.object_id = tab.object_id 
LEFT JOIN sys.schemas sch 
  ON sch.schema_id = tab.schema_id 
WHERE ind.name is not null

SELECT TOP 0 sch.name as SCHEMA_NAME, tab.name as TABLE_NAME, ind.name as INDEX_NAME
INTO Adm_Index_Prod
FROM sys.indexes ind 
JOIN sys.tables tab
  ON ind.object_id = tab.object_id 
LEFT JOIN sys.schemas sch 
  ON sch.schema_id = tab.schema_id 
WHERE ind.name is not null

/* Executer en Prod */
SELECT 'INSERT INTO Adm_Index_Prod SELECT '''+COALESCE(sch.name, '')+''', '''+COALESCE(tab.name, '')+''', '''+COALESCE(ind.name, '')+''''
FROM sys.indexes ind 
JOIN sys.tables tab
  ON ind.object_id = tab.object_id 
LEFT JOIN sys.schemas sch 
  ON sch.schema_id = tab.schema_id 
WHERE ind.name is not null

/* Executer les ordres d'insert en dev */

/* Comparer les resultats */
SELECT distinct 'CREATE' as Action, COALESCE(DEV.SCHEMA_NAME, PRD.SCHEMA_NAME) AS SCHEMA_NAME, COALESCE(DEV.TABLE_NAME, PRD.TABLE_NAME) AS TABLE_NAME, 
COALESCE(DEV.INDEX_NAME, PRD.INDEX_NAME) AS INDEX_NAME
FROM Adm_Index_Dev DEV
/* Table existante */
JOIN Adm_Index_Prod PRDT
  ON DEV.SCHEMA_NAME = PRDT.SCHEMA_NAME
 AND DEV.TABLE_NAME  = PRDT.TABLE_NAME
LEFT JOIN Adm_Index_Prod PRD
  ON DEV.SCHEMA_NAME = PRD.SCHEMA_NAME
 AND DEV.TABLE_NAME  = PRD.TABLE_NAME
 AND DEV.INDEX_NAME    = PRD.INDEX_NAME
WHERE PRD.SCHEMA_NAME IS NULL
UNION
SELECT distinct 'DROP' as Action, COALESCE(DEV.SCHEMA_NAME, PRD.SCHEMA_NAME) AS SCHEMA_NAME, COALESCE(DEV.TABLE_NAME, PRD.TABLE_NAME) AS TABLE_NAME, 
COALESCE(DEV.INDEX_NAME, PRD.INDEX_NAME) AS INDEX_NAME
FROM Adm_Index_Prod PRD
/* Table existante */
JOIN Adm_Index_Dev DEVT
  ON PRD.SCHEMA_NAME = DEVT.SCHEMA_NAME
 AND PRD.TABLE_NAME  = DEVT.TABLE_NAME
LEFT JOIN Adm_Index_Dev DEV
  ON DEV.SCHEMA_NAME = PRD.SCHEMA_NAME
 AND DEV.TABLE_NAME  = PRD.TABLE_NAME
 AND DEV.INDEX_NAME    = PRD.INDEX_NAME
WHERE DEV.SCHEMA_NAME IS NULL
