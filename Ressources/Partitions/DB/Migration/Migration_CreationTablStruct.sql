DECLARE @strFact VARCHAR(50)
DECLARE @Query VARCHAR(MAX)

DECLARE req_cursor CURSOR FOR 
SELECT DISTINCT Fact FROM DSV.partitions

OPEN req_cursor

FETCH NEXT FROM req_cursor 
INTO @strFact

WHILE @@FETCH_STATUS = 0
BEGIN
  
  /* Suppression si la table existe deja */
  IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA WHERE TABLE_SCHEMA = 'DSV' AND TABLE_NAME = @strFact+'_STRUCT')
  BEGIN
  	SET @Query = 'DROP TABLE DSV.'+@strFact+'_STRUCT'
  	EXECUTE sp_executesql @Query
  END
  
  /* Creation de la table */
  SET @Query =          'SELECT TOP 0 * '
  SET @Query = @Query + 'INTO DSV.'+@strFact+'_STRUCT'
  SET @Query = @Query + 'FROM dbo.'+@strFact  
  EXECUTE sp_executesql @Query
  
  /* Creation des index */
  EXECUTE [Utils].[copieIndex]('dbo', @strFact, 'DSV', @strFact+'_Struct')
  
  FETCH NEXT FROM req_cursor 
  INTO @strFact
  
END

CLOSE req_cursor
DEALLOCATE req_cursor