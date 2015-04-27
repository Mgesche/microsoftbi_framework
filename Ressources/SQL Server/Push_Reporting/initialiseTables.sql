/* Exemple d'utilisation : 
EXECUTE [push_reporting].[initialiseTables] 'barometre', 'liste_clients', 0
*/

CREATE PROCEDURE [push_reporting].[initialiseTables] (
	@StrSchema	varchar(50), 
	@StrVue		varchar(50),
	@overwrite	int = 0
)
AS
BEGIN

DECLARE @Query NVARCHAR(MAX)

IF @overwrite = 1
BEGIN

SET @Query = 
N' IF EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES]'
+'			  WHERE TABLE_SCHEMA = ''' + @StrSchema + ''' and TABLE_NAME = ''' + @StrVue +'_Diff_Histo'') '
+' BEGIN'
+' 	DROP TABLE ' + @StrSchema + '.' + @StrVue +'_Diff_Histo'
+' END '

EXECUTE sp_executesql @Query

SET @Query = 
N' IF EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES]'
+'			  WHERE TABLE_SCHEMA = ''' + @StrSchema + ''' and TABLE_NAME = ''' + @StrVue +'_Diff_Load'') '
+' BEGIN'
+' 	DROP TABLE ' + @StrSchema + '.' + @StrVue +'_Diff_Load'
+' END '

EXECUTE sp_executesql @Query

SET @Query = 
N' IF EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES]'
+'			  WHERE TABLE_SCHEMA = ''' + @StrSchema + ''' and TABLE_NAME = ''' + @StrVue +'_Diff_Old'') '
+' BEGIN'
+' 	DROP TABLE ' + @StrSchema + '.' + @StrVue +'_Diff_Old'
+' END '

EXECUTE sp_executesql @Query

SET @Query = 
N' IF EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES]'
+'			  WHERE TABLE_SCHEMA = ''' + @StrSchema + ''' and TABLE_NAME = ''' + @StrVue +'_Full_Load'') '
+' BEGIN'
+' 	DROP TABLE ' + @StrSchema + '.' + @StrVue +'_Full_Load'
+' END '

EXECUTE sp_executesql @Query

END

SET @Query = 
N' IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES]'
+'			  WHERE TABLE_SCHEMA = ''' + @StrSchema + ''' and TABLE_NAME = ''' + @StrVue +'_Diff_Histo'') '
+' BEGIN'
+' 	SELECT TOP 0 GETDATE() AS Dt_Modif, N''I'' as Action, 0 as actif, 0 as id_partition, * '
+' 	INTO ' + @StrSchema + '.' + @StrVue +'_Diff_Histo'
+' 	FROM ' + @StrSchema + '.' + @StrVue
+' END '

EXECUTE sp_executesql @Query

SET @Query = 
N' IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES]'
+'			  WHERE TABLE_SCHEMA = ''' + @StrSchema + ''' and TABLE_NAME = ''' + @StrVue +'_Diff_Load'') '
+' BEGIN'
+' 	SELECT TOP 0 N''I'' as Action, 0 as actif, 0 as id_partition, * '
+' 	INTO ' + @StrSchema + '.' + @StrVue +'_Diff_Load'
+' 	FROM ' + @StrSchema + '.' + @StrVue
+' END '

EXECUTE sp_executesql @Query

SET @Query = 
N' IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES]'
+'			  WHERE TABLE_SCHEMA = ''' + @StrSchema + ''' and TABLE_NAME = ''' + @StrVue +'_Diff_Old'') '
+' BEGIN'
+' 	SELECT TOP 0 * '
+' 	INTO ' + @StrSchema + '.' + @StrVue +'_Diff_Old'
+' 	FROM ' + @StrSchema + '.' + @StrVue
+' END '

EXECUTE sp_executesql @Query

SET @Query = 
N' IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES]'
+'			  WHERE TABLE_SCHEMA = ''' + @StrSchema + ''' and TABLE_NAME = ''' + @StrVue +'_Full_Load'') '
+' BEGIN'
+' 	SELECT TOP 0 N''I'' as Action, 0 as actif, 0 as id_partition, * '
+' 	INTO ' + @StrSchema + '.' + @StrVue +'_Full_Load'
+' 	FROM ' + @StrSchema + '.' + @StrVue
+' END '

EXECUTE sp_executesql @Query

END