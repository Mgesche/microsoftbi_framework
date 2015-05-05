CREATE PROCEDURE [push_reporting].[AjoutRapportSousGroupe]
	@strSousGroupe varchar(50),
	@strURLRapport varchar(200),
	@typeExportMail varchar(50),
	@TitreMail varchar(200),
	@strPlanif varchar(50)
	
AS
  /* =============================================================================== */
  /* Cette procédure ajoute un rapport a un sous groupe                              */
  /*                                                                                 */
  /* @strURLRapport : URL du rapport pour l'identifier                               */
  /* @strSousGroupe : Libellé du sous groupe pour l'identifier                       */
  /* @typeExportMail : Type d'export :                                               */
  /*                        MAIL : Mail simple avec le rapport en piece jointe       */
  /*                        HTML : Rapport joint en HTML                             */
  /*                        GOFAST : Fichier déposé sur GoFast                       */
  /*                        ARCHIVE : Fichier déposé sur le dossier archive          */
  /*                        PDF : Mail simple avec le rapport en PDF en piece jointe */
  /* @TitreMail : Dans le cas des envois de mails, titre du mail. Lié au sous groupe */
  /* car il peux varier en cas de parametres différents (ex CA Littoral ou CA total  */
  /* @strPlanif : Identifiant de planification pour déterminer quels rapprot doivent */
  /* Par exemple, on aura un strPlanif = 'STOCK' pour les rapports de stocks         */
  /* quotidien et a la fin du package de chargement des stocks, on appelera le       */
  /* package d'export avec le parametre 'STOCK', qui lui meme executera toutes les   */
  /* planification 'STOCK'                                                           */
  /*																				 */
  /* Erreur : -1 : Deja existant                                                     */
  /*          -4 : Sous Groupe inexistant                                            */
  /*          -5 : Rapport inexistant                                                */
  /*																				 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[AjoutRapportSousGroupe]
		@strSousGroupe = 'Directeurs stocks',
		@strURLRapport = 'Dossier\Rapport1.rdl',
		@strPlanif = 'STOCK'

SELECT	'Return Value' = @return_value

GO
*/

DECLARE @idRapport INT,
        @idSousGroupe INT

SET @idRapport = (SELECT idRapport FROM push_reporting.rapport WHERE strURLRapport = @strURLRapport);

SET @idSousGroupe = (SELECT idSousGroupe FROM push_reporting.sous_groupe WHERE strSousGroupe = @strSousGroupe);

DECLARE @Error_Code INT

IF @idSousGroupe IS NULL
BEGIN
	SET @Error_Code = -4;
	RETURN @Error_Code;
END

IF @idRapport IS NULL
BEGIN
	SET @Error_Code = -5;
	RETURN @Error_Code;
END

IF EXISTS (SELECT 1 FROM push_reporting.rel_sous_groupe_rapport WHERE idSousGroupe = @idSousGroupe AND idRapport = @idRapport)
BEGIN
	SET @Error_Code = -1;
	RETURN @Error_Code;
END
ELSE BEGIN
	SET @Error_Code =  0
END;

INSERT INTO push_reporting.rel_sous_groupe_rapport (idSousGroupe, idRapport, strPlanif, titreMail, typeExportMail) SELECT @idSousGroupe, @idRapport, @strPlanif, @TitreMail, @typeExportMail;

RETURN @Error_Code;


GO
