/* Comparaison des temps */
select requete, 
SUM(CASE WHEN Environnement = 'Cube CRM V3' THEN datepart(ss, datefin-datedebut)+datepart(mi, datefin-datedebut)*60+datepart(hh, datefin-datedebut)*3600 ELSE 0 END) as temps_New,
SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN datepart(ss, datefin-datedebut)+datepart(mi, datefin-datedebut)*60+datepart(hh, datefin-datedebut)*3600 ELSE 0 END) as temps_Ancien
from TestNN_Requetes_Temps
GROUP BY requete
ORDER BY requete

/* Comparaison des résultats */
select requete, perimetre,
SUM(CASE WHEN Environnement = 'Cube CRM V3' THEN Resultat ELSE 0 END) as Resultat_New,
SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END) as Resultat_Ancien,
case when SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END) <> 0 THEN
	(SUM(CASE WHEN Environnement = 'Cube CRM V3' THEN Resultat ELSE 0 END) -
	 SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END)) /
	SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END) ELSE -1 END AS Evol
from TestNN_Requetes_Result
GROUP BY requete, perimetre
ORDER BY requete, perimetre

/* Comparaison des résultats différents */
select requete, perimetre,
SUM(CASE WHEN Environnement = 'Cube CRM V3' THEN Resultat ELSE 0 END) as Resultat_New,
SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END) as Resultat_Ancien,
case when SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END) <> 0 THEN
	(SUM(CASE WHEN Environnement = 'Cube CRM V3' THEN Resultat ELSE 0 END) -
	 SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END)) /
	SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END) ELSE -1 END AS Evol
from TestNN_Requetes_Result
GROUP BY requete, perimetre
HAVING SUM(CASE WHEN Environnement = 'Cube CRM V3' THEN Resultat ELSE 0 END) <> SUM(CASE WHEN Environnement = 'Cube CRM V2' THEN Resultat ELSE 0 END)
ORDER BY requete, perimetre