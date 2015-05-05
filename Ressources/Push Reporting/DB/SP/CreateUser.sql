CREATE PROCEDURE [push_reporting].[CreateUser]
	@strMail varchar(100)
AS
  /* =============================================================================== */
  /* Cette procédure crée un user a partir de son mail                               */
  /* Par defaut, le user est activé (il recevra les mail) donc enabled = 1           */
  /* @strMail : adresse mail                                                         */
  /*																				 */
  /* Erreur : -1 : Deja existant                                                     */
  /*																				 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[Push_CreateUser]
		@strMail = 'toto@toto975Y7455.com'

SELECT	'Return Value' = @return_value

GO
*/

DECLARE @Error_Code INT

IF EXISTS (SELECT 1 FROM push_reporting.[user] WHERE strMail = @strMail)
BEGIN
	SET @Error_Code = -1;
	RETURN @Error_Code;
END
ELSE BEGIN
	SET @Error_Code =  0
END;

INSERT INTO push_reporting.[user] (strMail, enabled) SELECT @strMail, 1;

RETURN @Error_Code;

GO