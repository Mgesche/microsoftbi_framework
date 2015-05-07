DECLARE @strPartitionTableUnitaire VARCHAR(50)
DECLARE @Query NVARCHAR(MAX)

DECLARE fact_cursor CURSOR FOR 
SELECT DISTINCT PartitionTableUnitaire FROM DSV.partitions

OPEN fact_cursor

FETCH NEXT FROM fact_cursor 
INTO @strPartitionTableUnitaire

WHILE @@FETCH_STATUS = 0
BEGIN
  
  /* Suppression si la table existe deja */
  IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'DSV' AND TABLE_NAME = @strPartitionTableUnitaire+'_STRUCT')
  BEGIN
  	SET @Query = N'DROP TABLE DSV.'+@strPartitionTableUnitaire+'_STRUCT'
  	EXECUTE sp_executesql @Query
  END
  
  /* Creation de la table */
  SET @Query =         N'SELECT TOP 0 * '
  SET @Query = @Query + 'INTO DSV.'+@strPartitionTableUnitaire+'_STRUCT '
  SET @Query = @Query + 'FROM dbo.'+@strPartitionTableUnitaire  
  EXECUTE sp_executesql @Query
  
  /* Creation des index */
  DECLARE @strPartitionTableUnitaireStruct VARCHAR(100)
  SET @strPartitionTableUnitaireStruct = @strPartitionTableUnitaire+'_Struct'

  EXECUTE [Utils].[copieIndex] 'dbo', @strPartitionTableUnitaire, 'DSV', @strPartitionTableUnitaireStruct
  
  FETCH NEXT FROM fact_cursor 
  INTO @strPartitionTableUnitaire
  
END

CLOSE fact_cursor
DEALLOCATE fact_cursor