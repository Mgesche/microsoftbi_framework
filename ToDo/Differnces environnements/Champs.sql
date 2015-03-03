/* Mise en place */
IF EXISTS(
SELECT 1
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Adm_Colonnes_Dev'
)
BEGIN
	DROP TABLE Adm_Colonnes_Dev
END

IF EXISTS(
SELECT 1
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Adm_Colonnes_Prod'
)
BEGIN
	DROP TABLE Adm_Colonnes_Prod
END

/* Executer en Dev */
SELECT COALESCE(TABLE_CATALOG, '') AS TABLE_CATALOG, COALESCE(TABLE_SCHEMA, '') AS TABLE_SCHEMA, COALESCE(TABLE_NAME, '') AS TABLE_NAME, COALESCE(COLUMN_NAME, '') AS COLUMN_NAME, 
COALESCE(COLUMN_DEFAULT, '') AS COLUMN_DEFAULT, COALESCE(IS_NULLABLE, '') AS IS_NULLABLE, COALESCE(DATA_TYPE, '') AS DATA_TYPE, 
COALESCE(CHARACTER_MAXIMUM_LENGTH, '') AS CHARACTER_MAXIMUM_LENGTH, 
COALESCE(CHARACTER_OCTET_LENGTH, '') AS CHARACTER_OCTET_LENGTH, COALESCE(NUMERIC_PRECISION, '') AS NUMERIC_PRECISION, COALESCE(NUMERIC_PRECISION_RADIX, '') AS NUMERIC_PRECISION_RADIX
INTO Adm_Colonnes_Dev
FROM INFORMATION_SCHEMA.COLUMNS

SELECT TOP 0 TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, COLUMN_DEFAULT, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH,
NUMERIC_PRECISION, NUMERIC_PRECISION_RADIX
INTO Adm_Colonnes_Prod
FROM INFORMATION_SCHEMA.COLUMNS

/* Executer en Prod */
SELECT 'INSERT INTO Adm_Colonnes_Prod SELECT '''+CAST(COALESCE(REPLACE(TABLE_CATALOG, '''', ''''''), '') as VARCHAR)+''', '''+CAST(COALESCE(REPLACE(TABLE_SCHEMA, '''', ''''''), '') as VARCHAR)+''', '''+
CAST(COALESCE(REPLACE(TABLE_NAME, '''', ''''''), '') as VARCHAR)+''', '''+
CAST(COALESCE(REPLACE(COLUMN_NAME, '''', ''''''), '') as VARCHAR)+''', '''+CAST(COALESCE(REPLACE(COLUMN_DEFAULT, '''', ''''''), '') as VARCHAR)+''', '''+
CAST(COALESCE(REPLACE(IS_NULLABLE, '''', ''''''), '') as VARCHAR)+''', '''+
CAST(COALESCE(REPLACE(DATA_TYPE, '''', ''''''), '') as VARCHAR)+''', '''+
CAST(COALESCE(REPLACE(CHARACTER_MAXIMUM_LENGTH, '''', ''''''), '') as VARCHAR)+''', '''+CAST(COALESCE(REPLACE(CHARACTER_OCTET_LENGTH, '''', ''''''), '') as VARCHAR)+''', '''+
CAST(COALESCE(REPLACE(NUMERIC_PRECISION, '''', ''''''), '') as VARCHAR)+''', '''+
CAST(COALESCE(REPLACE(NUMERIC_PRECISION_RADIX, '''', ''''''), '') as VARCHAR)+''''
FROM INFORMATION_SCHEMA.COLUMNS

/* Executer les ordres d'insert en dev */

/* Comparer les resultats */
SELECT 'CREATE' as Action, DEV.TABLE_CATALOG, DEV.TABLE_SCHEMA, DEV.TABLE_NAME, DEV.COLUMN_NAME, DEV.COLUMN_DEFAULT, DEV.IS_NULLABLE, DEV.DATA_TYPE, DEV.CHARACTER_MAXIMUM_LENGTH, 
DEV.CHARACTER_OCTET_LENGTH,
DEV.NUMERIC_PRECISION, DEV.NUMERIC_PRECISION_RADIX
FROM Adm_Colonnes_Dev DEV
/* Table existante */
JOIN Adm_Colonnes_Prod PRDT
  ON DEV.TABLE_CATALOG = PRDT.TABLE_CATALOG
 AND DEV.TABLE_SCHEMA  = PRDT.TABLE_SCHEMA
 AND DEV.TABLE_NAME    = PRDT.TABLE_NAME
/* Colonne differentes */
LEFT JOIN Adm_Colonnes_Prod PRD
  ON DEV.TABLE_CATALOG = PRD.TABLE_CATALOG
 AND DEV.TABLE_SCHEMA  = PRD.TABLE_SCHEMA
 AND DEV.TABLE_NAME    = PRD.TABLE_NAME
 AND DEV.COLUMN_NAME    = PRD.COLUMN_NAME
 AND DEV.COLUMN_DEFAULT    = PRD.COLUMN_DEFAULT
 AND DEV.IS_NULLABLE    = PRD.COLUMN_DEFAULT
 AND DEV.DATA_TYPE    = PRD.DATA_TYPE
 AND DEV.CHARACTER_MAXIMUM_LENGTH    = PRD.CHARACTER_MAXIMUM_LENGTH
 AND DEV.CHARACTER_OCTET_LENGTH    = PRD.CHARACTER_OCTET_LENGTH
 AND DEV.NUMERIC_PRECISION    = PRD.NUMERIC_PRECISION
 AND DEV.NUMERIC_PRECISION_RADIX = PRD.NUMERIC_PRECISION_RADIX
WHERE PRD.TABLE_CATALOG IS NULL
UNION
SELECT 'DROP' as Action, PRD.TABLE_CATALOG, PRD.TABLE_SCHEMA, PRD.TABLE_NAME, PRD.COLUMN_NAME, PRD.COLUMN_DEFAULT, PRD.IS_NULLABLE, PRD.DATA_TYPE, PRD.CHARACTER_MAXIMUM_LENGTH, 
PRD.CHARACTER_OCTET_LENGTH,
PRD.NUMERIC_PRECISION, PRD.NUMERIC_PRECISION_RADIX
FROM Adm_Colonnes_Prod PRD
/* Table existante */
JOIN Adm_Colonnes_Dev DEVT
  ON PRD.TABLE_CATALOG = DEVT.TABLE_CATALOG
 AND PRD.TABLE_SCHEMA  = DEVT.TABLE_SCHEMA
 AND PRD.TABLE_NAME    = DEVT.TABLE_NAME
LEFT JOIN Adm_Colonnes_Dev DEV
  ON DEV.TABLE_CATALOG = PRD.TABLE_CATALOG
 AND DEV.TABLE_SCHEMA  = PRD.TABLE_SCHEMA
 AND DEV.TABLE_NAME    = PRD.TABLE_NAME
 AND DEV.COLUMN_NAME    = PRD.COLUMN_NAME
 AND DEV.COLUMN_DEFAULT    = PRD.COLUMN_DEFAULT
 AND DEV.IS_NULLABLE    = PRD.COLUMN_DEFAULT
 AND DEV.DATA_TYPE    = PRD.DATA_TYPE
 AND DEV.CHARACTER_MAXIMUM_LENGTH    = PRD.CHARACTER_MAXIMUM_LENGTH
 AND DEV.CHARACTER_OCTET_LENGTH    = PRD.CHARACTER_OCTET_LENGTH
 AND DEV.NUMERIC_PRECISION    = PRD.NUMERIC_PRECISION
 AND DEV.NUMERIC_PRECISION_RADIX = PRD.NUMERIC_PRECISION_RADIX
WHERE DEV.TABLE_CATALOG IS NULL

/* Comparer les resultats : champs */
SELECT  distinct 'CREATE' as DIRECTION, COALESCE(DEV.TABLE_CATALOG, PRD.TABLE_CATALOG) AS TABLE_CATALOG, 
		 COALESCE(DEV.TABLE_SCHEMA, PRD.TABLE_SCHEMA) AS TABLE_SCHEMA, 
		 COALESCE(DEV.TABLE_NAME, PRD.TABLE_NAME) AS TABLE_NAME, 
		 COALESCE(DEV.COLUMN_NAME, PRD.COLUMN_NAME) AS COLUMN_NAME,
        'ALTER TABLE '+DEV.TABLE_CATALOG+'.'+DEV.TABLE_SCHEMA+'.'+DEV.TABLE_NAME+' ADD '+DEV.COLUMN_NAME+' '+DEV.DATA_TYPE+
		CASE WHEN DEV.CHARACTER_MAXIMUM_LENGTH <> '' THEN '('+cast(DEV.CHARACTER_MAXIMUM_LENGTH as varchar)+')' ELSE '' END
FROM Adm_Colonnes_Dev DEV
/* Table existante */
JOIN Adm_Colonnes_Prod PRDT
  ON DEV.TABLE_CATALOG = PRDT.TABLE_CATALOG
 AND DEV.TABLE_SCHEMA  = PRDT.TABLE_SCHEMA
 AND DEV.TABLE_NAME    = PRDT.TABLE_NAME
/* Colonne differentes */
LEFT JOIN Adm_Colonnes_Prod PRD
  ON DEV.TABLE_CATALOG = PRD.TABLE_CATALOG
 AND DEV.TABLE_SCHEMA  = PRD.TABLE_SCHEMA
 AND DEV.TABLE_NAME    = PRD.TABLE_NAME
 AND DEV.COLUMN_NAME    = PRD.COLUMN_NAME
WHERE PRD.TABLE_CATALOG IS NULL
union
SELECT  distinct 'DROP' as DIRECTION, COALESCE(DEV.TABLE_CATALOG, PRD.TABLE_CATALOG) AS TABLE_CATALOG, 
		 COALESCE(DEV.TABLE_SCHEMA, PRD.TABLE_SCHEMA) AS TABLE_SCHEMA, 
		 COALESCE(DEV.TABLE_NAME, PRD.TABLE_NAME) AS TABLE_NAME, 
		 COALESCE(DEV.COLUMN_NAME, PRD.COLUMN_NAME) AS COLUMN_NAME, ''
FROM Adm_Colonnes_Prod DEV
/* Table existante */
JOIN Adm_Colonnes_Dev PRDT
  ON DEV.TABLE_CATALOG = PRDT.TABLE_CATALOG
 AND DEV.TABLE_SCHEMA  = PRDT.TABLE_SCHEMA
 AND DEV.TABLE_NAME    = PRDT.TABLE_NAME
/* Colonne differentes */
LEFT JOIN Adm_Colonnes_Dev PRD
  ON DEV.TABLE_CATALOG = PRD.TABLE_CATALOG
 AND DEV.TABLE_SCHEMA  = PRD.TABLE_SCHEMA
 AND DEV.TABLE_NAME    = PRD.TABLE_NAME
 AND DEV.COLUMN_NAME    = PRD.COLUMN_NAME
WHERE PRD.TABLE_CATALOG IS NULL
ORDER BY DIRECTION, COALESCE(DEV.TABLE_CATALOG, PRD.TABLE_CATALOG), 
		 COALESCE(DEV.TABLE_SCHEMA, PRD.TABLE_SCHEMA), 
		 COALESCE(DEV.TABLE_NAME, PRD.TABLE_NAME), 
		 COALESCE(DEV.COLUMN_NAME, PRD.COLUMN_NAME)

/* Selectionner la liste des table effectivement a drop/create puis exporter les scripts */


Dim_BA ?
DimEtablissement ?
FactBA ?
param_exportMDX ?
Referentiel ?
