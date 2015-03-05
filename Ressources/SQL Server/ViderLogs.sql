ALTER DATABASE DWH SET RECOVERY SIMPLE;

USE DWH;
GO
CHECKPOINT;
GO
CHECKPOINT; -- run twice to ensure file wrap-around
GO
DBCC SHRINKFILE(DWH_DIAMANT_Log, 80000);
GO