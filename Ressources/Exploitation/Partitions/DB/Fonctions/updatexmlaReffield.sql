IF object_id(N'DSV.updatexmlaReffield', N'FN') IS NOT NULL
    DROP FUNCTION DSV.updatexmlaReffield
GO

CREATE function [DSV].[updatexmlaReffield] (
	@id as int) RETURNS varchar(5000)
AS
BEGIN
declare @chaine as varchar(5000)
set @chaine =(
	select +
	'<Alter ObjectExpansion="ExpandFull" xmlns="http://schemas.microsoft.com/analysisservices/2003/engine">
    <Object>
        <DatabaseID>'+p.databaseid+'</DatabaseID>
        <CubeID>'+p.cubeid+'</CubeID>
        <MeasureGroupID>'+p.measuregroupidreference+'</MeasureGroupID>
        <PartitionID>' + p.period + ' ' + p.SousPeriod + ' ' + p.Fact + ' REF</PartitionID>
    </Object>
    <ObjectDefinition>
        <Partition xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200">
          <ID> ' + p.period + ' ' + p.SousPeriod + ' ' + p.Fact + ' REF</ID>
           <Name>' + p.period + ' ' + p.SousPeriod + ' ' + p.Fact + ' REF</Name>
            <Annotations>
                <Annotation>
                    <Name>AggregationPercent</Name>
                    <Value>0</Value>
                </Annotation>
            </Annotations>
            <Source xsi:type="QueryBinding">
                <DataSourceID>'+p.datasourceid+'</DataSourceID>
                <QueryDefinition>'+REPLACE(p.partitiontablequery, p.PartitionTable, 'DSV.'+p.PartitionTable+'_'+p.Id)+'</QueryDefinition>
            </Source>
            <StorageMode>Molap</StorageMode>
            <ProcessingMode>Regular</ProcessingMode>
            <ProactiveCaching>
                <SilenceInterval>-PT1S</SilenceInterval>
                <Latency>-PT1S</Latency>
                <SilenceOverrideInterval>-PT1S</SilenceOverrideInterval>
                <ForceRebuildInterval>-PT1S</ForceRebuildInterval>
                <Source xsi:type="ProactiveCachingInheritedBinding" />
            </ProactiveCaching>
        </Partition>
    </ObjectDefinition>
</Alter>'
from  partitions p 
WHERE p.id = @id  )

return @chaine
END