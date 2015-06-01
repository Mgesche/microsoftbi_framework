/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'Webservices.GetCABloque', N'FN') IS NOT NULL
    DROP FUNCTION Webservices.GetCABloque
GO

CREATE FUNCTION [Webservices].[GetCABloque](
	@iDateFrom VARCHAR(10) = '0',
  @iDateTo VARCHAR(10) = '0',
  @strTypeFiltre varchar(50),
	@strFiltre varchar(500)
) RETURNS int
as
  /* =============================================================================== */
  /* Recupere le CA bloque sur le perimetre magasin                                  */
  /*                                                                                 */
  /* @iDateFrom : Date de remontee a tester (par defaut, date de la veille) : borne inf  */
  /* @iDateTo : Date de remontee a tester (par defaut, date de la veille) : borne sup  */
  /* @strTypeFiltre  : Enseigne, Region ou Magasin                                   */
  /* @strFiltre  : Domaine a filtrer                                                 */
  /*																			                                        	 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT [BotanicDW_MEC].[Webservices].[GetCABloque] (0, 'Enseigne', 1);

GO
*/
BEGIN

DECLARE @CABloque INT

DECLARE @iDateFrom_Int INT
DECLARE @iDateTo_Int INT

/* Valeur par defaut de la date */
IF @iDateFrom = '0'
BEGIN
  SET @iDateFrom_Int = dbo.DateToInt(GETDATE()-1);
END
ELSE
BEGIN
  SET @iDateFrom_Int = dbo.DateToInt(@iDateFrom);
END
IF @iDateTo = '0'
BEGIN
  SET @iDateTo_Int = dbo.DateToInt(GETDATE()-1);
END
ELSE
BEGIN
  SET @iDateTo_Int = dbo.DateToInt(@iDateTo);
END

SET @CABloque  = (
SELECT SUM(Somme_CATTC) 
FROM [suivi_tickets].[FactTicketLocalisationBloque] TIK
JOIN [Webservices].[ListSocietes] (@strTypeFiltre, @strFiltre) SOC
  ON SOC.Societe_id = TIK.Societe_id
WHERE DateTicket_int BETWEEN @iDateFrom_Int AND @iDateTo_Int
)

RETURN @CABloque 

END

GO