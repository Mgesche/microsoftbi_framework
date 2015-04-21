ALTER PROCEDURE dbo.[Parametrage_Attribut] (
	@Domaine		VARCHAR(50),
	@StrSchema		VARCHAR(50),
	@StrTable		VARCHAR(50),
	@StrChampCle	VARCHAR(50),
	@StrValeurCle	VARCHAR(50),
	@StrAttribut	VARCHAR(50),
	@NouvelleValeur	VARCHAR(50),
	@Resultat		VARCHAR(500) OUTPUT
)
AS

DECLARE @ValeurAncienne VARCHAR(50)
DECLARE @Query NVARCHAR(MAX)
DECLARE @ParamDefinition NVARCHAR(500)

SET @ParamDefinition = 
N'@Resultat VARCHAR(50) OUTPUT'

SET @Query = 
N' SELECT @Resultat = '+@StrAttribut
+' FROM '+@StrSchema+'.'+@StrTable
+' WHERE '+@StrChampCle+' = '''+@StrValeurCle+''''

EXECUTE sp_executesql @Query, @ParamDefinition, @Resultat = @ValeurAncienne OUTPUT

IF @ValeurAncienne <> @NouvelleValeur
BEGIN
	SET @Query = 
	N' UPDATE '+@StrSchema+'.'+@StrTable
	+' SET '+@StrAttribut+' = '''+@NouvelleValeur+''''
	+' WHERE '+@StrChampCle+' = '''+@StrValeurCle+''''
	
	EXECUTE sp_executesql @Query
	
	SET @Resultat = @Domaine+' : '+@StrAttribut+' passe de '+@ValeurAncienne+' a '+@NouvelleValeur+' pour '+@StrChampCle+' = '+@StrValeurCle
END ELSE BEGIN
	SET @Resultat = @Domaine+' : Aucune changement necessaire'
END

RETURN 0

GO

DECLARE @res VARCHAR(500)
EXECUTE dbo.[Parametrage_Attribut] 'Test', 'push_reporting', '[user]', 'idUser', 4681, 'enabled', '0', @res OUTPUT
SELECT @res

SELECT *
FROM push_reporting.[user]