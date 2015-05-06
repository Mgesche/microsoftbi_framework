/* Exemple

SELECT [DSV].[GetDifferencePartition] ()

*/
IF object_id(N'DSV.GetDifferencePartition', N'FN') IS NOT NULL
    DROP FUNCTION DSV.GetDifferencePartition
GO

CREATE function [DSV].[GetDifferencePartition] ()
RETURNS int
AS
BEGIN
	
RETURN (SELECT COUNT(*)
FROM dbo.partitions ANC
LEFT JOIN DSV.partitions NEW
  ON ANC.id = NEW.id
WHERE NEW.id IS NULL)

END

GO