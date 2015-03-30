IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Periode_Resultat')
BEGIN
	DROP TABLE Periode_Resultat
END

CREATE TABLE Periode_Resultat (
	idObjet int,
	DtDebut date,
	DtFin date
)

INSERT INTO Periode_Resultat
-- Periode chevauchement
select b1.IdObjet, b1.DtDebut, b2.DtFin
from Periode b1
JOIN Periode b2 
  ON b1.idObjet=b2.idObjet 
 AND b2.DtDebut BETWEEN b1.DtDebut AND b1.DtFin
 AND b2.DtFin > b1.DtFin
UNION
-- Periode disjointes
select b1.idObjet, b1.DtDebut, b1.DtFin
from Periode b1
left join Periode b2 
  ON b1.idObjet=b2.idObjet 
 AND b2.DtDebut BETWEEN b1.DtDebut AND b1.DtFin
 AND b2.DtFin > b1.DtFin
left join Periode b3
  ON b1.idObjet=b3.idObjet 
 AND b1.DtDebut BETWEEN b3.DtDebut AND b3.DtFin
 AND b1.DtFin > b3.DtFin
WHERE b2.idObjet IS NULL
  AND b3.idObjet IS NULL

/* Test des resultats */
SELECT RES.*
	 , cast(TEO.DtDebut as date) as DtDebut_theorique
	 , cast(TEO.DtFin as date) as DtFin_theorique
FROM Periode_Resultat RES
LEFT join Periode_Theorique TEO
  ON TEO.idObjet = RES.idObjet