SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
GO 
 
SELECT J.name AS job_name 
    , JS.step_name 
    , JS.command 
    , JS.database_name AS database_context 
    , NR.next_run_date_time 
    , CASE J.enabled WHEN 1 THEN 'YES' ELSE 'NO' END AS job_is_enabled 
    , CASE S.enabled WHEN 1 THEN 'YES' ELSE 'NO' END AS job_is_scheduled 
    , SP.name AS owner_login_name 
    , CASE S.freq_type 
      WHEN 1 THEN 'Once' 
      WHEN 4 THEN 'Daily' 
      WHEN 8 THEN 'Weekly' 
      WHEN 16 THEN 'Monthly' 
      WHEN 32 THEN 'Monthly relative' 
      WHEN 64 THEN 'When SQL Server Agent starts' 
      WHEN 128 THEN 'Start whenever the CPU(s) become idle' 
    END AS frenquency 
    , CASE S.freq_type 
      WHEN 1 THEN 'One time only' 
      WHEN 4 THEN 'Every ' + CASE CONVERT(varchar, S.freq_interval) WHEN '1' THEN 'day' ELSE 'days' END 
      WHEN 8 THEN 'Every ' + CASE CONVERT(varchar, S.freq_recurrence_factor) WHEN '1' THEN 'week' ELSE 'weeks' END + ' on ' + D.freq_day_concat 
      WHEN 16 THEN 'Day ' + CONVERT(varchar, S.freq_interval) + ' of every ' 
        + CASE CONVERT(varchar, S.freq_recurrence_factor) WHEN '1' THEN ' month' ELSE ' months' END 
      WHEN 32 THEN 'The ' + CASE S.freq_relative_interval 
              WHEN 1 THEN 'first' 
              WHEN 2 THEN 'second' 
              WHEN 4 THEN 'third' 
              WHEN 8 THEN 'fourth' 
              WHEN 16 THEN 'last' 
            END 
            + ' ' 
            + CASE S.freq_interval 
              WHEN 1 THEN 'Sunday' 
              WHEN 2 THEN 'Monday' 
              WHEN 3 THEN 'Tuesday' 
              WHEN 4 THEN 'Wednesday' 
              WHEN 5 THEN 'Thursday' 
              WHEN 6 THEN 'Friday' 
              WHEN 7 THEN 'Saturday' 
              WHEN 8 THEN 'Day' 
              WHEN 9 THEN 'Weekday' 
              WHEN 10 THEN 'Weekend Day' 
            END 
            + ' of every ' 
            + CASE CONVERT(varchar, S.freq_recurrence_factor) WHEN '1' THEN ' month' ELSE ' months' END 
    END + CASE S.freq_subday_type 
      WHEN 1 THEN ', once, at ' + AT.start_time 
      WHEN 2 THEN ', every ' + CONVERT(varchar(10), S.freq_subday_interval) 
          + ' seconds, starting at ' + AT.start_time 
          + ' ending at '  + AT.end_time 
      WHEN 4 THEN ', every ' + CONVERT(varchar(10), S.freq_subday_interval) + ' minutes, from ' 
          + AT.start_time + ', to ' + AT.end_time 
      WHEN 8 THEN ', every ' + CONVERT(varchar(10), S.freq_subday_interval) + ' hours, starting at ' 
          + AT.start_time + ', ending at ' + AT.end_time 
    END AS frequency_detail 
    , CASE 
      WHEN S.freq_type = 1 THEN 'On date: ' + AD.active_start_date + ' At time: ' 
              + AT.start_time 
      WHEN S.freq_type < 64 THEN 'Start date: ' + AD.active_start_date + 
              + CASE AD.active_end_date 
                WHEN '31/12/9999' THEN ' - No end date'  
                ELSE ' - End date: ' + AD.active_end_date  
              END 
    END AS date_range 
    , CASE C.name WHEN '[Uncategorized (Local)]' THEN 'Uncategorized' ELSE C.name END AS job_category_name 
    , J.description AS job_description 
    , J.date_created  
    , J.date_modified 
FROM    msdb.dbo.sysjobs AS J 
INNER JOIN  msdb.dbo.sysjobsteps AS JS 
      ON J.job_id = JS.job_id 
INNER JOIN  msdb.dbo.sysjobschedules AS JSCH 
      ON J.job_id = JSCH.job_id 
INNER JOIN  msdb.dbo.sysschedules AS S 
      ON JSCH.schedule_id = S.schedule_id 
INNER JOIN  msdb.dbo.syscategories AS C 
      ON J.category_id = C.category_id 
LEFT JOIN  sys.server_principals AS SP 
      ON SP.sid = J.owner_sid 
OUTER APPLY  ( 
      SELECT  freq_day + ', ' 
      FROM  ( 
          SELECT CASE WHEN S.freq_interval & 1 = 1 THEN 'Sunday' ELSE '' END AS freq_day 
          UNION ALL SELECT CASE WHEN S.freq_interval & 2 = 2 THEN 'Monday' ELSE '' END 
          UNION ALL SELECT CASE WHEN S.freq_interval & 4 = 4 THEN 'Tuesday' ELSE '' END 
          UNION ALL SELECT CASE WHEN S.freq_interval & 8 = 8 THEN 'Wednesday' ELSE '' END 
          UNION ALL SELECT CASE WHEN S.freq_interval & 16 = 16 THEN 'Thursday' ELSE '' END 
          UNION ALL SELECT CASE WHEN S.freq_interval & 32 = 32 THEN 'Friday' ELSE '' END 
          UNION ALL SELECT CASE WHEN S.freq_interval & 64 = 64 THEN 'Saturday' ELSE '' END 
        ) AS S 
      WHERE  LEN(freq_day) > 0 
      FOR  XML PATH ('') 
    ) AS D (freq_day_concat) 
OUTER APPLY  ( 
      SELECT  STUFF(STUFF(REPLICATE('0', 6 - LEN(S.active_start_time))  
          + CAST(S.active_start_time AS varchar(6)), 3, 0, ':'), 6, 0, ':') AS start_time 
        , STUFF(STUFF(REPLICATE('0', 6 - LEN(S.active_end_time))  
          + CAST(S.active_end_time AS varchar(6)), 3, 0, ':'), 6, 0, ':') AS end_time 
    ) AS AT 
OUTER APPLY  ( 
      SELECT  CONVERT(char(10), CAST(CAST(S.active_start_date AS char(8)) AS date), 103) AS active_start_date 
        , CONVERT(char(10), CAST(CAST(S.active_end_date AS char(8)) AS date), 103) AS active_end_date 
    ) AS AD 
OUTER APPLY  ( 
      SELECT  CAST(NULLIF(JSCH.next_run_date, 0) AS char(8)) + ' ' 
        + STUFF(STUFF(REPLICATE('0', 6 - LEN(JSCH.next_run_time)) + CAST(JSCH.next_run_time AS char(6)), 3, 0, ':'), 6, 0, ':') AS next_run_date_time 
    ) AS NR 
WHERE    1 = 1 
--AND    J.name LIKE '%unMot%' 
--AND    JS.database_name = 'uneBD' 
--AND    J.enabled  = 1 
ORDER BY  J.name, JS.step_id