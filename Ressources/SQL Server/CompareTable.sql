/*
CREATE TABLE Resultat (
	Colonne varchar(50), 
	Ecart varchar(10), 
	ValeurCle varchar(255)
)
*/

SELECT *
FROM 

DELETE FROM Resultat;

DECLARE @SchemaCible VARCHAR(100)
SET @SchemaCible = '[File]'

DECLARE @TableCible VARCHAR(100)
SET @TableCible = 'Profil_Campagne_VALID_MGE'

DECLARE @SchemaComp VARCHAR(100)
SET @SchemaComp = '[File]'

DECLARE @TableComp VARCHAR(100)
SET @TableComp = 'Campagne_Client'

DECLARE @Key VARCHAR(100)
SET @Key = 'BK_PersonalReference__c'

DECLARE @Query NVARCHAR(4000)

SET @Query =		 N'INSERT INTO Resultat '
SET @Query = @Query + 'SELECT '''+@Key+''' AS Colonne, ''En trop'' as Ecart, '
SET @Query = @Query + '		  CMP.'+@Key+' AS ValeurCle '
SET @Query = @Query + 'FROM '+@SchemaComp+'.'+@TableComp+' CMP '
SET @Query = @Query + 'LEFT JOIN '+@SchemaCible+'.'+@TableCible+' CIB '
SET @Query = @Query + '  ON CMP.'+@Key+' = CIB.'+@Key+' '
SET @Query = @Query + 'WHERE CIB.'+@Key+' IS NULL '

EXECUTE sp_executesql @Query

SET @Query =		 N'INSERT INTO Resultat '
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
ORDER BY Column_name;

OPEN column_cursor

FETCH NEXT FROM column_cursor 
INTO @Column_name

WHILE @@FETCH_STATUS = 0
BEGIN

	SET @Query =		 N'INSERT INTO Resultat '
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

SELECT Colonne, Ecart, COUNT(*) as NB, MIN(ValeurCle) as exemple
FROM Resultat
GROUP BY Colonne, Ecart
ORDER BY NB desc

--DROP TABLE Resultat