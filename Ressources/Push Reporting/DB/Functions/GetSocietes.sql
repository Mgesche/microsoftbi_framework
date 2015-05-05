/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'push_reporting.GetSocietes', N'TF') IS NOT NULL
    DROP FUNCTION push_reporting.GetSocietes
GO

CREATE FUNCTION [push_reporting].[GetSocietes](
	@strTypeFiltre varchar(50),
	@strFiltre varchar(500)
) RETURNS @ListeSociete TABLE (Societe_Id int)
as
  /* =============================================================================== */
  /* Cette fonction retourne la liste des societes du perimetre                      */
  /*                                                                                 */
  /* @strTypeFiltre  : Enseigne, Region ou Magasin                                   */
  /* @strFiltre  : Domaine a filtrer                                                 */
  /*																			                                        	 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT * FROM [BotanicDW_MEC].[push_reporting].[GetSocietes] ('Enseigne', 1);

GO
*/
BEGIN
	
IF @strTypeFiltre = 'Enseigne'
BEGIN
  INSERT INTO @ListeSociete
  SELECT Societe_Id
  FROM DimSociete
  WHERE enseigne_id = @strFiltre
END

IF @strTypeFiltre = 'Region'
BEGIN
  INSERT INTO @ListeSociete
  SELECT Societe_Id
  FROM DimSociete
  WHERE CodeRegionCommerciale = @strFiltre
END

IF @strTypeFiltre = 'Magasin'
BEGIN
  INSERT INTO @ListeSociete
  SELECT Societe_Id
  FROM DimSociete
  WHERE Societe_Id = @strFiltre
END

RETURN

END

GO