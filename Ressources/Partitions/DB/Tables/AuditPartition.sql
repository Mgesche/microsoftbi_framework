IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditPartition' AND TABLE_SCHEMA = 'DSV')
BEGIN
	DROP TABLE DSV.AuditPartition
END

CREATE TABLE DSV.AuditPartition (
	audittraitement_id	int identity(1,1),
	id_Partition		int,
	id_Etape			int,
	DtDebut				datetime,
	DtFin				datetime,
	StrUser				varchar(50),
	StrMessageErreur	varchar(500)
)