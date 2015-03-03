select cp.cacheobjtype,cp.objtype , cp.usecounts, 
       convert(int,paexe.value) as ‘Nb exec’,
          db_name(convert(int,padb.value)) as ‘database’,
          qp.query_plan, est.text
from sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_plan_attributes(plan_handle) padb
CROSS APPLY sys.dm_exec_plan_attributes(plan_handle) paexe
CROSS APPLY sys.dm_exec_query_plan ( plan_handle ) qp
CROSS APPLY sys.dm_exec_sql_text (plan_handle) est  
WHERE padb.attribute = ‘dbid_execute’
AND   paexe.attribute = ‘hits_exec_context’
AND convert(int,padb.value) > 4 — BD utilisateur