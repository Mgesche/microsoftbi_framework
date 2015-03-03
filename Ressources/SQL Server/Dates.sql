------------------------------- 
-- Nicolas Souquet - 29/03/2011 
------------------------------- 
SELECT  --*** Semaine 
  DATEADD(week, DATEDIFF(week, 0, GETDATE()) - 1, 0) AS premier_jour_de_la_semaine_precedente 
  , DATEADD(week, DATEDIFF(week, 0, GETDATE()), 0) AS premier_jour_de_la_semaine_courante 
  , DATEADD(week, DATEDIFF(week, 0, GETDATE()) + 1, 0) AS premier_jour_de_la_semaine_prochaine 
  --- 
  , DATEADD(DAY, -1, DATEADD(week, DATEDIFF(week, 0, GETDATE()), 0)) AS dernier_jour_de_la_semaine_precedente 
  , DATEADD(DAY, -1, DATEADD(week, DATEDIFF(week, 0, GETDATE()) + 1, 0)) AS dernier_jour_de_la_semaine_courante 
  , DATEADD(DAY, -1, DATEADD(week, DATEDIFF(week, 0, GETDATE()) + 2, 0)) AS dernier_jour_de_la_semaine_prochaine 
  --*** Mois 
  , DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0) AS premier_jour_du_mois_precedent 
  , DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) AS premier_jour_du_mois_courant  
  , DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0) AS premier_jour_du_mois_prochain 
  --- 
  , DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) AS dernier_jour_du_mois_precedent 
  , DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)) AS dernier_jour_du_mois_courant  
  , DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 2, 0)) AS dernier_jour_du_mois_prochain 
  --*** Trimestre 
  , DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) - 1, 0) AS premier_jour_du_trimestre_precedent 
  , DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()), 0) AS permier_jour_du_trimestre_courant 
  , DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 1, 0) AS premier_jour_du_trimestre_prochain 
  --- 
  , DATEADD(DAY, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()), 0)) AS dernier_jour_du_trimestre_precedent 
  , DATEADD(DAY, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 1, 0)) AS dernier_jour_du_trimestre_courant 
  , DATEADD(DAY, -1, DATEADD(quarter, DATEDIFF(quarter, 0, GETDATE()) + 2, 0)) AS dernier_jour_du_trimestre_prochain 
  --*** Semestre 
  , DATEADD(MONTH, ((DATEDIFF(quarter, 0, GETDATE()) / 2) * 6) - 6, 0) AS premier_jour_du_semestre_precedent 
  , DATEADD(MONTH, (DATEDIFF(quarter, 0, GETDATE()) / 2) * 6, 0) AS premier_jour_du_semestre_courant 
  , DATEADD(MONTH, ((DATEDIFF(quarter, 0, GETDATE()) / 2) * 6) + 6, 0) AS premier_jour_du_semestre_prochain 
  --- 
  , DATEADD(DAY, -1, DATEADD(MONTH, (DATEDIFF(quarter, 0, GETDATE()) / 2) * 6, 0)) AS dernier_jour_du_semestre_precedent 
  , DATEADD(DAY, -1, DATEADD(MONTH, ((DATEDIFF(quarter, 0, GETDATE()) / 2) * 6) + 6, 0)) AS dernier_jour_du_semestre_courant 
  , DATEADD(DAY, -1, DATEADD(MONTH, ((DATEDIFF(quarter, 0, GETDATE()) / 2) * 6) + 12, 0)) AS dernier_jour_du_semestre_prochain 
  --*** Annee 
  , DATEADD(YEAR , DATEDIFF(YEAR, 0, GETDATE()) - 1, 0) AS premier_jour_annee_precedente 
  , DATEADD(YEAR , DATEDIFF(YEAR, 0, GETDATE()), 0) AS premier_jour_annee_courante 
  , DATEADD(YEAR , DATEDIFF(YEAR, 0, GETDATE()) + 1, 0) AS premier_jour_annee_suivante 
  --- 
  , DATEADD(DAY, -1, DATEADD(YEAR , DATEDIFF(YEAR, 0, GETDATE()), 0)) AS dernier_jour_annee_precedente 
  , DATEADD(DAY, -1, DATEADD(YEAR , DATEDIFF(YEAR, 0, GETDATE()) + 1, 0)) AS dernier_jour_annee_courante 
  , DATEADD(DAY, -1, DATEADD(YEAR , DATEDIFF(YEAR, 0, GETDATE()) + 2, 0)) AS dernier_jour_annee_suivante 
  --*** Siècle 
  , DATEADD(YEAR, -YEAR(GETDATE()) % 100, DATEADD(YEAR , DATEDIFF(YEAR, 0, GETDATE()), 0)) AS premier_jour_du_siecle_courant 
  , DATEADD(YEAR, -YEAR(GETDATE()) % 100 + 100, DATEADD(DAY, -1, DATEADD(YEAR , DATEDIFF(YEAR, 0, GETDATE()), 0))) AS dernier_jour_du_siecle_courant
