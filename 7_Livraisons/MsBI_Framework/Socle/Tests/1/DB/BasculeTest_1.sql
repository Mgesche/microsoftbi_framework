CREATE PROCEDURE [Test].[BasculeTest]
	@strSchemaOrigine varchar(50) = 'dbo',
	@strTableOrigine varchar(50),
	@iEtatTestNew int,
	@debug int = 0
AS
  /* ================================================================================= */
  /* Bascule les données entre la table et la table de test							   */
  /*                                                                                   */
  /* @strSchemaOrigine : Schema de la table (dbo par defaut)   						   */
  /* @strTableOrigine : Nom de la table 											   */
  /* @iEtatTestNew :    															   */
  /*		  0 : Remet les données d'origine  					                       */
  /*		  1 : Recupere les données de test	                                       */
  /* @debug : 																		   */
  /*		  0 : execute les requetes                        					       */
  /*		  1 : print les requetes                                                   */
  /*																				   */
  /* Erreur : -1 : Les données sont deja presente dans le bon environnement            */
  /*																			       */
  /* ================================================================================= */
  
/*

Execution : 

DECLARE	@return_value int

EXEC	@return_value = [Test].[BasculeTest]
		@strTableOrigine = 'FactProfilClient',
		@iEtatTest = 1

SELECT	'Return Value' = @return_value

Tests : 

Cas simple

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'test1') DROP TABLE dbo.Test1
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'test1_sav') DROP TABLE dbo.test1_sav
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Test' AND TABLE_NAME = 'test1') DROP TABLE Test.Test1
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Test' AND TABLE_NAME = 'test1_sav') DROP TABLE Test.test1_sav

CREATE TABLE test1 (
	test varchar(50)
)

INSERT INTO test1
SELECT 'Rien'

INSERT INTO test1
SELECT 'Tout'

SELECT *
FROM test1

DECLARE	@return_value int

EXEC	@return_value = [Test].[CreeTableTest]
		@strTableOrigine = 'test1',
		@strSchemaTest = 'Test'

SELECT	'Return Value' = @return_value

INSERT INTO Test.test1
SELECT 'Teeeest'

SELECT *
FROM test1

SELECT *
FROM Test.test1

SELECT *
FROM [Test].[Ref_TablesTests]

DECLARE	@return_value int

EXEC	@return_value = [Test].[BasculeTest]
		@strTableOrigine = 'test1',
		@iEtatTestNew = 1

SELECT	'Return Value' = @return_value

SELECT *
FROM test1

SELECT *
FROM Test.test1

SELECT *
FROM [Test].[Ref_TablesTests]

*/

DECLARE @Query NVARCHAR(500)

/* Recuperation des noms complets */
DECLARE @strTableOrigine_Complet VARCHAR(100)
DECLARE @strTableOrigine_Sav VARCHAR(100)
DECLARE @strTableOrigine_Sav_Complet VARCHAR(100)
DECLARE @strTableOrigine_Sav_Complet_SchemaTest VARCHAR(100)

DECLARE @strSchemaTest VARCHAR(100)
DECLARE @strTableTest VARCHAR(100)
DECLARE @iEtatTest  int
DECLARE @strTableTest_Sav VARCHAR(100)
DECLARE @strTableTest_Complet VARCHAR(100)
DECLARE @strTableTest_Complet_SchemaOri VARCHAR(100)
DECLARE @strTableTest_Sav_Complet VARCHAR(100)

SET @strTableOrigine_Complet = @strSchemaOrigine+'.'+@strTableOrigine
SET @strTableOrigine_Sav = @strTableOrigine+'_sav'
SET @strTableOrigine_Sav_Complet = @strSchemaOrigine+'.'+@strTableOrigine_Sav

SET @strSchemaTest = (SELECT strSchemaTest
					FROM [Test].[Ref_TablesTests]
					WHERE strSchemaOrigine = @strSchemaOrigine
					  AND strTableOrigine = @strTableOrigine)

SET @strTableTest = (SELECT strTableTest
					FROM [Test].[Ref_TablesTests]
					WHERE strSchemaOrigine = @strSchemaOrigine
					  AND strTableOrigine = @strTableOrigine)

SET @iEtatTest = (SELECT iEtatTest
					FROM [Test].[Ref_TablesTests]
					WHERE strSchemaOrigine = @strSchemaOrigine
					  AND strTableOrigine = @strTableOrigine)

SET @strTableTest_Sav = @strTableTest+'_sav'
SET @strTableTest_Complet = @strSchemaTest+'.'+@strTableTest
SET @strTableTest_Sav_Complet = @strSchemaTest+'.'+@strTableTest_Sav
SET @strTableTest_Complet_SchemaOri = @strSchemaOrigine+'.'+@strTableTest
SET @strTableOrigine_Sav_Complet_SchemaTest = @strSchemaTest+'.'+@strTableOrigine_Sav

/* Gerer les changements de schema */
DECLARE @isSchemaDiff int
SET @isSchemaDiff = (SELECT CASE WHEN strSchemaOrigine = strSchemaTest THEN 1 ELSE 0 END
					FROM [Test].[Ref_TablesTests]
					WHERE strSchemaOrigine = @strSchemaOrigine
					  AND strTableOrigine = @strTableOrigine)	  

/* Sauvegarde des donnees de la table origine */
SET @Query = N'EXEC sp_rename '''+@strTableOrigine_Complet+''', '''+@strTableOrigine_Sav+''' '
IF @debug = 1 PRINT @Query
IF @debug = 0 EXEC sp_executesql @Query;

/* Transfert vers le schema origine des donnees tests */
IF @isSchemaDiff = 0
BEGIN
	SET @Query = N'ALTER SCHEMA '+@strSchemaOrigine+' TRANSFER '+@strTableTest_Complet
	IF @debug = 1 PRINT @Query
	IF @debug = 0 EXEC sp_executesql @Query;
END

/* Copie des données tests vers origine */
SET @Query = N'EXEC sp_rename '''+@strTableTest_Complet_SchemaOri+''', '''+@strTableOrigine+''' '
IF @debug = 1 PRINT @Query
IF @debug = 0 EXEC sp_executesql @Query;

/* Transfert vers le schema test des donnees origine */
IF @isSchemaDiff = 0
BEGIN
	SET @Query = N'ALTER SCHEMA '+@strSchemaTest+' TRANSFER '+@strTableOrigine_Sav_Complet
	IF @debug = 1 PRINT @Query
	IF @debug = 0 EXEC sp_executesql @Query;
END

/* Copie des données origine vers tests */
SET @Query = N'EXEC sp_rename '''+@strTableOrigine_Sav_Complet_SchemaTest+''', '''+@strTableTest+''' '
IF @debug = 1 PRINT @Query
IF @debug = 0 EXEC sp_executesql @Query;

/* Stockage du changement dans ref_TablesTests */
UPDATE [Test].[Ref_TablesTests]
SET iEtatTest = CASE iEtatTest 
					WHEN 0 THEN 1
					WHEN 1 THEN 0 END

GO

/* TODO : A completer notamment avec la gestion des erreurs */
/* TODO : Gerer le iEtatTest de maniere plus fine, faire des verifs avant de basculer */
/* TODO : Ajout des tests */