/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'push_reporting.IsDataReady_Push', N'FN') IS NOT NULL
    DROP FUNCTION push_reporting.IsDataReady
GO

CREATE FUNCTION [push_reporting].[IsDataReady_Push](
  @iDate int = 0,
  @pcValidite int = 95,
  @strEnseigne varchar(50), 
  @strRegion varchar(50),
  @strMagasin varchar(50)  
) RETURNS int
as
  /* =============================================================================== */
  /* Teste la remontée des données au niveau du decisionnel pour une enseigne, une   */
  /* region ou un magasin. Version pour le push donc sans renseigner le type mais    */
  /* en donnant les trois variables                                                  */
  /*                                                                                 */
  /* @iDate : Date de remontee a teter (par defaut, date de la veille)               */
  /* @pcValidite : Pourcentage en dessous duquel les donnees sont KO (95 par defaut) */
  /* @strEnseigne  : Enseigne renseignee ou non                                      */
  /* @strRegion  : Region renseignee ou non                                          */
  /* @strMagasin  : Magasin renseignee ou non                                        */
  /*																							            											 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady_Push] ('1', '', '');

GO
*/
BEGIN

DECLARE @strTypeRegion VARCHAR(50)
DECLARE @isDataReady int

IF COALESCE(@strEnseigne, '') <> ''
BEGIN
	SET @strTypeRegion = 'Enseigne'
	SET @isDataReady = [push_reporting].[IsDataReady] (@iDate, @pcValidite, 'Enseigne', @strEnseigne);
END

IF COALESCE(@strRegion, '') <> ''
BEGIN
	SET @strTypeRegion = 'Region'
	SET @isDataReady = [push_reporting].[IsDataReady] (@iDate, @pcValidite, 'Region', @strRegion);
END

IF COALESCE(@strMagasin, '') <> ''
BEGIN
	SET @strTypeRegion = 'Magasin'
	SET @isDataReady = [push_reporting].[IsDataReady] (@iDate, @pcValidite, 'Magasin', @strMagasin);
END

RETURN @isDataReady

END

GO