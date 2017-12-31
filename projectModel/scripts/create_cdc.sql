-- =========================================
-- ------- Enable CDC on Database ----------
-- =========================================

USE AdventureWorks2014
go

--checking CDC feature enabled
SELECT name,
	   database_id, 
	   is_cdc_enabled 
FROM sys.databases
WHERE name = 'AdventureWorks2014'      
GO

--enabling CDC on database
USE AdventureWorks2014
GO
EXEC sys.sp_cdc_enable_db
GO  

--checking tables with CDC enabled
SELECT t.[name], is_tracked_by_cdc 
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name = 'Person'
GO  

-- generate queryes for enabling CDC on tables
--SELECT 
--'EXEC sys.sp_cdc_enable_table
--@source_schema = N''' + s.name +  ''',
--@source_name = N''' + t.name + ''',
--@role_name = NULL,
--@supports_net_changes = 1'
--FROM sys.tables t
--JOIN sys.schemas s ON s.schema_id = t.schema_id
--WHERE s.name = 'Person' 
--		AND t.name = 'Person'

--enabling CDC on tables
EXEC sys.sp_cdc_enable_table
@source_schema = N'Person', -- schema
@source_name = N'Person', -- table
@captured_column_list = N'[BusinessEntityID],[PersonType],[NameStyle],[Title],[FirstName],[MiddleName],
						  [LastName],[Suffix],[EmailPromotion],[rowguid],[ModifiedDate]', -- columns
@role_name = NULL, -- role
@supports_net_changes = 1 -- it´s necessary have a clustered index or unique index in table

GO

-- ================================
-- ------- system tables ----------
-- ================================

--Check the columns with cdc on
SELECT *
FROM [cdc].[captured_columns]

--Check the tables with cdc on
SELECT *
FROM [cdc].[change_tables]

--Check in tables the historic of the DDL statements
SELECT *
FROM [cdc].[ddl_history]

--Check in tables the indexed columns
SELECT *
FROM [cdc].[index_columns]

--Mapping all transactions done in tables with cdc
SELECT *
FROM [cdc].[lsn_time_mapping]

/* table is used to track schema changes in articles 
published in transactional and snapshot publications. 
This table is stored in both publication and 
subscription databases. */ 
SELECT *
FROM [dbo].[systranschemas]

--cdc enabled table
SELECT [__$start_lsn] 
	   /* lsn in log before the DML statement */

      ,[__$end_lsn]
	   /* lsn in log after the DML statement */
	   	  
      ,[__$seqval] 
	   /* used to order the row changes within a transaction */

      ,[__$operation] 
	   /* Identifies the data manipulation language (DML) operation associated with the change. Can be one of the following:
			 1 = delete;
			 2 = insert;
			 3 = update (old values) Column data has row values before executing the update statement;
			 4 = update (new values) Column data has row values after executing the update statement. */

      ,[__$update_mask] 
	   /* The column _$update_mask shows, via a bitmap, which columns were updated in the 
		 DML operation that was specified by _$operation. If this was a DELETE or INSERT operation, 
		 all columns are updated and so the mask contains value which has all 1’s in it. 
		 This mask is contains value which is formed with Bit values. */
      
	  ,[BusinessEntityID]
      ,[PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,[EmailPromotion]
      ,[rowguid]
      ,[ModifiedDate]
FROM [cdc].[Person_Person_CT] 

-- =============================================
-- --------- Desable CDC on Database -----------
-- =============================================

--Disable CDC in database
--USE AdventureWorks2014
--GO

--EXEC sys.sp_cdc_disable_db
--GO

-- ===================================
-- changes in the CDC configuration --
-- ===================================

USE AdventureWorks2014
GO

/*	Case the change data capture is enabled in database 
	with transactional replication, the jobs of the replication are used */

-- Jobs
EXEC sys.sp_cdc_change_job @job_type = 'capture'
                        ,@maxtrans = 5000 -- number of transactions read between each cicle
                        ,@maxscans = 10 -- number of cycles between each polling interval 
                        ,@continuous = 1 -- enable the continuous execution of the work of the capture 
                        ,@pollinginterval = 1 -- Interval in seconds between each cycle of the log read

EXEC sys.sp_cdc_change_job @job_type = 'cleanup'
                        ,@retention = 10080 -- time in minutes of retention of the dates in cdc tables (default is 3 days)

SELECT *
FROM msdb.dbo.cdc_jobs

