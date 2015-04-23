/* Exemple d'utilisation :

DECLARE @Resultat VARCHAR(500)

EXECUTE [dbo].[Parametrage_Relation] 'rel_groupe_user', 'push_reporting', 'rel_groupe_user', 'idUser', 1, 'idGroupe', '2', @Resultat OUTPUT

SELECT @Resultat as res

*/

ALTER PROCEDURE dbo.[Parametrage_Relation] (
	@Domaine				VARCHAR(50),
	@StrSchema				VARCHAR(50),
	@StrTableRelation		VARCHAR(50),
	@StrChampCle			VARCHAR(50),
	@StrValeurCle			VARCHAR(50),
	@StrChampAttribut		VARCHAR(50),
	@ListNouvellesValeurs	VARCHAR(500),
	@Resultat				VARCHAR(500) OUTPUT
)
AS

DECLARE @ListCreation VARCHAR(500)
SET @ListCreation = ''
DECLARE @ListSuppression VARCHAR(500)
SET @ListSuppression = ''

DECLARE @ListAnciennesValeurs VARCHAR(500)
DECLARE @Query NVARCHAR(MAX)
DECLARE @ParamDefinition NVARCHAR(500)

DECLARE @WhereClause VARCHAR(100)
SET @WhereClause  = ' WHERE '+@StrChampCle+'='''+@StrValeurCle+''''

PRINT @WhereClause

EXECUTE [Utils].[TableToString] @StrSchema, @StrTableRelation, @StrChampAttribut, @WhereClause, @ListAnciennesValeurs OUTPUT

PRINT @ListAnciennesValeurs

/* Creation de relation */
PRINT 'Creation de relation'

DECLARE @Item VARCHAR(100)

DECLARE curs CURSOR FOR 
SELECT NEW.Item
FROM (SELECT * FROM [Utils].[StringToTable](@ListAnciennesValeurs, ';')) ANC
RIGHT JOIN (SELECT * FROM [Utils].[StringToTable](@ListNouvellesValeurs, ';')) NEW
   ON NEW.Item = ANC.Item
WHERE ANC.Item IS NULL
ORDER BY NEW.Item;

OPEN curs

FETCH NEXT FROM curs 
INTO @Item

WHILE @@FETCH_STATUS = 0
BEGIN

	PRINT @Item
	
	SET @ListCreation = @ListCreation + @Item + ', '
	
	SET @Query = 
	N' INSERT INTO '+@StrSchema+'.'+@StrTableRelation+' ('+@StrChampCle+', '+@StrChampAttribut+') '
	+' SELECT '''+@StrValeurCle+''', '''+@Item+''''
	
	PRINT @Query
	
	EXECUTE sp_executesql @Query
	
	FETCH NEXT FROM curs 
	INTO @Item

END 
CLOSE curs;
DEALLOCATE curs;

/* Suppression de relation */
PRINT 'Suppression de relation'

DECLARE curs CURSOR FOR 
SELECT ANC.Item
FROM (SELECT * FROM [Utils].[StringToTable](@ListAnciennesValeurs, ';')) ANC
LEFT JOIN (SELECT * FROM [Utils].[StringToTable](@ListNouvellesValeurs, ';')) NEW
   ON NEW.Item = ANC.Item
WHERE NEW.Item IS NULL
ORDER BY ANC.Item;

OPEN curs

FETCH NEXT FROM curs 
INTO @Item

WHILE @@FETCH_STATUS = 0
BEGIN

	PRINT @Item
	
	SET @ListSuppression = @ListSuppression + @Item + ', '
	
	SET @Query = 
	N' DELETE FROM '+@StrSchema+'.'+@StrTableRelation
	+' WHERE '+@StrChampCle+'='''+@StrValeurCle+''' AND '+@StrChampAttribut+'='''+@Item+''''
	
	PRINT @Query
	
	EXECUTE sp_executesql @Query
	
	FETCH NEXT FROM curs 
	INTO @Item

END 
CLOSE curs;
DEALLOCATE curs;

IF @ListCreation <> ''
BEGIN
	IF @ListSuppression <> ''
	BEGIN
		SET @Resultat = @Domaine+' : '+@StrChampAttribut+' création : '+LEFT(@ListCreation, LEN(@ListCreation)-1)+' et suppression : '+LEFT(@ListSuppression, LEN(@ListSuppression)-1)
	END ELSE BEGIN
		SET @Resultat = @Domaine+' : '+@StrChampAttribut+' création : '+LEFT(@ListCreation, LEN(@ListCreation)-1)
	END
END ELSE BEGIN
	IF @ListSuppression <> ''
	BEGIN
		SET @Resultat = @Domaine+' : '+@StrChampAttribut+' suppression : '+LEFT(@ListSuppression, LEN(@ListSuppression)-1)
	END ELSE BEGIN
		SET @Resultat = @Domaine+' : Aucune actions'
	END
END

/*
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
*/

RETURN 0

GO