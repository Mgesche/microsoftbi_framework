CREATE PROCEDURE [push_reporting].[AjoutSousGroupeGroupe]
	@strSousGroupe varchar(50),
	@strGroupe varchar(50)
AS
  /* ================================================================================== */
  /* Cette procédure ajoute un sous groupe a un groupe                                  */
  /*                                                                                    */
  /* @strSousGroupe : Libellé du sous groupe                                            */
  /* @strGroupe : Libellé du groupe                                                     */
  /*																				    */
  /* Erreur : -1 : Deja existant                                                        */
  /*          -2 : Groupe inexistant                                                    */
  /*																				    */
  /* ================================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[AjoutSousGroupeGroupe]
		@strSousGroupe = 'Directeurs stocks',
		@strGroupe = 'Directeurs'

SELECT	'Return Value' = @return_value

GO
*/

DECLARE @idGroupe INT

SET @idGroupe = (SELECT idGroupe FROM push_reporting.groupe WHERE strGroupe = @strGroupe);

DECLARE @Error_Code INT

IF @idGroupe IS NULL
BEGIN
	SET @Error_Code = -2;
	RETURN @Error_Code;
END

IF EXISTS (SELECT 1 FROM push_reporting.sous_groupe WHERE strSousGroupe = @strSousGroupe)
BEGIN
	SET @Error_Code = -1;
	RETURN @Error_Code;
END
ELSE BEGIN
	SET @Error_Code =  0
END;

INSERT INTO push_reporting.sous_groupe (idGroupe, strSousGroupe) SELECT @idGroupe, @strSousGroupe;

RETURN @Error_Code;


GO


