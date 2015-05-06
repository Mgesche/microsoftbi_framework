DECLARE @NbError int

/* Enseigne */
SET @NbError = (SELECT COUNT(*) FROM (
SELECT Societe_Id
FROM [push_reporting].[GetSocietes] ('Enseigne', 1)
EXCEPT
SELECT Societe_Id
FROM DimSociete
WHERE enseigne_id = 1
) RES)

IF @NbError > 0
BEGIN
	RAISERROR(N'Erreur sur GetSocietes concernant les enseignes', 15, 0)
END

/* Region */
SET @NbError = (SELECT COUNT(*) FROM (
SELECT Societe_Id
FROM [push_reporting].[GetSocietes] ('Region', 'LIT Littoral')
EXCEPT
SELECT Societe_Id
FROM DimSociete
WHERE RegionCommerciale = 'LIT Littoral'
) RES)

IF @NbError > 0
BEGIN
	RAISERROR(N'Erreur sur GetSocietes concernant les regions', 15, 0)
END

/* Magasin */
SET @NbError = (SELECT COUNT(*) FROM (
SELECT Societe_Id
FROM [push_reporting].[GetSocietes] ('Magasin', '415')
EXCEPT
SELECT Societe_Id
FROM DimSociete
WHERE Societe_Id = '415'
) RES)

IF @NbError > 0
BEGIN
	RAISERROR(N'Erreur sur GetSocietes concernant les magasins', 15, 0)
END