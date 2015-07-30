SELECT ItemPath, SUM(Nb_Execution) AS Nb_Execution
FROM (
SELECT InstanceName, ItemPath, BotanicDW_MEC.dbo.DateToInt(TimeStart) as DateVisu, UserName, COUNT(DISTINCT COALESCE(ExecutionId, N'xxx')) AS Nb_Execution, 
SUM(TimeDataRetrieval)+SUM(TimeProcessing)+SUM(TimeRendering) as Temps
FROM dbo.ExecutionLog3
GROUP BY InstanceName, ItemPath, BotanicDW_MEC.dbo.DateToInt(TimeStart), UserName
) RAP
GROUP BY ItemPath
ORDER BY ItemPath