select source,
       max(dtdebut) as dtdebut,
	   max(dtfin) as dtfin,
	   cast(max(dtfin) - max(dtdebut) as time) as duree
from (
select source, 
       case when event = 'OnPreExecute' then starttime else null end as dtdebut, 
	   case when event = 'OnPostExecute' then starttime else null end as dtfin
from  [BotanicDW_MEC].[dbo].[sysssislog]
where executionid = '860E13A2-A5A3-401C-B215-D00653CC8F2F'
) RES
GROUP BY source
order by dtdebut