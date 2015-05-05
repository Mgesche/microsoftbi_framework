CREATE PROCEDURE [push_reporting].[EvaluationPlanification]
	@strPlanif VARCHAR(50)
as
  /* =============================================================================== */
  /* Cette fonction evalue la liste des exports a traiter                            */
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
EXECUTE [push_reporting].[InsertPlanification] @strPlanif

SELECT * FROM [push_reporting].[GetListeExport](@strPlanif)
SELECT * FROM [push_reporting].[GetDataExport](-1)

DELETE FROM push_reporting.planification;

RETURN
END

GO