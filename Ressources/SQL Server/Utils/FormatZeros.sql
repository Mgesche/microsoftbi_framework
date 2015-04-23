CREATE FUNCTION [Utils].[FormatZeros] (
	@entier bigint,
	@longueur int
) RETURNS varchar(50)
AS
  /* ===================================================================================== */
  /* Retourne une chaine d'une longueur donnée completé avec des zeros                     */
  /*                                                                                       */
  /* @entier : Valeur a afficher                                                           */
  /* @longueur : Longueur désirée                                                          */
  /*																		 		       */
  /* ===================================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT [export_differentiel].[GetIDTest]('Client', 'nb maj')

GO
*/
BEGIN

RETURN (SELECT REPLICATE('0', @longueur - LEN(CAST(@entier AS VARCHAR(20)))) + CAST(@entier AS VARCHAR(20)))

END

GO
