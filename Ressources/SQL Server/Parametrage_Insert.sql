ALTER PROCEDURE dbo.[Parametrage_Insert] (
	@Domaine		VARCHAR(50),
	@StrSchema		VARCHAR(50),
	@StrTable		VARCHAR(50),
	@StrChamp		VARCHAR(50),
	@StrValeur		VARCHAR(50),
	@Resultat		VARCHAR(500) OUTPUT
)
AS

DECLARE @ValeurAncienne VARCHAR(50)
DECLARE @Query NVARCHAR(MAX)
DECLARE @ParamDefinition NVARCHAR(500)

SET @ParamDefinition = 
N'@Resultat VARCHAR(50) OUTPUT'

SET @Query = 
N' IF EXISTS('
+' SELECT 1'
+' FROM '+@StrSchema+'.'+@StrTable
+' WHERE '+@StrChamp+' = '''+@StrValeur+''')'
+' BEGIN '
+' 	SELECT @Resultat = '''+@StrValeur+''''
+' END ELSE BEGIN '
+' 	SELECT @Resultat = ''None'''
+' END'

PRINT @Query

EXECUTE sp_executesql @Query, @ParamDefinition, @Resultat = @ValeurAncienne OUTPUT

PRINT @ValeurAncienne 

IF @ValeurAncienne = 'None'
BEGIN
	SET @Query = 
	N' INSERT INTO '+@StrSchema+'.'+@StrTable+' ('+@StrChamp+')'
	+' SELECT '''+@StrValeur+''''
	
	PRINT @Query
	
	EXECUTE sp_executesql @Query
	
	SET @Resultat = @Domaine+' : '+@StrChamp+' crée : '+@StrValeur
END ELSE BEGIN
	SET @Resultat = @Domaine+' : Aucun changement necessaire'
END

RETURN 0

GO