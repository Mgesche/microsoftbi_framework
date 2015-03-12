WITH 

Periode_Base AS (
--on prépare à l'alignement des dates de début pour les périodes qui se chevauchent grâce au calcul du rownum_start
SELECT idObjet			
	 , DtDebut
	 , DtFin
	 , ROW_NUMBER() over(PARTITION BY idObjet 
						 ORDER BY DtDebut ) as rownum_start
FROM Periode
)

, Periode_Propre AS (
--on aligne les dates de début pour les périodes qui se chevauchent 
--et on prépare au nettoyage des périodes inclus les unes dans les autres grâce au rownum_start et rownum_end
select	distinct b1.idObjet
	  , case when b1.DtDebut > b2.DtFin 
	          and b1.DtDebut < b2.DtFin 
			 then b2.DtDebut 
			 else b1.DtDebut 
	    end as DtDebut
	  , b1.DtFin 
	  , ROW_NUMBER() over (PARTITION BY b1.idObjet 
						   ORDER BY case when b1.DtDebut > b2.DtDebut 
						                  and b1.DtDebut < b2.DtFin 
										 then b2.DtDebut 
										 else b1.DtDebut 
									end, 
									b1.DtFin desc) rownum_start
	  , ROW_NUMBER() over (PARTITION BY b1.idObjet 
						   ORDER BY b1.DtFin desc, 
									case when b1.DtDebut > b2.DtDebut 
									      and b1.DtDebut < b2.DtFin 
									then b2.DtDebut 
									else b1.DtDebut 
									end) rownum_end
from Periode_Base b1
LEFT JOIN Periode_Base b2 
  ON b1.idObjet=b2.idObjet 
 and b1.rownum_start=b2.rownum_start+1 
)

, Periode_Finale as (
--on retire les périodes de validités inclus les unes dans les autres
SELECT b1.idObjet
	 , cast(b1.DtDebut as date) as DtDebut
	 , cast(b1.DtFin as date) as DtFin

FROM Periode_Propre b1

LEFT JOIN Periode_Propre b2 
  ON b1.idObjet=b2.idObjet 
 and b1.rownum_start=b2.rownum_start+1 
 and b1.DtFin between b2.DtDebut and b2.DtFin

LEFT JOIN Periode_Propre b3 
  ON b1.idObjet=b3.idObjet 
 and b1.rownum_end=b3.rownum_end+1 
 and b1.DtFin between b3.DtDebut and b3.DtFin

WHERE b2.idObjet is null 
  and b3.idObjet is null 

)

SELECT FIN.*
	 , cast(TEO.DtDebut as date) as DtDebut_theorique
	 , cast(TEO.DtFin as date) as DtFin_theorique
FROM Periode_Finale FIN
join Periode_Theorique TEO
  ON TEO.idObjet = FIN.idObjet