IF object_id(N'push_reporting.paramUserGroupe', N'P') IS NOT NULL
    DROP PROCEDURE push_reporting.paramUserGroupe
GO

CREATE PROCEDURE [push_reporting].[paramUserGroupe]
	@strMail varchar(100),
  @strMailPrec varchar(100),
	@strGroupe varchar(50),
	@sensAction int
AS
  /* =============================================================================== */
  /* Cette procédure cree uniquement le user s'il n'existe pas encore.               */
  /* S'il existait deja, elle ajoute un user a un groupe si sensAction est 1         */
  /* et supprime le user du groupe si sensAction est 0                               */
  /*                                                                                 */
  /* @strMail : Mail de l'utilisateur pour l'identifier                              */
  /* @strMailPrec : Mail precedant pour gerer le chargement d'un ancien user         */
  /* @strGroupe : Libellé du groupe pour l'identifier                                */
  /* @sensAction : 0 pour supprimer, 1 pour inserer                                  */
  /*																		                                         		 */
  /* =============================================================================== */
  
DECLARE @idUser INT

SET @idUser = (SELECT idUser FROM push_reporting.[user] WHERE strMail = @strMail);

IF @idUser IS NULL
BEGIN
	EXEC [push_reporting].[CreateUser] @strMail
  RETURN 0
END

IF @idUser > 0 AND @strMailPrec = @strMail
BEGIN
  
  IF @sensAction = 0
  BEGIN
    EXEC push_reporting.SupprUserGroupe @strMail, @strGroupe
  END
  ELSE
  BEGIN
    EXEC push_reporting.AjoutUserGroupe @strMail, @strGroupe
  END
  RETURN 0
END
