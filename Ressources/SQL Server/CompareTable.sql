/*
CREATE TABLE Resultat (
	Domaine    varchar(50), 
	Colonne    varchar(50), 
	Ecart      varchar(10), 
	ValeurCle1 varchar(255), 
	ValeurCle2 varchar(255),
	ValeurCle3 varchar(255),
	ValeurCle4 varchar(255)
)
*/

DECLARE @Domaine VARCHAR(50)
SET @Domaine = 'Validity'

DELETE FROM Resultat
WHERE Domaine = @Domaine ;

DECLARE @SchemaCible VARCHAR(100)
SET @SchemaCible = '[File]'

DECLARE @TableCible VARCHAR(100)
SET @TableCible = 'V_Profil_Client_VALID_MGE'

/* Est ce une table ou une vue ? (auquel cas la table avec les donnees sera cree */
DECLARE @isCibleTable int
SET @isCibleTable = 0

DECLARE @SchemaComp VARCHAR(100)
SET @SchemaComp = '[File]'

DECLARE @TableComp VARCHAR(100)
SET @TableComp = 'V_Profil_Client'

/* Est ce une table ou une vue ? (auquel cas la table avec les donnees sera cree */
DECLARE @isCompTable int
SET @isCompTable = 0

/* Nombre de champ pour former la cle fonctionnelle */
DECLARE @NbKey int
SET @NbKey = 1

DECLARE @Key1 VARCHAR(100)
SET @Key1 = 'BK_PersonalReference__c'

/* Mettre '' s'il n'y a pas de 2eme cle fonctionnelle */
DECLARE @Key2 VARCHAR(100)
SET @Key2 = ''

/* Mettre '' s'il n'y a pas de 3eme cle fonctionnelle */
DECLARE @Key3 VARCHAR(100)
SET @Key3 = ''

/* Mettre '' s'il n'y a pas de 4eme cle fonctionnelle */
DECLARE @Key4 VARCHAR(100)
SET @Key4 = ''

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

DECLARE @KeyGlobal VARCHAR(200)
SET @KeyGlobal = @Key1
IF @NbKey > 1
BEGIN
SET @KeyGlobal = @KeyGlobal + ' - ' + @Key2
END

SET @Query =		 N'INSERT INTO Resultat '
SET @Query = @Query + 'SELECT '''+@Domaine+''', '''+@KeyGlobal+''' AS Colonne, ''En trop'' as Ecart, '
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
SET @Query = @Query + 'FROM '+@SchemaComp+'.'+@TableComp+' CMP '
SET @Query = @Query + 'LEFT JOIN '+@SchemaCible+'.'+@TableCible+' CIB '
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

SET @Query =		 N'INSERT INTO Resultat '
SET @Query = @Query + 'SELECT '''+@Domaine+''', '''+@KeyGlobal+''' AS Colonne, ''Manquant'' as Ecart, '
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
SET @Query = @Query + 'FROM '+@SchemaComp+'.'+@TableComp+' CMP '
SET @Query = @Query + 'RIGHT JOIN '+@SchemaCible+'.'+@TableCible+' CIB '
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

	SET @Query =		 N'INSERT INTO Resultat '
	SET @Query = @Query + 'SELECT '''+@Domaine+''', '''+@Column_name+''' AS Colonne, ''Different'' as Ecart, '
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
	SET @Query = @Query + 'FROM '+@SchemaComp+'.'+@TableComp+' CMP '
	SET @Query = @Query + 'JOIN '+@SchemaCible+'.'+@TableCible+' CIB '
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
	SET @Query = @Query + 'LEFT JOIN '+@SchemaCible+'.'+@TableCible+' CIB2 '
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
SELECT Domaine, Colonne, Ecart, COUNT(*) as NB, MIN(ValeurCle1) as exempleCle1,
	   MIN(ValeurCle2) as exempleCle2
FROM Resultat
GROUP BY Domaine, Colonne, Ecart
ORDER BY Domaine, NB desc

/* Exemple de recherche de differences */
IF @NbKey = 1

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
SET @Query = @Query + 'from Resultat res '
SET @Query = @Query + 'join '+@SchemaComp+'.'+@TableComp+' CMP '
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
SET @Query = @Query + 'join '+@SchemaCible+'.'+@TableCible+' cib '
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
SET @Query = @Query + 'where res.colonne = ''Segment_ID__c'' '

/* Exemple de recherche de differences : 2 cle

select res.valeurcle1, res.valeurcle2, CMP.Segment_ID__c as IDC, CIB.Segment_ID__c as RCP
from Resultat res
join [File].Table_V_Campagne_Client CMP
  on res.valeurcle1 = cMP.BK_PersonalReference__c
 and res.valeurcle2 = cMP.lechamp
join [File].Table_V_Campagne_Client_VALID_MGE cib
  on res.valeurcle1 = cib.BK_PersonalReference__c
 and res.valeurcle2 = cMP.lechamp
where res.colonne = 'Segment_ID__c'

*/

--DROP TABLE Resultat