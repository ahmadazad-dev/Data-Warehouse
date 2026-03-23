USE master;

IF EXISTS (SELECT 1 FROM sys.databases WHERE name='DataWarehouse')
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END
GO

-- Create Database Datawarehoue

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO
-- Create schema for each layer Bronze, Silver, and Gold
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO 
CREATE SCHEMA gold;
GO


