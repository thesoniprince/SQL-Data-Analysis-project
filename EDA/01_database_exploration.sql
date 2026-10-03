/*
DATABASE EXPLORATION

Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.
*/

--EXPLORING TABLES AND THEIR SCHEMAS
SELECT
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

--INSPECTNG COLUMNS 
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH,
    TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS;

--CHECKING CONTRAINTS OF ALL TABLES: PRIMARY KEY, FORIGN KEY.
SELECT
    *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS

-- INSIGHTS
/*
THERE ARE TOTAL 3 TABLES IN THIS DATABASE 'DataWarehouseAnalysis', and the schema is gold
Every column in eachtable is nullable and every varchar daa type has fixed 50 char lenght for each table
None of the column has a constraints
*/