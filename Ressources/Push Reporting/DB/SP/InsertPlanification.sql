CREATE PROCEDURE [push_reporting].[InsertPlanification]
	@strPlanif VARCHAR(50)
as
  /* =============================================================================== */
  /* Cette fonction stocke la liste des exports a traiter                            */
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

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[InsertPlanification]
		@strPlanif = 'STOCK'

SELECT	'Return Value' = @return_value

GO
*/
BEGIN

/* Stockage pour l'execution en parallele */
INSERT INTO push_reporting.planification (idRapport, idSousGroupe, idParam, titreMail, dt_creation, strPlanif, typeExportMail)
SELECT DISTINCT RAP.idRapport, SGR.idSousGroupe, PAR.idParam, RSR.titreMail, GETDATE() AS dt_creation, @strPlanif as strPlanif, RSR.typeExportMail
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