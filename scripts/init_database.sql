/*
Create a database called DataWarehouse if it does not exists
Create the Bronze, Silver and Gold schema in the database
*/

USE master;

IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
    BEGIN
        CREATE DATABASE  DataWarehouse
    END;

USE DataWarehouse;


CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;


