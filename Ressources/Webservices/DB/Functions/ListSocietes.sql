/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'Webservices.ListSocietes', N'TF') IS NOT NULL
    DROP FUNCTION Webservices.ListSocietes
GO

CREATE FUNCTION [Webservices].[ListSocietes](
	@strTypeFiltre varchar(50),
	@strFiltre varchar(500)
) RETURNS @ListeSociete TABLE (Societe_Id int)
as
  /* =============================================================================== */
  /* Cette fonction retourne la liste des societes du perimetre                      */
  /*                                                                                 */
  /* @strTypeFiltre  : Enseigne, Region ou Magasin                                   */
  /* @strFiltre  : Domaine a filtrer (separe au besoin par des virgules)             */
  /*																			                                        	 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT * FROM [BotanicDW_MEC].[Webservices].[ListSocietes] ('Enseigne', 1);

GO
*/
BEGIN
  
/* Gestion de plusieurs entites dans le domaine a filtrer */
DECLARE @filtre VARCHAR(50)

DECLARE filtreCustor CURSOR FOR 
SELECT * FROM [dbo].[fctSplitToChar] (@strFiltre, ',')

OPEN filtreCustor

FETCH NEXT FROM filtreCustor 
INTO @filtre

WHILE @@FETCH_STATUS = 0
BEGIN
	
  IF @strTypeFiltre = 'Enseigne'
  BEGIN
    INSERT INTO @ListeSociete
    SELECT Societe_Id
    FROM DimSociete
    WHERE enseigne_id = @filtre
  END
  
  IF @strTypeFiltre = 'Region'
  BEGIN
    INSERT INTO @ListeSociete
    SELECT Societe_Id
    FROM DimSociete
    WHERE RegionCommerciale = @filtre
  END
  
  IF @strTypeFiltre = 'Magasin'
  BEGIN
    INSERT INTO @ListeSociete
    SELECT Societe_Id
    FROM DimSociete
    WHERE CodeSociete = @filtre
  END
  
  FETCH NEXT FROM filtreCustor 
  INTO @filtre
  
END

CLOSE filtreCustor;
DEALLOCATE filtreCustor;

RETURN

END

GO