CREATE VIEW [push_reporting].[GetInfos]
AS 
SELECT USR.idUser, USR.strMail as Email, USR.enabled as Actif, GRP.strGroupe as Groupe,
SGR.strSousGroupe as SousGroupe, REL_RAP.titreMail, PAR.strDescription,   
 REL_RAP.typeExportMail, REL_RAP.strPlanif as Planif, RAP.strNomRapport, RAP.strURLRapport
FROM push_reporting.[user] USR
JOIN push_reporting.rel_groupe_user REL_GRP
  ON USR.idUser = REL_GRP.idUser
JOIN push_reporting.groupe GRP
  ON GRP.idGroupe = REL_GRP.idGroupe
JOIN push_reporting.sous_groupe SGR
  ON SGR.idGroupe = GRP.idGroupe
JOIN push_reporting.rel_sous_groupe_rapport REL_RAP
  ON REL_RAP.idSousGroupe = SGR.idGroupe
JOIN push_reporting.rapport RAP
  ON REL_RAP.idRapport = RAP.idRapport
JOIN push_reporting.rel_sous_groupe_param REL_PAR
  ON REL_PAR.idSousGroupe = SGR.idSousGroupe
JOIN push_reporting.param PAR
  ON REL_PAR.idParam = PAR.idParam
JOIN push_reporting.trad_libelle TRA
  ON TRA.strLibelle = PAR.strParam