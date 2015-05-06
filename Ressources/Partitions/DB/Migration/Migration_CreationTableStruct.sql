DECLARE @strFact VARCHAR(50)
DECLARE @Query NVARCHAR(MAX)

DECLARE fact_cursor CURSOR FOR 
SELECT DISTINCT Fact FROM DSV.partitions

OPEN fact_cursor

FETCH NEXT FROM fact_cursor 
INTO @strFact

WHILE @@FETCH_STATUS = 0
BEGIN
  
  /* Suppression si la table existe deja */
  IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'DSV' AND TABLE_NAME = @strFact+'_STRUCT')
  BEGIN
  	SET @Query = N'DROP TABLE DSV.'+@strFact+'_STRUCT'
  	EXECUTE sp_executesql @Query
  END
  
  /* Creation de la table */
  SET @Query =         N'SELECT TOP 0 * '
  SET @Query = @Query + 'INTO DSV.'+@strFact+'_STRUCT '
  SET @Query = @Query + 'FROM dbo.'+@strFact  
  EXECUTE sp_executesql @Query
  
  /* Creation des index */
  DECLARE @strFactStruct VARCHAR(100)
  SET @strFactStruct = @strFact+'_Struct'

  EXECUTE [Utils].[copieIndex] 'dbo', @strFact, 'DSV', @strFactStruct
  
  FETCH NEXT FROM fact_cursor 
  INTO @strFact
  
END

CLOSE fact_cursor
DEALLOCATE fact_cursor