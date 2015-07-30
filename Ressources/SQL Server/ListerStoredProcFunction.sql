select * 
  from master.information_schema.routines 
 --where routine_type = 'PROCEDURE' 
 --  and Left(Routine_Name, 3) NOT IN ('sp_', 'xp_', 'ms_')
 
SELECT *
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = 'WebServices'
  AND ROUTINE_TYPE = 'FUNCTION'

SELECT * 
FROM INFORMATION_SCHEMA.PARAMETERS
WHERE SPECIFIC_SCHEMA = 'WebServices'
  AND SPECIFIC_NAME = 'GetCA'