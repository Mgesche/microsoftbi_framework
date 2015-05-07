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
SELECT 2, 'Mise a jour structure du cube';

INSERT INTO DSV.AuditEtapes
SELECT 3, 'Process data';

INSERT INTO DSV.AuditEtapes
SELECT 4, 'Process index';