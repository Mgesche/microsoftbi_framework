IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditEtapes' AND TABLE_SCHEMA = 'DSV')
BEGIN
	DROP TABLE DSV.AuditEtapes
END

CREATE TABLE DSV.AuditEtapes (
	idEtape		int,
	strEtape	varchar(50)
);

INSERT INTO DSV.AuditEtapes
SELECT 1, 'Chargement DSV';

INSERT INTO DSV.AuditEtapes
SELECT 2, 'Creation structure du cube';

INSERT INTO DSV.AuditEtapes
SELECT 3, 'Mise a jour structure du cube';

INSERT INTO DSV.AuditEtapes
SELECT 4, 'Process data';

INSERT INTO DSV.AuditEtapes
SELECT 5, 'Process index';

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditPartition' AND TABLE_SCHEMA = 'DSV')
BEGIN
	DROP TABLE DSV.AuditPartition
END

CREATE TABLE DSV.AuditPartition (
	audittraitement_id	int identity(1,1),
	id_Partition		int,
	id_Etape				int,
	DtDebut				datetime,
	DtFin				datetime,
	StrUser				varchar(50),
	StrMessageErreur	varchar(500)
)
