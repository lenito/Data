-- =========================================
-- ------ Create Stage Enviromment ---------
-- =========================================

--USE master
--GO

--CREATE DATABASE AdventureWorks_Stage
--GO

--USE AdventureWorks_Stage
--GO

--CREATE TABLE [dbo].[Person](
--	[BusinessEntityID] INT NOT NULL,
--	[PersonType] NCHAR(2) NOT NULL,
--	[NameStyle] BIT NOT NULL CONSTRAINT [DF_Person_NameStyle]  DEFAULT ((0)),
--	[Title] NVARCHAR(8) NULL,
--	[FirstName] NVARCHAR (50) NOT NULL,
--	[MiddleName] NVARCHAR (50) NULL,
--	[LastName] NVARCHAR (50) NOT NULL,
--	[Suffix] NVARCHAR (10) NULL,
--	[EmailPromotion] INT NOT NULL CONSTRAINT [DF_Person_EmailPromotion]  DEFAULT ((0)),
--	[rowguid] UNIQUEIDENTIFIER ROWGUIDCOL  NOT NULL CONSTRAINT [DF_Person_rowguid]  DEFAULT (newid()),
--	[ModifiedDate] DATETIME NOT NULL CONSTRAINT [DF_Person_ModifiedDate]  DEFAULT (getdate()),
--	[ModifiedType] CHAR(1) NOT NULL

--) ON [PRIMARY]
--GO

