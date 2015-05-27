CREATE PROCEDURE [push_reporting].[SupprUserGroupe]
	@strMail varchar(100),
	@strGroupe varchar(50)
AS
  /* =============================================================================== */
  /* Cette procédure supprime un user d un groupe                                    */
  /*                                                                                 */
  /* @strMail : Mail de l'utilisateur pour l'identifier                              */
  /* @strGroupe : Libellé du groupe pour l'identifier                                */
  /*																				 */
  /* Erreur : -1 : pas existant                                                      */
  /*          -2 : Groupe inexistant                                                 */
  /*          -3 : User inexistant                                                   */
  /*																				 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[SupprUserGroupe]
		@strMail = 'toto@toto975Y7455.com',
		@strGroupe = 'Directeurs'

SELECT	'Return Value' = @return_value

GO
*/

DECLARE @idUser INT,
        @idGroupe INT

SET @idUser = (SELECT idUser FROM push_reporting.[user] WHERE strMail = @strMail);

SET @idGroupe = (SELECT idGroupe FROM push_reporting.groupe WHERE strGroupe = @strGroupe);

DECLARE @Error_Code INT

IF @idGroupe IS NULL
BEGIN
	SET @Error_Code = -2;
	RETURN @Error_Code;
END

IF @idUser IS NULL
BEGIN
	SET @Error_Code = -3;
	RETURN @Error_Code;
END

IF NOT EXISTS (SELECT 1 FROM push_reporting.rel_groupe_user WHERE idGroupe = @idGroupe AND idUser = @idUser)
BEGIN
	SET @Error_Code = -1;
	RETURN @Error_Code;
END
ELSE BEGIN
	SET @Error_Code =  0
END;

DELETE FROM push_reporting.rel_groupe_user WHERE idGroupe = @idGroupe AND idUser = @idUser;

RETURN @Error_Code;


GO


