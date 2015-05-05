CREATE PROCEDURE [push_reporting].[AjoutParamSousGroupe]
	@strSousGroupe varchar(50),
	@strParam varchar(500)
	
AS
  /* ================================================================================= */
  /* Cette procédure ajoute un parametre a un sous groupe                              */
  /*                                                                                   */
  /* @strSousGroupe : Libellé du sous groupe pour l'identifier                         */
  /* @strParam : Valeur des parametres du rapport,                                     */
  /*             ex  : Code_Societe=ALB                                                */
  /*             ex2 : Code_Societe=ALB;Univers=U1;Famille=010;SousFamille=0101;Tri=CA */
  /*																				   */
  /* Erreur : -1 : Deja existant                                                       */
  /*          -4 : Sous Groupe inexistant                                              */
  /*          -6 : Param inexistant                                                    */
  /*																			       */
  /* ================================================================================= */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[AjoutParamSousGroupe]
		@strSousGroupe = 'Directeurs stocks',
		@strParam = 'Code_Societe=ALM'

SELECT	'Return Value' = @return_value

GO
*/

DECLARE @idSousGroupe INT,
        @idParam INT

SET @idSousGroupe = (SELECT idSousGroupe FROM push_reporting.sous_groupe WHERE strSousGroupe = @strSousGroupe);

SET @idParam = (SELECT idParam FROM push_reporting.param WHERE strParam = @strParam);

DECLARE @Error_Code INT

IF @idSousGroupe IS NULL
BEGIN
	SET @Error_Code = -4;
	RETURN @Error_Code;
END

IF @idParam IS NULL
BEGIN
	SET @Error_Code = -6;
	RETURN @Error_Code;
END

IF EXISTS (SELECT 1 FROM push_reporting.rel_sous_groupe_param WHERE idSousGroupe = @idSousGroupe AND idParam = @idParam)
BEGIN
	SET @Error_Code = -1;
	RETURN @Error_Code;
END
ELSE BEGIN
	SET @Error_Code =  0
END;

INSERT INTO push_reporting.rel_sous_groupe_param (idSousGroupe, idParam) SELECT @idSousGroupe, @idParam;

RETURN @Error_Code;

GO