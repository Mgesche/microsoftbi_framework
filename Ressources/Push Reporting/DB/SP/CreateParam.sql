CREATE PROCEDURE [push_reporting].[CreateParam]
	@strParam varchar(500),
	@idTypeParam int
AS
  /* ==================================================================================== */
  /* Cette procédure crée un parametre a partir de son type et de sa valeur               */
  /*                                                                                      */
  /* @strTypeParam : Type de parametre du rapport, ex : Code Société                      */
  /* @strParam : Valeur des parametres du rapport,                                        */
  /*             ex  : Code_Societe=ALB                                                   */
  /*             ex2 : Code_Societe=ALB;Univers=U1;Famille=010;SousFamille=0101;Tri=CA    */
  /* @idTypeParam : 1 : Code_Societe                                                      */
  /*                2 : Code_Societe, Univers, Famille, SousFamille, Tri                  */
  /*                3 : Region                                                            */
  /*                4 : Pas de parametres                                                 */
  /*                5 : Region, DateDebutN, DateFinN, DateDebutN_1, DateFinN_1            */
  /*			    6 : DateDebutN, DateFinN, DateDebutN_1, DateFinN_1                    */
  /*                7 : Enseigne, Famille, DateDebutN, DateFinN, DateDebutN_1, DateFinN_1 */
  /*																				      */
  /* Erreur : -1 : Deja existant                                                          */
  /*																				      */
  /* ==================================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[CreateParam]
		@strParam = 'Region=B_ALS Alsace est',
		@idTypeParam = '3'

SELECT	'Return Value' = @return_value

GO
*/

DECLARE @Error_Code INT

IF EXISTS (SELECT 1 FROM push_reporting.param WHERE strParam = @strParam AND idTypeParam = @idTypeParam)
BEGIN
	SET @Error_Code = -1;
	RETURN @Error_Code;
END
ELSE BEGIN
	SET @Error_Code =  0
END;

INSERT INTO push_reporting.param (strParam, idTypeParam) SELECT @strParam, @idTypeParam;

RETURN @Error_Code;

GO