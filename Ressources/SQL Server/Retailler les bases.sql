USE [ODS]
GO

/* Attention : eviter au maximum, cela va créer des problémes de fragmentation d'index monstrueux */

/* 10% disponibles */
DBCC SHRINKDATABASE(N'ODS', 10 )
GO

Prévoir un DBCC INDEXDEFRAG
