USE [master]
GO
--==========================================================
-- Author: (c) 2011 Pavel Pawlowski
-- Description: Generates CRUD procedures for a table
--
--@objectName = table name with or without schema for which the CRUD procedures should be generated
--
--@executionMode
--  1 = Print the script Only
--  2 = Output the script as recordset using SELECT for longer procedures which is not possible output using PRINT
--  4 = Execute and Commit
--  8 = Execute and Rollback - testing mode
--
--@dropExistingProcedures = 1 | 0
-- specifies whether generate DROP commands for existing objects
--
--@outputIndentityCalcFields = 1 | 0
-- specifies whether Identity and Calculated fields should be OUTPUTed in INSERT and UPDATE
--==========================================================
CREATE PROCEDURE [dbo].[sp_makeCRUD]
    @objectName sysname,
    @executionMode tinyint = 1,
    @dropExistingProcedures bit = 1,
    @outputIndentityCalcFields bit = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
 
    --variables declaration
    DECLARE
        @objId int,                                 --ID of the Table
        @schemaName sysname,                        --schema Name of the Table
        @tableName sysname,                         --TableName
        @dbName sysname,                            --Database name in which we are creating the procedures
        @crlfXML nchar(7),                          --XML representation of the CLRF
        @crlf nchar(2),                             --CLRF characters
        @procPrefix sysname,                        --CRUD procedures Prefix
        @sql nvarchar(max),                         --SQL code for particular steps
        @msg nvarchar(max),                         --A message
        @suffixSelect sysname,                      --Suffix for SELECT procedure
        @suffixUpdate sysname,                      --Suffix for UPDATE procedure
        @suffixDelete sysname,                      --Suffix for Delete procedure
        @suffixInsert sysname,                      --Suffix for INSERT procedure
        @selectParams nvarchar(max),                --Parameters for SELECT procedure
        @allColumns nvarchar(max),                  --List of All columns in a table for SELECT statement
        @selectAllIfNullCondition nvarchar(max),    --Condition for checking if all parameters in SELECT procedure are NULL
        @selectCondition nvarchar(max),             --SELECT statement condition
        @updateParams nvarchar(max),                --Parameters for UPDATE procedure
        @updateColumns nvarchar(max),               --List of columns for UPDATE statement
        @updateDeleteCondition nvarchar(max),       --Condition for UPDATE and DELETE statement
        @updateOutputCols nvarchar(max),            --List of UPDATE statement output columns to output calculated columns
        @deleteParams nvarchar(max),                --Parameters for DELETE procedure
        @insertParams nvarchar(max),                --Parameters for INSERT procedure
        @insertColumns nvarchar(max),               --List of COLUMNS for INSERT statement
        @insertOutputCols nvarchar(max),            --List of INSERT statement ouptup columns to output IDENTITY and calculated fields
        @insertParamNames nvarchar(max),            --List of parameter names in Insert procedure
        @isTooLongForPrint bit                      --Sores info whether some of the procs is too long for PRINT
 
    --Declaration of fields Table Variables
    DECLARE @pkFields TABLE (        --Table variable for storing fields which are part of primary key
        name sysname,                --field Name
        fieldType sysname            --Specified data type of the field
    )
    DECLARE @allFields TABLE (
        name sysname,                --field name
        isIdentity bit,              --specifies whether field is INDENTITY
        isCalculated bit,            --specifies whether filed is Calculated field
        fieldType sysname            --Specified data type of the field
    )
 
    --Table variable for storing scripts for execution
    DECLARE @scripts TABLE (
        id int NOT NULL IDENTITY,
        script nvarchar(max)
    )
 
    --Check if an execution mode is selected
    IF ((@executionMode & 7) = 0)
    BEGIN
        SET @msg = N'You have to select at at leas one possible execution Mode (@executionMode)
    1 = Print the script Only
    2 = Output the script as SELECT resordset for longer procedures which is not possible output using PRINT
    4 = Execute and Commit
    8 = Execute and Rollback - testing mode
 
You can also combine the Print and Execute Modes, but you cannot combine both execution modes'
        RAISERROR (@msg, 11, 1)
        RETURN
    END
 
    IF ((@executionMode & 6) = 6)
    BEGIN
        SET @msg = N'You cannot specify Execute and Commit with Execute and Rollback Together'
        RAISERROR (@msg, 11, 1)
        RETURN
    END
 
    --populate parameters and constants
    SELECT
        @objID = OBJECT_ID(@objectName),
        @dbName = DB_NAME(),
        @crlfXML = N'
' + NCHAR(10),    --XML Representation of the CR+LF delimiter as we use FOR XML PATH ant this translates the original CR+LF to XML Equivalent. We need it to change it back
        @crlf = NCHAR(13) + NCHAR(10),        --CR+LF delimiter used in script
        @procPrefix = 'usp_CRUD_',            --Specifies prefix to be added to all CRUD procedures
        @suffixSelect = '_S',                --Specifies suffix to be added to the Select Procedure
        @suffixUpdate = '_U',                --Specifies suffix to be added to the Update Procedure
        @suffixDelete = '_D',                --Specifies suffix to be added to the Delete Procedure
        @suffixInsert = '_I'                --Specifies suffix to be added to the Inser Procedure
 
    --Check whether object exists
    IF @objId IS NULL
    BEGIN
        SET @msg = N'Object "' + @objectName + '" doesnt'' exist in database ' + QUOTENAME(@dbName)
        RAISERROR (@msg, 11, 1)
        RETURN
    END
 
    --Populate table name and schema name
    SELECT
        @schemaName = s.name,
        @tableName = o.name
    FROM sys.objects o
    INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
    WHERE o.object_id = @objId AND o.type = 'U'
 
    --check whether object is table
    IF (@tableName IS NULL)
    BEGIN
        SET @msg = N'Object "' + @objectName + '" is not User Table. Creating CRUD procedures is possible only on User Tables.'
        RAISERROR (@msg, 11, 1)
        RETURN
    END
 
    --Get all table fields and store them in the @allFields table variable for construction of CRUD procedures
    INSERT INTO @allFields (
        name,
        isIdentity,
        isCalculated,
        fieldType
    )
    SELECT
        c.name,
        is_identity,
        is_computed,
        CASE
            WHEN t.name IN (N'char', N'nchar', N'varchar', N'nvarchar') THEN QUOTENAME(t.name) + N'(' + CASE WHEN c.max_length = -1 THEN N'max' ELSE CAST(c.max_length AS sysname) END + N')'
            WHEN t.name IN (N'decimal', N'numeric') THEN QUOTENAME(t.name) + N'(' + CAST(c.precision AS sysname) + N', ' + CAST(c.scale AS sysname) + N')'
            ELSE QUOTENAME(t.name)
        END
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE object_id = @objId
 
    --Get list of Primary Key Fields and store them in @pkFields table variable for construction of CRUD procedures
    INSERT INTO @pkFields(
        name,
        fieldType
    )
    SELECT
        c.name,
        CASE
            WHEN t.name IN (N'char', N'nchar', N'varchar', N'nvarchar') THEN QUOTENAME(t.name) + N'(' + CASE WHEN c.max_length = -1 THEN N'max' ELSE CAST(c.max_length AS sysname) END + N')'
            WHEN t.name IN (N'decimal', N'numeric') THEN QUOTENAME(t.name) + N'(' + CAST(c.precision AS sysname) + N', ' + CAST(c.scale AS sysname) + N')'
            ELSE QUOTENAME(t.name)
        END
    FROM sys.key_constraints kc
    INNER JOIN sys.indexes i ON kc.parent_object_id = i.object_id AND kc.unique_index_id = i.index_id
    INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE kc.parent_object_id = @objId and kc.type = 'PK'
 
    --Check Whether there is primary Key the CRUD works only if there is primary key in the table
    IF (NOT EXISTS(SELECT 1 FROM @pkFields))
    BEGIN
        SET @msg = N'Table "' + @objectName + '" does not have a Primary Key. There must exists a primary key prior generating CRUD procedures.'
        RAISERROR (@msg, 11, 1)
    END
 
    --list of output columns for INSERT statement (ouptup of Identity and calculated fields)
    SELECT @insertOutputCols =
        STUFF(REPLACE((SELECT
                            N'        ' + @crlf + N'        ,inserted.' + QUOTENAME(c.name)
                        FROM @allFields c
                        WHERE isIdentity = 1 OR isCalculated = 1
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 19, N'         ')
 
    --list of output columns for UPDATE statement (Calculated fields only)
    SELECT @updateOutputCols =
        STUFF(REPLACE((SELECT
                            N'        ' + @crlf + N'        ,inserted.' + QUOTENAME(c.name)
                        FROM @allFields c
                        WHERE isCalculated = 1
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 19, N'         ')        
 
    --ist of all columns used in the SELECT Statement
    SELECT @allColumns =
        STUFF(REPLACE((SELECT
                            N'            ' + @crlf + N'            ,' + QUOTENAME(c.name)
                        FROM @allFields c
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 27, N'             ')
 
    --list of columns for UPDATE statement including the equal sign and variable (all columns except indentity and calculated ones)
    SELECT @updateColumns =
        STUFF(REPLACE((SELECT
                            N'        ' + @crlf + N'        ,' + QUOTENAME(c.name) + N' = @' + c.name
                        FROM @allFields c
                        WHERE isIdentity = 0 AND isCalculated = 0
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 19, N'         ')
 
    --list of columns for INSERT statement (all columns except identity and calculated ones)
    SELECT @insertColumns =
        STUFF(REPLACE((SELECT
                            N'        ' + @crlf + N'        ,' + QUOTENAME(c.name)
                        FROM @allFields c
                        WHERE isIdentity = 0 AND isCalculated = 0
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 19, N'         ')
 
    --condition for UPDATE and DELETE statement
    SET @updateDeleteCondition =
            STUFF(REPLACE((SELECT
                            N'        ' + @crlf + N'        AND' + @crlf + '        ' + QUOTENAME(c.name) + N' = @' + c.name
                        FROM @pkFields c
                        FOR XML PATH(N'')), @crlfXML, @crlf), 1, 23, N'')
 
    --IF condition for SELECT statement if all params will be NULL to do not use condition to receive better plans
    SET @selectAllIfNullCondition =
                STUFF((SELECT
                            N' AND @' + c.name + N' IS NULL'
                        FROM @pkFields c
                        FOR XML PATH(N'')), 1, 5, N'')
 
    --Select condition (for SELECT ONE)
    SET @selectCondition =
        STUFF(REPLACE((SELECT
                            N'            ' + @crlf + N'            AND' + @crlf + N'            (@' + c.name + N' IS NULL OR ' + QUOTENAME(c.name) + N' = @' + c.name + N')'
                        FROM @pkFields c
                        FOR XML PATH(N'')), @crlfXML, @crlf), 1, 31, N'')
 
    --parameters list for SELECT CRUD procedure
    SELECT @selectParams =
        STUFF(REPLACE((SELECT
                            N',    ' + @crlf + N'    @' + c.name + N' ' + c.fieldType + N' = NULL'
                        FROM @pkFields c
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 11, N'    ')
 
    --parameters list for DELETE CRUD procedure
    SELECT @deleteParams =
        STUFF(REPLACE((SELECT
                            N',    ' + @crlf + N'    @' + c.name + N' ' + c.fieldType
                        FROM @pkFields c
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 11, N'    ')
 
    --parameters list for UPDATE CRUD procedure
    SELECT @updateParams =
        STUFF(REPLACE((SELECT
                            N',    ' + @crlf + N'    @' + c.name + N' ' + c.fieldType
                        FROM @allFields c
                        LEFT JOIN @pkFields pk ON c.name = pk.name
                        WHERE (c.isIdentity = 0 AND c.isCalculated = 0) OR pk.name IS NOT NULL
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 11, N'    ')
 
    --parameters list for INSERT CRUD procedure
    SELECT @insertParams =
        STUFF(REPLACE((SELECT
                            N',    ' + @crlf + N'    @' + c.name + N' ' + c.fieldType
                        FROM @allFields c
                        LEFT JOIN @pkFields pk ON c.name = pk.name
                        WHERE c.isIdentity = 0 AND c.isCalculated = 0
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 11, N'    ')
 
    --parameter names list for INSERT command in the INSERT CRUD procedure
    SELECT @insertParamNames =
        STUFF(REPLACE((SELECT
                            N'        ' + @crlf + N'        ,@' + c.name
                        FROM @allFields c
                        LEFT JOIN @pkFields pk ON c.name = pk.name
                        WHERE c.isIdentity = 0 AND c.isCalculated = 0
                        FOR XML PATH(N'')
                        ),
                @crlfXML, @crlf),
            1, 19, N'         ')
 
--USE DB
SET @sql = N'USE ' + QUOTENAME(@dbName) + N'
'
INSERT INTO @scripts(script) VALUES(@sql)
 
--SELECT PROCEDURE
IF (@dropExistingProcedures = 1)
BEGIN
SET @sql = N'--Drop existing SELECT CRUD Procedure
IF (EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(''' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixSelect + N']'') AND type = ''P''))
    DROP PROCEDURE ' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixSelect +N']
'
INSERT INTO @scripts(script) VALUES(@sql)
END
 
SET @sql = N'-- =======================================================
-- Author:      ' + QUOTENAME(SUSER_SNAME()) + N'
-- Create date: ' + CONVERT(nvarchar(10), GETDATE(), 111) + N'
-- Description: Selects records from table ' + QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName) + N'
-- =======================================================
CREATE PROCEDURE ' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixSelect + N']
' + @selectParams + N'
AS
BEGIN
    SET NOCOUNT ON;
 
    IF (' + @selectAllIfNullCondition + N')
    BEGIN
        SELECT
' + @allColumns + N'
        FROM ' + QUOTENAME(@schemaName) + N'.' + QUOTENAME(@tableName) + N'
    END
    ELSE
    BEGIN
        SELECT
' + @allColumns + N'
        FROM ' + QUOTENAME(@schemaName) + N'.' + QUOTENAME(@tableName) + N'
        WHERE
' + @selectCondition + N'
    END
END
';
INSERT INTO @scripts(script) VALUES(@sql)
 
--UPDATE PROCEDURE
IF (@dropExistingProcedures = 1)
BEGIN
SET @sql = N'--Drop existing UPDATE CRUD Procedure
IF (EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(''' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixUpdate + N']'') AND type = ''P''))
    DROP PROCEDURE ' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixUpdate + N']
'
INSERT INTO @scripts(script) VALUES(@sql)
END
 
SET @sql = N'-- =======================================================
-- Author:      ' + QUOTENAME(SUSER_SNAME()) + N'
-- Create date: ' + CONVERT(nvarchar(10), GETDATE(), 111) + N'
-- Description: Updates record in table ' + QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName) + N'
-- =======================================================
CREATE PROCEDURE ' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixUpdate + N']
' + @updateParams + N'
AS
BEGIN
    SET NOCOUNT ON;
 
    UPDATE ' + QUOTENAME(@schemaName) + N'.' + QUOTENAME(@tableName) + N' SET
' + @updateColumns + CASE WHEN @outputIndentityCalcFields = 1 AND @updateOutputCols <> N'' AND @updateOutputCols IS NOT NULL THEN N'
    OUTPUT
' + @updateOutputCols
    ELSE N'' END + N'
    WHERE
' + @updateDeleteCondition + N'
END
';
INSERT INTO @scripts(script) VALUES(@sql)
 
--DELETE PROCEDURE
IF (@dropExistingProcedures = 1)
BEGIN
SET @sql = N'--Drop existing DELETE CRUD Procedure
IF (EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(''' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixDelete + N']'') AND type = ''P''))
    DROP PROCEDURE ' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName +  @suffixDelete + N']
'
INSERT INTO @scripts(script) VALUES(@sql)
END
 
SET @sql = N'-- =======================================================
-- Author:      ' + QUOTENAME(SUSER_SNAME()) + N'
-- Create date: ' + CONVERT(nvarchar(10), GETDATE(), 111) + N'
-- Description: Deletes recors from table ' + QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName) + N'
-- =======================================================
CREATE PROCEDURE ' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixDelete + N']
' + @deleteParams + N'
AS
BEGIN
    SET NOCOUNT ON;
 
    DELETE FROM ' + QUOTENAME(@schemaName) + N'.' + QUOTENAME(@tableName) + N'
    WHERE
' + @updateDeleteCondition + N'
END
';
INSERT INTO @scripts(script) VALUES(@sql)
 
--INSERT PROCEDURE
IF (@dropExistingProcedures = 1)
BEGIN
SET @sql = N'--Drop existing INSERT CRUD Procedure
IF (EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(''' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixInsert + N']'') AND type = ''P''))
    DROP PROCEDURE ' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixInsert + N']
'
INSERT INTO @scripts(script) VALUES(@sql)
END
 
SET @sql = N'-- =======================================================
-- Author:      ' + QUOTENAME(SUSER_SNAME()) + N'
-- Create date: ' + CONVERT(nvarchar(10), GETDATE(), 111) + N'
-- Description: Deletes recors from table ' + QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName) + N'
-- =======================================================
CREATE PROCEDURE ' + QUOTENAME(@schemaName) + N'.[' + @procPrefix + @tableName + @suffixInsert + N']
' + @insertParams + N'
AS
BEGIN
    SET NOCOUNT ON;
 
    INSERT INTO ' + QUOTENAME(@schemaName) + N'.' + QUOTENAME(@tableName) + N' (
' + @insertColumns + N'
    )' + CASE WHEN @outputIndentityCalcFields = 1 AND @insertOutputCols <> N'' AND @insertOutputCols IS NOT NULL THEN N'
    OUTPUT
' + @insertOutputCols
    ELSE N'' END + N'
    SELECT
' + @insertParamNames + N'
END
';
INSERT INTO @scripts(script) VALUES(@sql)
 
DECLARE cr CURSOR FAST_FORWARD FOR
SELECT script FROM @scripts ORDER BY id
 
--if EXECUTION mode contains 2 we should output the code using SELECT
--Script generate using the SELECT can be saved by right lick on the result and
--select Save Result AS and storing it as CSV
IF ((@executionMode & 2) = 2 OR (@isTooLongForPrint = 1 AND (@executionMode & 1) = 1))
BEGIN
    SELECT script + N'GO' FROM @scripts
END
 
SET @isTooLongForPrint = ISNULL((SELECT 1 FROM @scripts WHERE LEN(script) > 4000), 0)
 
--if Execution mode contains 1 we should PRINT the statements
IF ((@executionMode & 1) = 1 AND @isTooLongForPrint = 0)
BEGIN
    OPEN cr
    FETCH NEXT FROM cr INTO @sql
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        PRINT @sql
        PRINT 'GO'
        FETCH NEXT FROM cr INTO @sql
    END
    CLOSE cr
END
 
--Execute the statement if it should be executed
IF (( @executionMode & 4 ) = 4 OR ( @executionMode & 8 ) = 8 )
BEGIN
 
    OPEN cr
 
    BEGIN TRY
        BEGIN TRANSACTION
 
        FETCH NEXT FROM cr INTO @sql
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
            EXEC (@sql)
            FETCH NEXT FROM cr INTO @sql
        END
 
        IF ((@executionMode & 4) = 4)
        BEGIN
            IF (@@TRANCOUNT > 0)
                COMMIT TRANSACTION
        END
        ELSE
        BEGIN
            IF (@@TRANCOUNT > 0)
                ROLLBACK TRANSACTION
        END
    END TRY
    BEGIN CATCH
        IF (@@TRANCOUNT > 0)
            ROLLBACK TRANSACTION
    END CATCH
END
 
--if cursor is open, close it
IF (cursor_status('global', 'cr') = 1)
    CLOSE cr
 
DEALLOCATE cr
END
GO
 
EXECUTE sp_ms_marksystemobject 'dbo.sp_makeCRUD'
Go