/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'push_reporting.GetDataExport', N'TF') IS NOT NULL
    DROP FUNCTION push_reporting.GetDataExport
GO

CREATE FUNCTION [push_reporting].[GetDataExport](
	@idPlanification int
) RETURNS @Exports TABLE (strURLRapport varchar(200), 
                          strNomRapport varchar(50), 
						  strNomFichier varchar(100),
						  strParam varchar(500), 
						  strTitreMail varchar(200), 
						  idTypeParam int,
						  typeExportMail varchar(50))
as
  /* =============================================================================== */
  /* Cette fonction retourne la liste des exports a traiter                          */
  /*                                                                                 */
  /* @idPlanification : Identifiant de planification : Si -1, on execute toutes les  */
  /* planifications                                                                  */
  /*																				 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT * FROM [BotanicDW_MEC].[push_reporting].[GetDataExport] (9);

GO
*/
BEGIN

/* Stockage pour le select */
IF @idPlanification = -1
BEGIN
	INSERT INTO @Exports
	SELECT DISTINCT RAP.strURLRapport, RAP.strNomRapport, RAP.strNomRapport + '_' +
		CASE WHEN TRA.strTraduction IS NOT NULL THEN TRA.strTraduction + '_' ELSE '' END +
		REPLACE(CAST(CAST(GETDATE() AS DATE) AS VARCHAR), '-', '') + 
		CASE WHEN PLA.typeExportMail = 'PDF' THEN '.pdf' ELSE '.htm' END AS strNomFichier,
	[BotanicDW_MEC].[push_reporting].[Variabilize] (PAR.strParam) AS strParam, PLA.titreMail, PAR.idTypeParam, PLA.typeExportMail
	FROM push_reporting.planification PLA
	JOIN push_reporting.rapport RAP
	  ON PLA.idRapport = RAP.idRapport
	JOIN push_reporting.param PAR
	  ON PLA.idParam = PAR.idParam
	LEFT JOIN push_reporting.[trad_libelle] TRA
	  ON TRA.strLibelle = PAR.strParam
END
ELSE
BEGIN
	INSERT INTO @Exports
	SELECT DISTINCT RAP.strURLRapport, RAP.strNomRapport, RAP.strNomRapport + '_' +
		CASE WHEN TRA.strTraduction IS NOT NULL THEN TRA.strTraduction + '_' ELSE '' END +
		REPLACE(CAST(CAST(GETDATE() AS DATE) AS VARCHAR), '-', '') + 
		CASE WHEN PLA.typeExportMail = 'PDF' THEN '.pdf' ELSE '.htm' END AS strNomFichier,
	[BotanicDW_MEC].[push_reporting].[Variabilize] (PAR.strParam) AS strParam, PLA.titreMail, PAR.idTypeParam, PLA.typeExportMail
	FROM push_reporting.planification PLA
	JOIN push_reporting.rapport RAP
	  ON PLA.idRapport = RAP.idRapport
	JOIN push_reporting.param PAR
	  ON PLA.idParam = PAR.idParam
	LEFT JOIN push_reporting.[trad_libelle] TRA
	  ON TRA.strLibelle = PAR.strParam
	WHERE PLA.idPlanification = @idPlanification
END

RETURN
END

GO