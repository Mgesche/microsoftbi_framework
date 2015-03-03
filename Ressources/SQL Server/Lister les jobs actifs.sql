/* Lister les jobs */
SELECT [name] FROM msdb.dbo.sysjobs
where enabled = '1'
ORDER BY [name];

/* Desactiver l'ensemble des jobs */
update msdb.dbo.sysjobs
set enabled = '0'
where enabled = '1'

/* Desactiver l'ensemble des planifications */
update msdb.dbo.sysschedules
set enabled = '0'
where enabled = '1'