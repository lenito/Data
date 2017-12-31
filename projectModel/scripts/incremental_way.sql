-- =========================================
-- ----- Queryes for dymanic package -------
-- =========================================

USE AdventureWorks_Stage
GO 

-- get stage table names
SELECT name
FROM sys.tables

-- enable and disable the Trace Flag 610
--DBCC TRACEON (610)
--DBCC TRACEOFF (610)s

-- verify load type of the package
SELECT COUNT(*) is_initial
FROM dbo.Person

-- get columns of stage table dbo.Person
DECLARE @columns VARCHAR(8000)

SELECT @columns = COALESCE(@columns + ', ' + '[' + c.name + ']' , '[' + c.name + ']')
FROM [AdventureWorks_Stage].[sys].[tables] t
JOIN [AdventureWorks_Stage].[sys].[schemas] s ON s.schema_id = t.schema_id
JOIN [AdventureWorks_Stage].[sys].[columns] c ON c.object_id = t.object_id
WHERE s.schema_id = 1 --AND t.name = '@table'

SELECT @columns AS [columns]

-- initial load
INSERT INTO Person 
SELECT *
FROM [AdventureWorks2014].[Person].[Person]

-- get max date of the column ModifiedDate
SELECT ISNULL(MAX(ModifiedDate),'19000101') AS ModifiedDate 
FROM [AdventureWorks_Stage].[dbo].[Person]

-- incremental load 
INSERT INTO Person 
SELECT *
FROM [AdventureWorks2014].[cdc].[Person_Person_CT] p 
WHERE p.ModifiedDate > (
	SELECT ISNULL(MAX(ModifiedDate),'19000101') AS ModifiedDate 
	FROM [AdventureWorks_Stage].[dbo].[Person]
	)

-- ========================================
-- ---------- Dynamic ELT test ------------
-- ========================================

USE AdventureWorks2014
GO

SELECT TOP 5 * 
FROM Person.Person
ORDER BY Person.BusinessEntityID DESC

-- insert yestarday
INSERT INTO [Person].[BusinessEntity]
           ([rowguid]
           ,[ModifiedDate])
     VALUES 
           ('0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50085','20160319'), 
		   ('0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50086','20160319'),
		   ('0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50087','20160319'),
		   ('0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50088','20160319'),
		   ('0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50089','20160319')
GO

--DELETE FROM Person.BusinessEntity
--WHERE rowguid IN (
--	'0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50085',
--	'0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50086',
--	'0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50087',
--	'0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50088',
--	'0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50089'
--)
--GO

--DBCC CHECKIDENT('Person.BusinessEntity', RESEED, 20782)

USE [AdventureWorks2014]
GO

-- insert yestarday
INSERT INTO [Person].[Person]
           ([BusinessEntityID]
           ,[PersonType]
           ,[NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[EmailPromotion]
           ,[AdditionalContactInfo]
           ,[Demographics]
           ,[rowguid]
           ,[ModifiedDate])
     VALUES
           (20783,'IN',0,NULL,'Usuário Teste 01','','01',NULL,1,NULL,NULL,
		   '0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50085','20160319'),
		   (20784,'IN',0,NULL,'Usuário Teste 02','','02',NULL,1,NULL,NULL,
		   '0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50086','20160319'),
		   (20785,'IN',0,NULL,'Usuário Teste 03','','03',NULL,1,NULL,NULL,
		   '0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50087','20160319'),
		   (20786,'IN',0,NULL,'Usuário Teste 04','','04',NULL,1,NULL,NULL,
		   '0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50088','20160319'),
		   (20787,'IN',0,NULL,'Usuário Teste 05','','05',NULL,1,NULL,NULL,
		   '0C7D8F81-D7B1-4CF0-9C0A-4CD8B6B50089','20160319')
GO

--DELETE FROM Person.Person
--WHERE BusinessEntityID IN (20783,20784,20785,20786,20787)
--GO

UPDATE Person.Person
SET Suffix = 'Sr.', 
	ModifiedDate = '20160320'
WHERE BusinessEntityID IN (2, 3, 4, 5)

-- ==================================================
-- ----- Add [__$modified_date] in cdc tables -------
-- ==================================================

USE AdventureWorks2014
GO

--SELECT 'ALTER TABLE [cdc].[' + t.name + '] ADD [__$modified_date] DATETIME NOT NULL DEFAULT (GETDATE())'
--FROM sys.tables t
--JOIN sys.schemas s ON s.schema_id = t.schema_id
--WHERE s.schema_id = 10
--	AND t.name NOT IN (
--		'change_tables',
--		'ddl_history',
--		'lsn_time_mapping',
--		'captured_columns',
--		'index_columns'
--		)

--ALTER TABLE [cdc].[Person_Person_CT] 
--ADD [__$modified_date] DATETIME NOT NULL DEFAULT (GETDATE())

SELECT * 
FROM [cdc].[Person_Person_CT] 