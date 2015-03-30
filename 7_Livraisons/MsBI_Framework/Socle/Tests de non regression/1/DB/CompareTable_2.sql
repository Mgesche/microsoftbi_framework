/*
USE [BI_FMK]
GO

DECLARE	@return_value int

EXEC	@return_value = [Adm].[CompareTable]
		@TableCible = N'E21_Detail_MGE_Old',
		@TableComp = N'E21_Detail_MGE_New',
		@NbKey = 4,
		@Key1 = N'CaseNumber',
		@Key2 = N'VehId',
		@Key3 = N'LastName',
		@Key4 = N'PACK'

SELECT	'Return Value' = @return_value

GO
*/
ALTER PROCEDURE [Adm].[CompareTable] (
	@DBCible		VARCHAR(100) = 'Tests',
	@SchemaCible	VARCHAR(100) = 'dbo',
	@TableCible		VARCHAR(100),
	@isCibleTable	int = 1, /* Est ce une table ou une vue ? (auquel cas la table avec les donnees sera cree */
	@DBComp			VARCHAR(100) = 'Tests',
	@SchemaComp		VARCHAR(100) = 'dbo',
	@TableComp		VARCHAR(100),
	@isCompTable	int = 1, /* Est ce une table ou une vue ? (auquel cas la table avec les donnees sera cree */
	@NbKey			int = 1, /* Nombre de champ pour former la cle fonctionnelle */
	@Key1			VARCHAR(255),
	@Key2			VARCHAR(255),
	@Key3			VARCHAR(255),
	@Key4			VARCHAR(255)
)  as 
Begin 

	DECLARE @Table_Cible VARCHAR(100)
	
	SET @Table_Cible = @DBCible+'.'+@SchemaCible+'.'+@TableCible
	
	/* RAZ */
	UPDATE [Adm].Tests_Resultats
	SET IsCurrent = 0
	WHERE Table_Cible = @Table_Cible
	  AND IsCurrent = 1;

	DECLARE @Query NVARCHAR(4000)

	/* Preparation tables si view */
	IF @isCibleTable = 0 
	BEGIN

		SET @Query =		 N'SELECT * '
		SET @Query = @Query + 'INTO '+@DBCible+'.'+@SchemaCible+'.Table_'+@TableCible+' '
		SET @Query = @Query + 'FROM '+@DBCible+'.'+@SchemaCible+'.'+@TableCible+' '
		
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

	DECLARE @KeyGlobal VARCHAR(200)
	SET @KeyGlobal = @Key1
	IF @NbKey > 1
	BEGIN
	SET @KeyGlobal = @KeyGlobal + ' - ' + @Key2
	END
	IF @NbKey > 2
	BEGIN
	SET @KeyGlobal = @KeyGlobal + ' - ' + @Key3
	END
	IF @NbKey > 3
	BEGIN
	SET @KeyGlobal = @KeyGlobal + ' - ' + @Key4
	END

	SET @Query =		 N'INSERT INTO [Adm].Tests_Resultats (Table_Cible, Colonne, Ecart, DtResultat, isCurrent, ValeurCle1, ValeurCle2, ValeurCle3, ValeurCle4) '
	SET @Query = @Query + 'SELECT '''+@Table_Cible+''', '''+@KeyGlobal+''' AS Colonne, ''En trop'' as Ecart, GETDATE() AS DtResultat, 1 AS isCurrent, '
	SET @Query = @Query + '		  CMP.'+@Key1+' AS ValeurCle1 '
	IF @NbKey > 1
	BEGIN
	SET @Query = @Query + '      ,CMP.'+@Key2+' AS ValeurCle2 '
	END
	ELSE
	BEGIN
	SET @Query = @Query + '      ,NULL AS ValeurCle2 '
	END
	IF @NbKey > 2
	BEGIN
	SET @Query = @Query + '      ,CMP.'+@Key3+' AS ValeurCle3 '
	END
	ELSE
	BEGIN
	SET @Query = @Query + '      ,NULL AS ValeurCle3 '
	END
	IF @NbKey > 3
	BEGIN
	SET @Query = @Query + '      ,CMP.'+@Key4+' AS ValeurCle4 '
	END
	ELSE
	BEGIN
	SET @Query = @Query + '      ,NULL AS ValeurCle4 '
	END
	SET @Query = @Query + 'FROM '+@DBComp+'.'+@SchemaComp+'.'+@TableComp+' CMP '
	SET @Query = @Query + 'LEFT JOIN '+@DBCible+'.'+@SchemaCible+'.'+@TableCible+' CIB '
	SET @Query = @Query + '  ON CMP.'+@Key1+' = CIB.'+@Key1+' '
	IF @NbKey > 1
	BEGIN
	SET @Query = @Query + ' AND CMP.'+@Key2+' = CIB.'+@Key2+' '
	END
	IF @NbKey > 2
	BEGIN
	SET @Query = @Query + ' AND CMP.'+@Key3+' = CIB.'+@Key3+' '
	END
	IF @NbKey > 3
	BEGIN
	SET @Query = @Query + ' AND CMP.'+@Key4+' = CIB.'+@Key4+' '
	END
	SET @Query = @Query + 'WHERE CIB.'+@Key1+' IS NULL '

	--print @Query

	EXECUTE sp_executesql @Query

	SET @Query =		 N'INSERT INTO [Adm].Tests_Resultats (Table_Cible, Colonne, Ecart, DtResultat, isCurrent, ValeurCle1, ValeurCle2, ValeurCle3, ValeurCle4) '
	SET @Query = @Query + 'SELECT '''+@Table_Cible+''', '''+@KeyGlobal+''' AS Colonne, ''Manquant'' as Ecart, GETDATE() AS DtResultat, 1 AS isCurrent, '
	SET @Query = @Query + '		  CIB.'+@Key1+' AS ValeurCle1 '
	IF @NbKey > 1
	BEGIN
	SET @Query = @Query + '      ,CIB.'+@Key2+' AS ValeurCle2 '
	END
	ELSE
	BEGIN
	SET @Query = @Query + '      ,NULL AS ValeurCle2 '
	END
	IF @NbKey > 2
	BEGIN
	SET @Query = @Query + '      ,CIB.'+@Key3+' AS ValeurCle3 '
	END
	ELSE
	BEGIN
	SET @Query = @Query + '      ,NULL AS ValeurCle3 '
	END
	IF @NbKey > 3
	BEGIN
	SET @Query = @Query + '      ,CIB.'+@Key3+' AS ValeurCle4 '
	END
	ELSE
	BEGIN
	SET @Query = @Query + '      ,NULL AS ValeurCle4 '
	END
	SET @Query = @Query + 'FROM '+@DBComp+'.'+@SchemaComp+'.'+@TableComp+' CMP '
	SET @Query = @Query + 'RIGHT JOIN '+@DBCible+'.'+@SchemaCible+'.'+@TableCible+' CIB '
	SET @Query = @Query + '  ON CMP.'+@Key1+' = CIB.'+@Key1+' '
	IF @NbKey > 1
	BEGIN
	SET @Query = @Query + ' AND CMP.'+@Key2+' = CIB.'+@Key2+' '
	END
	IF @NbKey > 2
	BEGIN
	SET @Query = @Query + ' AND CMP.'+@Key3+' = CIB.'+@Key3+' '
	END
	IF @NbKey > 3
	BEGIN
	SET @Query = @Query + ' AND CMP.'+@Key4+' = CIB.'+@Key4+' '
	END
	SET @Query = @Query + 'WHERE CMP.'+@Key1+' IS NULL '

	--print @Query

	EXECUTE sp_executesql @Query

	DECLARE @Column_name VARCHAR(100)

	DECLARE column_cursor CURSOR FOR 
	SELECT Column_name
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = REPLACE(REPLACE(@TableCible, ']', ''), '[', '')
	  AND TABLE_SCHEMA = REPLACE(REPLACE(@SchemaCible, ']', ''), '[', '')
	  AND Column_name <> @Key1
	  AND Column_name <> @Key2
	  AND Column_name <> @Key3
	  AND Column_name <> @Key4
	ORDER BY Column_name;

	OPEN column_cursor

	FETCH NEXT FROM column_cursor 
	INTO @Column_name

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @Query =		 N'INSERT INTO [Adm].Tests_Resultats (Table_Cible, Colonne, Ecart, DtResultat, isCurrent, ValeurCle1, ValeurCle2, ValeurCle3, ValeurCle4) '
		SET @Query = @Query + 'SELECT '''+@Table_Cible+''', '''+@Column_name+''' AS Colonne, ''Different'' as Ecart, GETDATE() AS DtResultat, 1 AS isCurrent, '
		SET @Query = @Query + '		  CMP.'+@Key1+' AS ValeurCle1 '
		IF @NbKey > 1
		BEGIN
		SET @Query = @Query + '      ,CMP.'+@Key2+' AS ValeurCle2 '
		END
		ELSE
		BEGIN
		SET @Query = @Query + '      ,NULL AS ValeurCle2 '
		END
		IF @NbKey > 2
		BEGIN
		SET @Query = @Query + '      ,CMP.'+@Key3+' AS ValeurCle3 '
		END
		ELSE
		BEGIN
		SET @Query = @Query + '      ,NULL AS ValeurCle3 '
		END
		IF @NbKey > 3
		BEGIN
		SET @Query = @Query + '      ,CMP.'+@Key4+' AS ValeurCle4 '
		END
		ELSE
		BEGIN
		SET @Query = @Query + '      ,NULL AS ValeurCle4 '
		END
		SET @Query = @Query + 'FROM '+@DBComp+'.'+@SchemaComp+'.'+@TableComp+' CMP '
		SET @Query = @Query + 'JOIN '+@DBCible+'.'+@SchemaCible+'.'+@TableCible+' CIB '
		SET @Query = @Query + '  ON CMP.'+@Key1+' = CIB.'+@Key1+' '
		IF @NbKey > 1
		BEGIN
		SET @Query = @Query + ' AND CMP.'+@Key2+' = CIB.'+@Key2+' '
		END
		IF @NbKey > 2
		BEGIN
		SET @Query = @Query + ' AND CMP.'+@Key3+' = CIB.'+@Key3+' '
		END
		IF @NbKey > 3
		BEGIN
		SET @Query = @Query + ' AND CMP.'+@Key4+' = CIB.'+@Key4+' '
		END
		SET @Query = @Query + 'LEFT JOIN '+@DBCible+'.'+@SchemaCible+'.'+@TableCible+' CIB2 '
		SET @Query = @Query + '  ON CMP.'+@Key1+' = CIB2.'+@Key1+' '
		IF @NbKey > 1
		BEGIN
		SET @Query = @Query + ' AND CMP.'+@Key2+' = CIB.'+@Key2+' '
		END
		IF @NbKey > 2
		BEGIN
		SET @Query = @Query + ' AND CMP.'+@Key3+' = CIB.'+@Key3+' '
		END
		IF @NbKey > 3
		BEGIN
		SET @Query = @Query + ' AND CMP.'+@Key4+' = CIB.'+@Key4+' '
		END
		SET @Query = @Query + ' AND CMP.'+@Column_name+' = CIB2.'+@Column_name+' '
		SET @Query = @Query + 'WHERE CIB2.'+@Key1+' IS NULL AND (CMP.'+@Column_name+' IS NOT NULL OR CIB.'+@Column_name+' IS NOT NULL) '
		
		--print @Query
		
		EXECUTE sp_executesql @Query

		FETCH NEXT FROM column_cursor 
		INTO @Column_name
	END

	CLOSE column_cursor
	DEALLOCATE column_cursor

	/* Compte rendu des differences */
	SELECT Table_Cible, Colonne, Ecart, COUNT(*) as NB, MIN(ValeurCle1) as exempleCle1,
		   MIN(ValeurCle2) as exempleCle2, MIN(ValeurCle3) as exempleCle3, 
		   MIN(ValeurCle4) as exempleCle4
	FROM [Adm].Tests_Resultats
	WHERE ISCurrent = 1
	GROUP BY Table_Cible, Colonne, Ecart
	ORDER BY Table_Cible, NB desc

	/* Exemple de recherche de differences */
	SET @Query = 'select res.valeurcle1 as '''+@Key1+''', '
	IF @NbKey > 1
	BEGIN
	SET @Query = @Query + ' res.valeurcle2 as '''+@Key2+''', '
	END
	IF @NbKey > 2
	BEGIN
	SET @Query = @Query + ' res.valeurcle3 as '''+@Key3+''', '
	END
	IF @NbKey > 3
	BEGIN
	SET @Query = @Query + ' res.valeurcle4 as '''+@Key4+''', '
	END
	SET @Query = @Query + '		CMP.Segment_ID__c as IDC, CIB.Segment_ID__c as RCP '
	SET @Query = @Query + 'from [Adm].Tests_Resultats res '
	SET @Query = @Query + 'join '+@DBComp+'.'+@SchemaComp+'.'+@TableComp+' CMP '
	SET @Query = @Query + '  ON res.valeurcle1 = CMP.'+@Key1+' ' 
	IF @NbKey > 1
	BEGIN
	SET @Query = @Query + ' AND res.valeurcle2 = CMP.'+@Key2+' ' 
	END
	IF @NbKey > 2
	BEGIN
	SET @Query = @Query + ' AND res.valeurcle3 = CMP.'+@Key3+' ' 
	END
	IF @NbKey > 3
	BEGIN
	SET @Query = @Query + ' AND res.valeurcle4 = CMP.'+@Key4+' ' 
	END
	SET @Query = @Query + 'join '+@DBCible+'.'+@SchemaCible+'.'+@TableCible+' cib '
	SET @Query = @Query + '  on res.valeurcle1 = cib.'+@Key1 +' ' 
	IF @NbKey > 1
	BEGIN
	SET @Query = @Query + ' AND res.valeurcle2 = cib.'+@Key2+' ' 
	END
	IF @NbKey > 2
	BEGIN
	SET @Query = @Query + ' AND res.valeurcle3 = cib.'+@Key3+' ' 
	END
	IF @NbKey > 3
	BEGIN
	SET @Query = @Query + ' AND res.valeurcle4 = cib.'+@Key4+' ' 
	END
	SET @Query = @Query + 'where isCurrent = 1 AND res.colonne = ''Segment_ID__c'' '

	print @Query
	
END