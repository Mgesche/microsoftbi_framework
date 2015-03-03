/* Mise en place */
IF EXISTS(
SELECT 1
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Adm_Procs_Dev'
)
BEGIN
	DROP TABLE Adm_Procs_Dev
END

IF EXISTS(
SELECT 1
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Adm_Procs_Prod'
)
BEGIN
	DROP TABLE Adm_Procs_Prod
END

/* Executer en Dev */
SELECT name 
INTO Adm_Procs_Dev
FROM sysobjects 
WHERE Type IN ('P', 'TF', 'FN')

SELECT top 0 name 
INTO Adm_Procs_Prod
FROM sysobjects 
WHERE Type IN ('P', 'TF', 'FN')

/* Executer en Prod */
SELECT 'INSERT INTO Adm_Procs_Prod SELECT '''+name+''''
FROM sysobjects 
WHERE Type IN ('P', 'TF', 'FN')

/* Executer les ordres d'insert en dev */

/* Comparer les resultats */
SELECT 'CREATE' as Action, DEV.name
FROM Adm_Procs_Dev DEV
LEFT JOIN Adm_Procs_Prod PRD
  ON DEV.name = PRD.name
WHERE PRD.name IS NULL
UNION
SELECT 'DROP' as Action, PRD.name
FROM Adm_Procs_Prod PRD
LEFT JOIN Adm_Procs_Dev DEV
  ON DEV.name = PRD.name
WHERE DEV.name IS NULL

/* Selectionner la liste des table effectivement a drop/create puis exporter les scripts */