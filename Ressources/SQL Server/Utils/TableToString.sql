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
+' 			SELECT  ''; '' + CAST('+@StrChamp+' AS VARCHAR(MAX))'
+'          FROM '+@StrSchema+'.'+@StrTable
+'          FOR XML PATH(''''), TYPE'
+' 			'+@StrWhere
+'          ).value(''.'',''varchar(max)''),1,2, '''') '

EXECUTE sp_executesql @Query, @ParamDefinition, @Resultat = @StrResultat OUTPUT

RETURN 0

GO


