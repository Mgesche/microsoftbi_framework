CREATE PROCEDURE [push_reporting].[CreateGroupe]
	@strGroupe varchar(50)
AS
  /* =============================================================================== */
  /* Cette procédure crée un groupe a partir de son libellé                          */
  /*                                                                                 */
  /* @strGroupe : Libellé du groupe                                                  */
  /*																				 */
  /* Erreur : -1 : Deja existant                                                     */
  /*																				 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[CreateGroupe]
		@strGroupe = 'Directeurs'

SELECT	'Return Value' = @return_value

GO
*/

DECLARE @Error_Code INT

IF EXISTS (SELECT 1 FROM push_reporting.groupe WHERE strGroupe = @strGroupe)
BEGIN
	SET @Error_Code = -1;
	RETURN @Error_Code;
END
ELSE BEGIN
	SET @Error_Code =  0
END;

INSERT INTO push_reporting.groupe (strGroupe) SELECT @strGroupe;

RETURN @Error_Code;

GO