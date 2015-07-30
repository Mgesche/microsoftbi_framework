select 'IDT_Classe_Temps' AS Domaine, FAC.IDT_Classe_Temps as MATRIX_KEY, COUNT(*) as NB
from dimclient FAC
left join MTX.FactClasseClient_Temps_WRK WRK
  ON WRK.MATRIX_KEY = coalesce(FAC.IDT_Classe_Temps, -1)
where WRK.MATRIX_KEY is null
group by FAC.IDT_Classe_Temps
union
select 'IDT_Classe' AS Domaine, FAC.IDT_Classe as MATRIX_KEY, COUNT(*) as NB
from dimclient FAC
left join MTX.FactClasseClient_Classe_WRK WRK
  ON WRK.MATRIX_KEY = coalesce(FAC.IDT_Classe, -1)
where WRK.MATRIX_KEY is null
group by FAC.IDT_Classe
union
select 'IDT_Profil_Temps' AS Domaine, FAC.IDT_Profil_Temps as MATRIX_KEY, COUNT(*) as NB
from dimclient FAC
left join MTX.FactProfilClient_Temps_WRK WRK
  ON WRK.MATRIX_KEY = coalesce(FAC.IDT_Profil_Temps, -1)
where WRK.MATRIX_KEY is null
group by FAC.IDT_Profil_Temps
union
select 'IDT_Profil' AS Domaine, FAC.IDT_Profil as MATRIX_KEY, COUNT(*) as NB
from dimclient FAC
left join MTX.FactProfilClient_Profil_WRK WRK
  ON WRK.MATRIX_KEY = coalesce(FAC.IDT_Profil, -1)
where WRK.MATRIX_KEY is null
group by FAC.IDT_Profil