IF object_id(N'DSV.processxmlareffield', N'FN') IS NOT NULL
    DROP FUNCTION DSV.processxmlareffield
GO

CREATE function [DSV].[processxmlareffield] (
	@id as int) RETURNS varchar(5000)
AS
BEGIN
declare @chaine as varchar(5000)
set @chaine =(
	select +
	
	
	'<Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<Object>
        <DatabaseID>'+p.databaseid+'</DatabaseID>
        <CubeID>'+p.cubeid+'</CubeID>
        <MeasureGroupID>'+p.MeasureGroupIDReference+'</MeasureGroupID>
        <PartitionID>' + p.period + ' ' + p.SousPeriod + ' ' + p.Fact + ' REF</PartitionID>
      </Object>
      <Type>ProcessData</Type>
      <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
    </Process>'


from  partitions p 
WHERE p.id = @id  )

return @chaine
END