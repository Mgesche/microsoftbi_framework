USE [master]
GO

/****** Object:  StoredProcedure [dbo].[dba_update_statistics]    Script Date: 01/23/2014 10:39:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[dba_update_statistics]
/*Declare Parameters*/

	  @Database				varchar(100)	= 'master'
		/*Determine on which database you want update statistics*/
	, @BigTableThreshold	bigint=10000000
		/*Determine The Thresold to consider a table as a big table (in number of lines). Small Tables will be fullscanned whereas bigtable will be sampled*/
	, @ChangeRatio			smallint		= 20
		/*Ratio for big tables to determine if update statistics need to be done (=rowmodctr/rowcount*100) */
	, @SampleRatio			smallint		= 33
		/*Ratio for big tables sample size during update statistics*/
	, @timeLimit			int				= 300		
	   /* Timeout in minute */
    , @debugMode            bit             = 0
        /* display some useful comments to help determine if/where issues occur */
    , @TablePrefixToExclude1 varchar(10)     = NULL
        /* prefix of table to exclude for updatestats */
    , @TablePrefixToExclude2 varchar(10)     = NULL
        /* prefix of table to exclude for updatestats */
    , @TableSuffixToExclude varchar(10)     = NULL
        /* suffix of table to exclude for updatestats */
    , @PrintOnly			bit				= 0
		/* boolean to print only update statistics order without running them (1 printonly; 0 print and run)*/

AS
Set NoCount On;
Set XACT_Abort On;
Set Quoted_Identifier On;




Begin

Begin Try



-------------------
--Begin script
-------------------


DECLARE @StartTime		DATETIME
DECLARE @StartTimeUpd	DATETIME
DECLARE @Duration		VARCHAR(15)
DECLARE @debugMessage   NVARCHAR(4000)
DECLARE @NumTables		INT
DECLARE @cmdtable		NVARCHAR(1000)
DECLARE @TableNumber	INT
DECLARE @SchemaName		NVARCHAR(128)
DECLARE @tableName		NVARCHAR(128)
DECLARE @RowsInTable	BIGINT
DECLARE @RowModCtr		BIGINT
DECLARE @Statement		NVARCHAR(300)
DECLARE @Status			NVARCHAR(300)


DECLARE @endDateTime    DATETIME
DECLARE @jobEndDateTime	DATETIME


    /* Initialize our variables */
        Select 
         @StartTime = GetDate(), 
         @endDateTime = DateAdd(minute, @timeLimit, GetDate());

IF OBJECT_ID('master..dba_TablesToUpdateStats') IS NOT NULL
BEGIN
DROP TABLE master..dba_TablesToUpdateStats
END


set @cmdtable =
N'
SELECT
'''+ @Database + ''' As DatabaseName
,s.[Name] AS SchemaName
,t.[name] AS TableName
,SUM(p.rows) AS RowsInTable
,sum(cast(i.rowmodctr as bigint)) as RowModCtr
INTO dba_TablesToUpdateStats
FROM '+ @Database + '.sys.schemas s
INNER JOIN '+ @Database + '.sys.tables t
ON  s.schema_id = t.schema_id
LEFT JOIN '+ @Database + '.sys.partitions p
ON  t.object_id = p.object_id
LEFT JOIN '+ @Database + '.sys.allocation_units a
ON  p.partition_id = a.container_id
LEFT JOIN '+ @Database + '.sys.sysindexes i ON t.object_id=i.id and i.indid<=1
WHERE
p.index_id IN ( 0, 1 ) /* 0 heap table , 1 table with clustered index*/
AND p.rows IS NOT NULL
AND a.type in (1,3)  /*-- row-data only , not LOB */'

IF (@TablePrefixToExclude1 IS NOT NULL)
BEGIN 
 Set @cmdtable = @cmdtable +  
 N' 
 AND t.[name] not like ''' + @TablePrefixToExclude1 + '%'''
END

IF (@TablePrefixToExclude2 IS NOT NULL)
BEGIN 
 Set @cmdtable = @cmdtable +  
 N' 
 AND t.[name] not like ''' + @TablePrefixToExclude2 + '%'''
END

IF (@TableSuffixToExclude IS NOT NULL)
BEGIN
 Set @cmdtable = @cmdtable +  
 N' 
 AND t.[name] not like ''%' + @TableSuffixToExclude + ''''
END

set @cmdtable = @cmdtable +
N' 
GROUP BY
s.[Name]
,t.[name]
HAVING sum(cast(i.rowmodctr as bigint)) >= 0
'


print @cmdtable

exec sp_executesql @cmdtable
SELECT @NumTables = @@ROWCOUNT

DECLARE updatestats CURSOR FOR
SELECT
ROW_NUMBER() OVER (ORDER BY ttus.RowsInTable),
ttus.SchemaName,
ttus.TableName,
ttus.RowsInTable,
ttus.RowModCtr
FROM
dba_TablesToUpdateStats AS ttus
WHERE
ttus.DatabaseName=@Database
ORDER BY
ttus.RowsInTable ASC;



OPEN updatestats



	FETCH NEXT FROM updatestats INTO @TableNumber, @SchemaName, @tableName, @RowsInTable, @RowModCtr
	WHILE ( @@FETCH_STATUS = 0 )
		BEGIN
        
        -- Test TimeOut
        If IsNull(@endDateTime, GetDate()) < GetDate()
        Begin
            set @debugMessage = 'Time limit ('+ cast(@timeLimit as varchar(5)) + ' minutes) has been exceeded!'
            RaisError(@debugMessage, 11, 42) With NoWait;
        End;
        
		SET @Statement = 'UPDATE STATISTICS ['+ @database +'].[' + @SchemaName + '].['+ @tableName + ']'
		
		IF (@RowsInTable<@BigTableThreshold) 
		  BEGIN
		    -- FullScan pour les petites tables
		    SET @Statement = @Statement + ' WITH FULLSCAN;'
		  END
		ELSE
		  BEGIN
		    IF (@RowModCtr/@RowsInTable)*100 >= @ChangeRatio 
		      BEGIN
		        SET @Statement = @Statement + ' WITH SAMPLE ' + cast(@SampleRatio as varchar(10)) + ' PERCENT;'
		      END
		    ELSE
		      BEGIN
				SET @Statement = ''  
		      END
		  END
		  
		  
		  IF (@Statement<>'')
		  BEGIN

			/*SET @Status = 'Table ' + cast(@TableNumber as varchar(10)) + ' of ' + cast(@NumTables as varchar(10))
			+ ': Running ''' + @Statement + ''' (' + @RowsInTable + ' rows)'
			RAISERROR (@Status, 0, 1) WITH NOWAIT  --RAISERROR used to immediately output status
			*/

			SELECT @StartTimeUpd = GETDATE()

			print @Statement
			
			
			 IF @PrintOnly=0
			 BEGIN
			  EXEC sp_executesql @Statement
			 END
			
		
			


			SET @Duration = 
			right ('0' + convert(varchar(5),datediff(s,@StartTimeUpd,getdate())/3600),2) 
			+':'+ 
			right ('0' + convert(varchar(5),datediff(s,@StartTimeUpd,getdate())%3600/60),2) 
			+':'+ 
			right ('0' + convert(varchar(5),datediff(s,@StartTimeUpd,getdate())%60),2)

			SET @Status = @Status + ' in ' + @Duration 

			RAISERROR (@Status, 0, 1) WITH NOWAIT  --RAISERROR used to immediately output duration
		  END

		FETCH NEXT FROM updatestats INTO @TableNumber, @SchemaName, @tableName, @RowsInTable, @RowModCtr
	END

CLOSE updatestats
DEALLOCATE updatestats

--DROP TABLE DBA_TablesToUpdateStats

PRINT 'Total Elapsed Time for ' + cast(@NumTables as varchar(10)) + ' Tables : ' + CONVERT(VARCHAR(100), DATEDIFF(minute,
@StartTime,
GETDATE()))
+ ' minutes'

End Try

    Begin Catch

        Set @debugMessage = Error_Message() + ' (Line Number: ' + Cast(Error_Line() As varchar(10)) + ')';
        Print @debugMessage;
        CLOSE updatestats
		DEALLOCATE updatestats

    End Catch;
End





GO


