CREATE FUNCTION [Adm].[ExtractChaine] (@strChaine varchar(500), @strDebut varchar(50), @strFin varchar(50))
RETURNS varchar(500)
	
AS
  /* ===================================================================================== */
  /* Cette procédure extrait les données comprises entre deux chaines de caractéres        */
  /*                                                                                       */
  /* @strDebut : Chaine de début                                                           */
  /* @strFin : Chaine de fin                                                               */
  /*																		 		       */
  /* ===================================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@exemple varchar(100)
DECLARE	@exemple2 varchar(100)
SET @exemple = 'Toto part de la gare vers la boulangerie'
SET @exemple2 = 'Toto part de la gareversboulangerie'

SELECT [BotanicDW_MEC].[dbo].[ExtractChaine] (@exemple, 'gare', 'boulangerie')
SELECT [BotanicDW_MEC].[dbo].[ExtractChaine] (@exemple2, 'gare', 'boulangerie')

GO
*/
BEGIN

DECLARE @strResultat varchar(500)
DECLARE @iDebut int
DECLARE @iFin int
DECLARE @iLongueur int

SET @iDebut = PATINDEX('%'+@strDebut+'%', @strChaine)+LEN(@strDebut)
SET @iFin = PATINDEX('%'+@strFin+'%', @strChaine)
SET @iLongueur = @iFin-@iDebut

IF @iLongueur > 0
BEGIN
	SET @strResultat = RTRIM(LTRIM(SUBSTRING(@strChaine, @iDebut, @iLongueur)))
END
ELSE
BEGIN
	SET @strResultat = NULL
END

RETURN @strResultat;

END
GO


