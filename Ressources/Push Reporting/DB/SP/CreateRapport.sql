CREATE PROCEDURE [push_reporting].[CreateRapport]
	@strURLRapport varchar(200),
	@strNomRapport varchar(50)
AS
  /* ===================================================================================== */
  /* Cette procédure crée un parametre a partir de son type et de sa valeur                */
  /*                                                                                       */
  /* @strURLRapport : URL du rapport sur le serveur de rapport (a partir de reportserver   */
  /* @strNomRapport : Nom du rapport pour nommer le fichier (pas d'espace ou de carac spe) */
  /*																    				   */
  /* Erreur : -1 : Deja existant                                                           */
  /*																	  		    	   */
  /* ===================================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[CreateRapport]
		@strURLRapport = 'Dossier\Rapport1.rdl',
		@strNomRapport = 'Rapport1'

SELECT	'Return Value' = @return_value

GO
*/

DECLARE @Error_Code INT

IF EXISTS (SELECT 1 FROM push_reporting.rapport WHERE strURLRapport = @strURLRapport)
BEGIN
	SET @Error_Code = -1;
	RETURN @Error_Code;
END
ELSE BEGIN
	SET @Error_Code =  0
END;

INSERT INTO push_reporting.rapport (strURLRapport, strNomRapport) SELECT @strURLRapport, @strNomRapport;

RETURN @Error_Code;


GO