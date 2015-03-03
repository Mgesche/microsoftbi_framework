SELECT sql.text as ‘requete’,COUNT(*) as ‘Nbre plans’ 
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text (plan_handle) sql
where cp.usecounts <=1
GROUP BY sql.text