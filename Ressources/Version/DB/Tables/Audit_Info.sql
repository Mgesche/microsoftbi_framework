IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Audit_Info' AND TABLE_SCHEMA = 'Version')
BEGIN
	DROP TABLE Version.Audit_Info
END

CREATE TABLE Version.Audit_Info
(
       Audit_Id             bigint IDENTITY(1,1),
       EventTime            DATETIME,
       LoginName            VARCHAR(255),
       UserName             VARCHAR(255),
       HostName             VARCHAR(255),
       ApplicationName      VARCHAR(255),
       DatabaseName         VARCHAR(255),
       SchemaName           VARCHAR(255),
       ObjectName           VARCHAR(255),
       ObjectType           VARCHAR(255),      
       DDLCommand           VARCHAR(MAX)
)