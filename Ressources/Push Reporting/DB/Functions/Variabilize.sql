CREATE FUNCTION [push_reporting].[Variabilize](
	@strChaine varchar(500)
) RETURNS varchar(500)
as
  /* =============================================================================== */
  /* Cette fonction retourne la chaine modifié via les variables definies dans       */
  /* push_reporting.[variables]                                                      */
  /*                                                                                 */
  /* @strChaine : Chaine a modifier                                                  */
  /*																				 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT * FROM [BotanicDW_MEC].[push_reporting].[GetDataExport] (9);

GO
*/
BEGIN

DECLARE @strVariable    varchar(100)
DECLARE @strValeur      varchar(100)

DECLARE curseur CURSOR FOR 
SELECT strVariable, strValeur
FROM push_reporting.[variables];

OPEN curseur

FETCH NEXT FROM curseur 
INTO @strVariable, @strValeur

WHILE @@FETCH_STATUS = 0
BEGIN

	SET @strChaine = REPLACE(@strChaine, @strVariable,@strValeur)

    FETCH NEXT FROM curseur 
	INTO @strVariable, @strValeur
END 
CLOSE curseur;
DEALLOCATE curseur;

RETURN @strChaine

END

GO