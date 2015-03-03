alter table Adm.ODS_Chargement
add idResultatTest int;

UPDATE Adm.ODS_Chargement
SET idResultatTest = 1;