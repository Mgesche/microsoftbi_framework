USE [BotanicDW_MEC]
GO

/****** Object:  StoredProcedure [Test].[CreeTableTest]    Script Date: 07/22/2015 10:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Test].[CreeTableTest]
	@strSchemaOrigine varchar(50) = 'dbo',
	@strTableOrigine varchar(50),
	@strSchemaTest varchar(50) = 'dbo',
	@strTableTest varchar(50) = '',
	@overwrite int = 0,
	@debug int = 0
AS
  /* ================================================================================= */
  /* Crée une table de test de meme structure que l'existante et remplis les données   */
  /* de la table d'administration                                                      */
  /*                                                                                   */
  /* @strSchemaOrigine : Schema de la table que l'on veux dupliquer (dbo par defaut)   */
  /* @strTableOrigine : Nom de la table que l'on veux dupliquer                        */
  /* @strSchemaTest : Schema dans laquelle on crée la table test (dbo par defaut)      */
  /* @strTableTest : Nom de la table test. Si '', on reprend le meme que la table      */
  /*                 origine en prefixant de Test_ si le schema est dbo, on conserve   */
  /*				 le meme nom sinon												   */
  /* @overwrite :                                                                      */
  /*		  0 : ne remplace pas la table si elle existe deja                         */
  /*		  1 : remplace la table                                                    */
  /* @debug : 																		   */
  /*		  0 : execute les requetes                        					       */
  /*		  1 : print les requetes                                                   */
  /*																				   */
  /* Erreur : -1 : Table deja existante mais overwrite non defini                      */
  /*																			       */
  /* ================================================================================= */
  
/*

Execution : 

DECLARE	@return_value int

EXEC	@return_value = [Test].[CreeTableTest]
		@strTableOrigine = 'FactProfilClient',
		@strSchemaTest = 'Test'

SELECT	'Return Value' = @return_value

Tests : 

Cas simple :

CREATE TABLE test1 (
	test varchar(50)
)

DECLARE	@return_value int

EXEC	@return_value = [Test].[CreeTableTest]
		@strTableOrigine = 'test1',
		@strSchemaTest = 'Test'

SELECT	'Return Value' = @return_value

SELECT * FROM [Test].[Ref_TablesTests]
WHERE strTableOrigine = 'test1'

SELECT * FROM Test.test1

Creation dans dbo : 

DECLARE	@return_value int

EXEC	@return_value = [Test].[CreeTableTest]
		@strTableOrigine = 'test1'

SELECT	'Return Value' = @return_value

SELECT * FROM [Test].[Ref_TablesTests]
WHERE strTableOrigine = 'test1'

SELECT * FROM dbo.Test_test1

Overwrite :

DECLARE	@return_value int

EXEC	@return_value = [Test].[CreeTableTest]
		@strTableOrigine = 'test1',
		@strSchemaTest = 'Test',
		@overwrite = 1

SELECT	'Return Value' = @return_value

SELECT * FROM [Test].[Ref_TablesTests]
WHERE strTableOrigine = 'test1'

SELECT * FROM Test.test1

Plantage si la table existe mais pas overwrite :

DECLARE	@return_value int

EXEC	@return_value = [Test].[CreeTableTest]
		@strTableOrigine = 'test1',
		@strSchemaTest = 'Test'

SELECT	'Return Value' = @return_value

SELECT * FROM [Test].[Ref_TablesTests]
WHERE strTableOrigine = 'test1'

SELECT * FROM Test.test1

*/

DECLARE @Resultat int

/* Evaluation de @strTableTest */
IF @strSchemaTest = 'dbo' AND @strTableTest = '' BEGIN
	SET @strTableTest = 'Test_'+@strTableOrigine
END
IF @strSchemaTest <> 'dbo' AND @strTableTest = '' BEGIN
	SET @strTableTest = @strTableOrigine
END

/* Variables */
DECLARE @TableNameOrigine VARCHAR(100)
DECLARE @TableNameTest VARCHAR(100)
DECLARE @Query NVARCHAR(500)
SET @TableNameOrigine = @strSchemaOrigine+'.'+@strTableOrigine
SET @TableNameTest = @strSchemaTest+'.'+@strTableTest

/* Suppression de la table test si necessaire et autorise */
IF @overwrite = 1
BEGIN

	DECLARE @schema_ASuppr varchar(50), @table_ASuppr varchar(50)

	DECLARE ASuppr_cursor CURSOR FOR 
	SELECT strSchemaTest, strTableTest
	FROM [Test].[Ref_TablesTests]
	WHERE strSchemaOrigine = @strSchemaOrigine
	  AND strTableOrigine = @strTableOrigine

	OPEN ASuppr_cursor

	FETCH NEXT FROM ASuppr_cursor 
	INTO @schema_ASuppr, @table_ASuppr

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		/* Drop table */
		SET @Query = N'IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '''+@schema_ASuppr+''' AND TABLE_NAME = '''+@table_ASuppr+''') DROP TABLE '+@schema_ASuppr+'.'+@table_ASuppr
		IF @debug = 1 PRINT @Query
		IF @debug = 0 EXEC sp_executesql @Query;

		/* Gestion infos Ref_TablesTests */
		DELETE FROM [Test].[Ref_TablesTests]
		WHERE strSchemaTest = @schema_ASuppr
		  AND strTableTest = @table_ASuppr

		FETCH NEXT FROM ASuppr_cursor 
		INTO @schema_ASuppr, @table_ASuppr
	END 
	CLOSE ASuppr_cursor;
	DEALLOCATE ASuppr_cursor;

END

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @strSchemaTest AND TABLE_NAME = @strTableTest)
BEGIN
	SET @Resultat = -1
END	
ELSE BEGIN

	/* Creation de la table de test */
	SET @Query = N'SELECT TOP 0 * INTO '+@TableNameTest+' FROM '+@TableNameOrigine
	IF @debug = 1 PRINT @Query
	IF @debug = 0 EXEC sp_executesql @Query;
	
	/* Gestion infos Ref_TablesTests */
	INSERT INTO [Test].[Ref_TablesTests] (strSchemaOrigine, strTableOrigine, strSchemaTest, strTableTest, iEtatTest)
	SELECT @strSchemaOrigine, @strTableOrigine, @strSchemaTest, @strTableTest, 0

END

RETURN @Resultat


GO


