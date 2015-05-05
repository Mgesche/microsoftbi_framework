/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'push_reporting.GetCABloque', N'FN') IS NOT NULL
    DROP FUNCTION push_reporting.GetCABloque
GO

CREATE FUNCTION [push_reporting].[GetCABloque](
	@iDate int = 0,
    @strTypeFiltre varchar(50),
	@strFiltre varchar(500)
) RETURNS int
as
  /* =============================================================================== */
  /* Recupere le CA bloque sur le perimetre magasin                                  */
  /*                                                                                 */
  /* @iDate : Date de remontee a teter (par defaut, date de la veille)               */
  /* @strTypeFiltre  : Enseigne, Region ou Magasin                                   */
  /* @strFiltre  : Domaine a filtrer                                                 */
  /*																			                                        	 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT [BotanicDW_MEC].[push_reporting].[GetCABloque] (0, 'Enseigne', 1);

GO
*/
BEGIN

DECLARE @CABloque INT

/* Valeur par defaut de la date */
IF @iDate = 0
BEGIN
  SET @iDate = dbo.DateToInt(GETDATE()-1);
END

SET @CABloque  = (
SELECT SUM(Somme_CATTC) 
FROM [BotanicDW_MEC].[suivi_tickets].[FactTicketLocalisationBloque] TIK
JOIN [push_reporting].[GetSocietes] (@strTypeFiltre, @strFiltre) SOC
  ON SOC.Societe_id = TIK.Societe_id
WHERE DateRemontee_int = @iDate
)

RETURN @CABloque 

END

GO