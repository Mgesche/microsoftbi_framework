/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'Webservices.GetStatutRemonteeTicket', N'FN') IS NOT NULL
    DROP FUNCTION Webservices.GetStatutRemonteeTicket
GO

CREATE FUNCTION [Webservices].[GetStatutRemonteeTicket](
	@iDateFrom VARCHAR(10) = '0',
  @iDateTo VARCHAR(10) = '0',
  @strTypeFiltre varchar(50),
	@strFiltre varchar(500)
) RETURNS varchar(50)
as
  /* =============================================================================== */
  /* Teste la remontée des données au niveau du decisionnel pour une enseigne, une   */
  /* region ou un magasin                                                            */
  /*                                                                                 */
  /* @iDateFrom : Date de remontee a tester (par defaut, date de la veille) : borne inf  */
  /* @iDateTo : Date de remontee a tester (par defaut, date de la veille) : borne sup  */
  /* @strTypeFiltre  : Enseigne, Region ou Magasin                                   */
  /* @strFiltre  : Domaine a filtrer                                                 */
  /*																				                                         */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT [BotanicDW_MEC].[Webservices].[GetStatutRemonteeTicket] (0, 'Enseigne', 1);

GO
*/
BEGIN

DECLARE @statut varchar(50)
DECLARE @parameter_cible varchar(50)
  
/* Recuperation du CA attendu */
DECLARE @CAAttendu INT
DECLARE @CAEffectif INT
DECLARE @CABloque INT
DECLARE @pcCA DECIMAL(18,5)

SET @CAEffectif = [Webservices].[GetCAEffectif] (@iDateFrom, @iDateTo, @strTypeFiltre, @strFiltre)
SET @CABloque = [Webservices].[GetCABloque] (@iDateFrom, @iDateTo, @strTypeFiltre, @strFiltre)
SET @CAAttendu = @CAEffectif + @CABloque

IF @CAAttendu = 0
BEGIN
  SET @pcCA = 1
END ELSE BEGIN
  SET @pcCA = @CAEffectif / @CAAttendu
END

/* Choix du parameter_cible */
IF @strTypeFiltre = 'Enseigne'
BEGIN
  SET @parameter_cible = 'push_reporting_enseigne'
END
IF @strTypeFiltre = 'Region'
BEGIN
  SET @parameter_cible = 'push_reporting_region'
END
IF @strTypeFiltre = 'Magasin'
BEGIN
  SET @parameter_cible = 'push_reporting_magasin'
END

SET @statut = (SELECT parameter_name
                  FROM suivi_tickets.parameters
                  WHERE parameter_cible = @parameter_cible
                    AND @pcCA > CAST(parameter_value_From AS DECIMAL(18,5))
                    AND @pcCA <= CAST(parameter_value_To AS DECIMAL(18,5))
                  ) 

RETURN @statut

END

GO