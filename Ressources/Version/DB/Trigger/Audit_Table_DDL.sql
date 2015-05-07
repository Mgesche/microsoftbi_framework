IF object_id(N'Audit_Table_DDL', N'TR') IS NOT NULL
    DROP TRIGGER Audit_Table_DDL
GO

CREATE TRIGGER Audit_Table_DDL
-- ON DATABASE
ON ALL SERVER
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE, CREATE_INDEX, ALTER_INDEX, DROP_INDEX, CREATE_TRIGGER, ALTER_TRIGGER, DROP_TRIGGER
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info VALUES
(
     REPLACE(CONVERT(VARCHAR(50),
          @eventInfo.query('data(/EVENT_INSTANCE/PostTime)')),'T', ' '),
     CONVERT(VARCHAR(255),
          @eventInfo.query('data(/EVENT_INSTANCE/LoginName)')),
     CONVERT(VARCHAR(255),
          @eventInfo.query('data(/EVENT_INSTANCE/UserName)')),
     CONVERT(VARCHAR(255),
          @eventInfo.query('data(/EVENT_INSTANCE/HostName)')),
     CONVERT(VARCHAR(255),
          @eventInfo.query('data(/EVENT_INSTANCE/ApplicationName)')),
     CONVERT(VARCHAR(255),
          @eventInfo.query('data(/EVENT_INSTANCE/DatabaseName)')),
     CONVERT(VARCHAR(255),
          @eventInfo.query('data(/EVENT_INSTANCE/SchemaName)')),
     CONVERT(VARCHAR(255),
          @eventInfo.query('data(/EVENT_INSTANCE/ObjectName)')),
     CONVERT(VARCHAR(255),
          @eventInfo.query('data(/EVENT_INSTANCE/ObjectType)')),
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)