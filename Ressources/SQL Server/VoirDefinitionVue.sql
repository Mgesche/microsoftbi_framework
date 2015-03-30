SELECT definition, uses_ansi_nulls, uses_quoted_identifier, is_schema_bound
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('CA.Customer_Customer_Level'); 

/* Etude d'impact */
SELECT OBJ.name, MODU.definition
FROM sys.sql_modules MODU
JOIN sys.objects OBJ
  ON MODU.object_id = OBJ.object_id
WHERE definition LIKE '%SAT_CURR_Invoice%'

/* Etude d'impact : Precis sur la table */
SELECT OBJ.name, MODU.definition
FROM sys.sql_modules MODU
JOIN sys.objects OBJ
  ON MODU.object_id = OBJ.object_id
WHERE definition LIKE '% IDC.sat_src.SAT_CURR_Invoice %'
   OR definition LIKE '% sat_src.SAT_CURR_Invoice %'