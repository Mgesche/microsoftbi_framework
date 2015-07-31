IF NOT EXISTS(SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE TABLE_NAME = 'TestNN_Requetes')
BEGIN
	CREATE TABLE TestNN_Requetes(
		Requete VARCHAR(1000)
	);
END

IF NOT EXISTS(SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE TABLE_NAME = 'TestNN_Requetes_Result')
BEGIN
	CREATE TABLE TestNN_Requetes_Result(
		Environnement VARCHAR(100),
		Requete VARCHAR(1000),
		Perimetre VARCHAR(200),
		Resultat numeric(25,6)
	);
END

IF NOT EXISTS(SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE TABLE_NAME = 'TestNN_Requetes_Temps')
BEGIN
	CREATE TABLE TestNN_Requetes_Temps(
		Environnement VARCHAR(100),
		Requete VARCHAR(1000),
		DateDebut DateTime,
		DateFin DateTime
	);
END