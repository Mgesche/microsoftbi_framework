/* Exemple d'utilisation :

DECLARE @resExecute VARCHAR(500)

EXECUTE [Utils].[TableToString] 'push_reporting', '[user]', 'strMail', '', @resExecute OUTPUT

SELECT @resExecute as res

*/

CREATE PROCEDURE [Utils].[TableToString](
	@StrSchema		VARCHAR(50), 
	@StrTable		VARCHAR(50), 
	@StrChamp		VARCHAR(50),
	@StrWhere		VARCHAR(500) = '',
	@StrResultat	VARCHAR(MAX) OUTPUT
)
AS

DECLARE @Query NVARCHAR(MAX)
DECLARE @ParamDefinition NVARCHAR(500)

SET @ParamDefinition = 
N'@Resultat VARCHAR(MAX) OUTPUT'

SET @Query = 
N' SELECT  @Resultat = STUFF(('
+' 			SELECT  '';'' + CAST('+@StrChamp+' AS VARCHAR(MAX))'
+'          FROM '+@StrSchema+'.'+@StrTable
+' 			'+@StrWhere
+'          FOR XML PATH(''''), TYPE'
+'          ).value(''.'',''varchar(max)''),1,1, '''') '

EXECUTE sp_executesql @Query, @ParamDefinition, @Resultat = @StrResultat OUTPUT

RETURN 0

GO


