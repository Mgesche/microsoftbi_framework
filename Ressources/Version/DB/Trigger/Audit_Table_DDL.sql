IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_CREATE_TABLE')
    DROP TRIGGER Audit_Table_DDL_CREATE_TABLE ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_CREATE_TABLE
-- ON DATABASE
ON ALL SERVER
FOR CREATE_TABLE
AS

DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'CREATE_TABLE',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
GO

IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_ALTER_TABLE')
    DROP TRIGGER Audit_Table_DDL_ALTER_TABLE ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_ALTER_TABLE
-- ON DATABASE
ON ALL SERVER
FOR ALTER_TABLE
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'ALTER_TABLE',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
GO

IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_DROP_TABLE')
    DROP TRIGGER Audit_Table_DDL_DROP_TABLE ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_DROP_TABLE
-- ON DATABASE
ON ALL SERVER
FOR DROP_TABLE
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'DROP_TABLE',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
GO

IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_CREATE_INDEX')
    DROP TRIGGER Audit_Table_DDL_CREATE_INDEX ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_CREATE_INDEX
-- ON DATABASE
ON ALL SERVER
FOR CREATE_INDEX
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'CREATE_INDEX',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
GO

/*
DANGEREUX a cause de l maintenance des rebuild 
     
IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_ALTER_INDEX')
    DROP TRIGGER Audit_Table_DDL_ALTER_INDEX ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_ALTER_INDEX
-- ON DATABASE
ON ALL SERVER
FOR ALTER_INDEX
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'ALTER_INDEX',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
*/

IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_DROP_INDEX')
    DROP TRIGGER Audit_Table_DDL_DROP_INDEX ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_DROP_INDEX
-- ON DATABASE
ON ALL SERVER
FOR DROP_INDEX
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'DROP_INDEX',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
GO

IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_CREATE_TRIGGER')
    DROP TRIGGER Audit_Table_DDL_CREATE_TRIGGER ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_CREATE_TRIGGER
-- ON DATABASE
ON ALL SERVER
FOR CREATE_TRIGGER
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'CREATE_TRIGGER',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
GO

IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_ALTER_TRIGGER')
    DROP TRIGGER Audit_Table_DDL_ALTER_TRIGGER ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_ALTER_TRIGGER
-- ON DATABASE
ON ALL SERVER
FOR ALTER_TRIGGER
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'ALTER_TRIGGER',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
GO

IF EXISTS(SELECT 1 FROM sys.server_triggers WHERE NAME = 'Audit_Table_DDL_DROP_TRIGGER')
    DROP TRIGGER Audit_Table_DDL_DROP_TRIGGER ON ALL SERVER
GO

CREATE TRIGGER Audit_Table_DDL_DROP_TRIGGER
-- ON DATABASE
ON ALL SERVER
FOR DROP_TRIGGER
AS
DECLARE       @eventInfo XML
SET           @eventInfo = EVENTDATA()
 
INSERT INTO BOTANICDW_MEC.Version.Audit_Info (
     EventTime, LoginName, UserName, HostName, ApplicationName, DatabaseName, SchemaName, ObjectName, ObjectType, Action, DDLCommand
) VALUES
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
     'DROP_TRIGGER',
     CONVERT(VARCHAR(MAX),
          @eventInfo.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)'))
)
GO