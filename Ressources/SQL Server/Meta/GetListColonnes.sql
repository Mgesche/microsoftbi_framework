IF object_id(N'Meta.GetListColonnes', N'FN') IS NOT NULL
    DROP FUNCTION Meta.GetListColonnes
GO

CREATE FUNCTION [Meta].[GetListColonnes](
	@schema varchar(50),
  @table  varchar(50),
  @separateur  varchar(50)
) RETURNS varchar(500)
as
  /* =============================================================================== */
  /* Cette fonction renvois la liste des champs de la table ou de la fonction, dans  */
  /* l'ordre et avec un separateur                                                   */
  /*                                                                                 */
  /* @schema : schema de la table                                                    */
  /* @table : nom de la table                                                        */
  /* @separateur : separateur                                                        */
  /*                                                                                 */
  /* =============================================================================== */
  
/*

SELECT [Meta].[GetListColonnes] ('dbo', 'FactTicket', ',');

*/
BEGIN
  
DECLARE @col VARCHAR(50)
DECLARE @Result VARCHAR(500)
SET @Result = '';

/* Verification s'il s'agit d'une table ou d'une fonction */
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @table)
BEGIN
  DECLARE col_cursor CURSOR FOR 
  SELECT COLUMN_NAME
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @schema
    AND TABLE_NAME = @table
  ORDER BY ORDINAL_POSITION
END
ELSE
BEGIN
  DECLARE col_cursor CURSOR FOR 
  SELECT COLUMN_NAME
  FROM INFORMATION_SCHEMA.ROUTINE_COLUMNS
  WHERE TABLE_SCHEMA = @schema
    AND TABLE_NAME = @table
  ORDER BY ORDINAL_POSITION
END

OPEN col_cursor

FETCH NEXT FROM col_cursor 
INTO @col

WHILE @@FETCH_STATUS = 0
BEGIN
  
  SET @Result = @Result + @col + @separateur
  
  FETCH NEXT FROM col_cursor 
  INTO @col
  
END 
CLOSE col_cursor;
DEALLOCATE col_cursor;

SET @Result = SUBSTRING(@Result, 1, LEN(@Result)-LEN(@separateur))

RETURN @Result;

END

GO
