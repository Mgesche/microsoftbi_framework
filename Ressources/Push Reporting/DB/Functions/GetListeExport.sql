CREATE FUNCTION [push_reporting].[GetListeExport](
	@strPlanif VARCHAR(50)
) RETURNS @Exports TABLE (strURLRapport varchar(200), 
                          strNomRapport varchar(50), 
						  strParam varchar(500), 
						  idTypeParam int)
as
  /* =============================================================================== */
  /* Cette fonction retourne la liste des exports a traiter                          */
  /*                                                                                 */
  /* @strPlanif : Identifiant de planification pour déterminer quels rapprot doivent */
  /* Par exemple, on aura un strPlanif = 'STOCK' pour les rapports de stocks         */
  /* quotidien et a la fin du package de chargement des stocks, on appelera le       */
  /* package d'export avec le parametre 'STOCK', qui lui meme executera toutes les   */
  /* planification 'STOCK'                                                           */
  /*																				 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT * FROM [BotanicDW_MEC].[push_reporting].[GetListeExport] ('STOCK');

GO
*/
BEGIN

/* Stockage pour le select */
INSERT INTO @Exports
SELECT DISTINCT RAP.strURLRapport, RAP.strNomRapport, PAR.strParam, PAR.idTypeParam
FROM push_reporting.sous_groupe SGR
JOIN push_reporting.rel_sous_groupe_rapport RSR
  ON SGR.idSousGroupe = RSR.idSousGroupe
JOIN push_reporting.rapport RAP
  ON RSR.idRapport = RAP.idRapport
JOIN push_reporting.rel_sous_groupe_param RSP
  ON SGR.idSousGroupe = RSP.idSousGroupe
JOIN push_reporting.param PAR
  ON RSP.idParam = PAR.idParam
WHERE RSR.strPlanif = @strPlanif

RETURN
END

GO