/*
CREATE TABLE ASuppr_Resultat_Structure (
	Colonne varchar(50), 
	Ecart varchar(10), 
	ValeurCle varchar(255)
)
*/

/* Si reinitialise */
DELETE FROM ASuppr_Resultat_Structure;

/* Variables */
DECLARE @SchemaCible VARCHAR(100)
SET @SchemaCible = '[File]'

DECLARE @TableCible VARCHAR(100)
SET @TableCible = 'V_Campagne_Client_VALID_MGE'

DECLARE @isCibleTable int
SET @isCibleTable = 0

DECLARE @SchemaComp VARCHAR(100)
SET @SchemaComp = '[File]'

DECLARE @TableComp VARCHAR(100)
SET @TableComp = 'V_Campagne_Client'

DECLARE @isCompTable int
SET @isCompTable = 0

DECLARE @Query NVARCHAR(4000)

/* Preparation tables si view */
IF @isCibleTable = 0 
BEGIN

	SET @Query =		 N'SELECT * '
	SET @Query = @Query + 'INTO '+@SchemaCible+'.Table_'+@TableCible+' '
	SET @Query = @Query + 'FROM '+@SchemaCible+'.'+@TableCible+' '
	
	EXECUTE sp_executesql @Query
	
	SET @TableCible = 'Table_'+@TableCible

END

IF @isCompTable = 0 
BEGIN

	SET @Query =		 N'SELECT * '
	SET @Query = @Query + 'INTO '+@SchemaComp+'.Table_'+@TableComp+' '
	SET @Query = @Query + 'FROM '+@SchemaComp+'.'+@TableComp+' '
	
	EXECUTE sp_executesql @Query
	
	SET @TableComp = 'Table_'+@TableComp

END

/* Recuperation de la structure */
SET @Query =		 N'SELECT * '
SET @Query = @Query + 'INTO '+@SchemaCible+'.Struct_'+@TableCible+' '
SET @Query = @Query + 'FROM [INFORMATION_SCHEMA].[COLUMNS] '
SET @Query = @Query + 'WHERE TABLE_SCHEMA = '''+REPLACE(REPLACE(@SchemaCible, ']', ''), '[', '')+''' '
SET @Query = @Query + '  AND TABLE_NAME = '''+REPLACE(REPLACE(@TableCible, ']', ''), '[', '')+''' '

EXECUTE sp_executesql @Query

SET @TableCible = 'Struct_'+@TableCible

SET @Query =		 N'SELECT * '
SET @Query = @Query + 'INTO '+@SchemaComp+'.Struct_'+@TableComp+' '
SET @Query = @Query + 'FROM [INFORMATION_SCHEMA].[COLUMNS] '
SET @Query = @Query + 'WHERE TABLE_SCHEMA = '''+REPLACE(REPLACE(@SchemaComp, ']', ''), '[', '')+''' '
SET @Query = @Query + '  AND TABLE_NAME = '''+REPLACE(REPLACE(@TableComp, ']', ''), '[', '')+''' '

EXECUTE sp_executesql @Query

SET @TableComp = 'Struct_'+@TableComp

DECLARE @Key VARCHAR(100)
SET @Key = 'COLUMN_NAME'

SET @Query =		 N'INSERT INTO ASuppr_Resultat_Structure '
SET @Query = @Query + 'SELECT '''+@Key+''' AS Colonne, ''En trop'' as Ecart, '
SET @Query = @Query + '		  CMP.'+@Key+' AS ValeurCle '
SET @Query = @Query + 'FROM '+@SchemaComp+'.'+@TableComp+' CMP '
SET @Query = @Query + 'LEFT JOIN '+@SchemaCible+'.'+@TableCible+' CIB '
SET @Query = @Query + '  ON CMP.'+@Key+' = CIB.'+@Key+' '
SET @Query = @Query + 'WHERE CIB.'+@Key+' IS NULL '

EXECUTE sp_executesql @Query

SET @Query =		 N'INSERT INTO ASuppr_Resultat_Structure '
SET @Query = @Query + 'SELECT '''+@Key+''' AS Colonne, ''Manquant'' as Ecart, '
SET @Query = @Query + '		  CIB.'+@Key+' AS ValeurCle '
SET @Query = @Query + 'FROM '+@SchemaComp+'.'+@TableComp+' CMP '
SET @Query = @Query + 'RIGHT JOIN '+@SchemaCible+'.'+@TableCible+' CIB '
SET @Query = @Query + '  ON CMP.'+@Key+' = CIB.'+@Key+' '
SET @Query = @Query + 'WHERE CMP.'+@Key+' IS NULL '

EXECUTE sp_executesql @Query

DECLARE @Column_name VARCHAR(100)

DECLARE column_cursor CURSOR FOR 
SELECT Column_name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = REPLACE(REPLACE(@TableCible, ']', ''), '[', '')
  AND TABLE_SCHEMA = REPLACE(REPLACE(@SchemaCible, ']', ''), '[', '')
  AND Column_name <> @Key
  AND Column_name <> 'TABLE_NAME'
  AND Column_name <> 'SCHEMA_NAME'
ORDER BY Column_name;

OPEN column_cursor

FETCH NEXT FROM column_cursor 
INTO @Column_name

WHILE @@FETCH_STATUS = 0
BEGIN

	SET @Query =		 N'INSERT INTO ASuppr_Resultat_Structure '
	SET @Query = @Query + 'SELECT '''+@Column_name+''' AS Colonne, ''Different'' as Ecart, '
	SET @Query = @Query + '		  CMP.'+@Key+' AS ValeurCle '
	SET @Query = @Query + 'FROM '+@SchemaComp+'.'+@TableComp+' CMP '
	SET @Query = @Query + 'JOIN '+@SchemaCible+'.'+@TableCible+' CIB '
	SET @Query = @Query + '  ON CMP.'+@Key+' = CIB.'+@Key+' '
	SET @Query = @Query + 'LEFT JOIN '+@SchemaCible+'.'+@TableCible+' CIB2 '
	SET @Query = @Query + '  ON CMP.'+@Key+' = CIB2.'+@Key+' '
	SET @Query = @Query + ' AND CMP.'+@Column_name+' = CIB2.'+@Column_name+' '
	SET @Query = @Query + 'WHERE CIB2.'+@Key+' IS NULL AND (CMP.'+@Column_name+' IS NOT NULL OR CIB.'+@Column_name+' IS NOT NULL) '
	
	EXECUTE sp_executesql @Query

	FETCH NEXT FROM column_cursor 
	INTO @Column_name
END

CLOSE column_cursor
DEALLOCATE column_cursor

/* Global */
SELECT Colonne, Ecart, COUNT(*) as NB, MIN(ValeurCle) as exemple
FROM ASuppr_Resultat_Structure
GROUP BY Colonne, Ecart
ORDER BY NB desc

/* Colonnes differentes */
select cib.COLUMN_NAME, CMP.COLUMN_NAME as IDC, CIB.COLUMN_NAME as RCP
from ASuppr_Resultat_Structure res
join [File].Struct_Table_V_Campagne_Client CMP
  on res.valeurcle = cMP.COLUMN_NAME
join [File].Struct_Table_V_Campagne_Client_VALID_MGE cib
  on res.valeurcle = cib.COLUMN_NAME
where res.colonne = 'COLUMN_NAME'


--DROP TABLE ASuppr_Resultat_Structure