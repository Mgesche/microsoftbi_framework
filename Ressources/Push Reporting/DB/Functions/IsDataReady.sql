/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'push_reporting.IsDataReady', N'FN') IS NOT NULL
    DROP FUNCTION push_reporting.IsDataReady
GO

CREATE FUNCTION [push_reporting].[IsDataReady](
  @iDate int = 0,
  @pcValidite int = 95,
  @strTypeFiltre varchar(50),
	@strFiltre varchar(500)
) RETURNS int
as
  /* =============================================================================== */
  /* Teste la remontée des données au niveau du decisionnel pour une enseigne, une   */
  /* region ou un magasin                                                            */
  /*                                                                                 */
  /* @iDate : Date de remontee a teter (par defaut, date de la veille)               */
  /* @pcValidite : Pourcentage en dessous duquel les donnees sont KO (95 par defaut) */
  /* @strTypeFiltre  : Enseigne, Region ou Magasin                                   */
  /* @strFiltre  : Domaine a filtrer                                                 */
  /*																				                                         */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady] ('Enseigne', 1);

GO
*/
BEGIN

DECLARE @isDataReady int
  
/* Recuperation du CA attendu */
DECLARE @CAAttendu INT
DECLARE @CAEffectif INT
DECLARE @CABloque INT

SET @CAEffectif = [push_reporting].[GetCAEffectif] (@iDate, @strTypeFiltre, @strFiltre)
SET @CABloque = [push_reporting].[GetCABloque] (@iDate, @strTypeFiltre, @strFiltre)
SET @CAAttendu = @CAEffectif + @CABloque

IF @CAEffectif = 0
BEGIN
 SET @isDataReady = 0
END ELSE BEGIN
  IF (@CAEffectif*1.0/@CAAttendu*1.0)*100 >= @pcValidite
  BEGIN
    SET @isDataReady = 1
  END ELSE BEGIN
    SET @isDataReady = 0
  END
END

RETURN @isDataReady

END

GO