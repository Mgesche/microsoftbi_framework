select 	'IDT_Classe_Temps' AS Domaine, WRK.DIMENTION_KEY as DIMENTION_KEY, COUNT(*) as NB, 
		'delete from MTX.FactClasseClient_Temps_WRK where DIMENTION_KEY = '''+CAST(WRK.DIMENTION_KEY as varchar)+'''' as Requete
from MTX.FactClasseClient_Temps_WRK WRK
left join DimTemps DIM
  ON WRK.DIMENTION_KEY = DIM.Temps_Id
where DIM.Temps_Id is null
group by WRK.DIMENTION_KEY
union
select 'IDT_Classe' AS Domaine, WRK.DIMENTION_KEY as DIMENTION_KEY, COUNT(*) as NB, 
		'delete from MTX.FactClasseClient_Classe_WRK where DIMENTION_KEY = '''+CAST(WRK.DIMENTION_KEY as varchar)+'''' as Requete
from MTX.FactClasseClient_Classe_WRK WRK
left join DimClasseClient DIM
  ON WRK.DIMENTION_KEY = DIM.id_classe
where DIM.id_classe is null
group by WRK.DIMENTION_KEY
union
select 'IDT_Profil_Temps' AS Domaine, WRK.DIMENTION_KEY as DIMENTION_KEY, COUNT(*) as NB, 
		'delete from MTX.FactProfilClient_Temps_WRK where DIMENTION_KEY = '''+CAST(WRK.DIMENTION_KEY as varchar)+'''' as Requete
from MTX.FactProfilClient_Temps_WRK WRK
left join DimTemps DIM
  ON WRK.DIMENTION_KEY = DIM.Temps_Id
where DIM.Temps_Id is null
group by WRK.DIMENTION_KEY
union
select 'IDT_Profil' AS Domaine, WRK.DIMENTION_KEY as DIMENTION_KEY, COUNT(*) as NB, 
		'delete from MTX.FactProfilClient_Profil_WRK where DIMENTION_KEY = '''+CAST(WRK.DIMENTION_KEY as varchar)+'''' as Requete
from MTX.FactProfilClient_Profil_WRK WRK
left join DimProfilClient DIM
  ON WRK.DIMENTION_KEY = DIM.profil_id
where DIM.profil_id is null
group by WRK.DIMENTION_KEY