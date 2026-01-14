/*
==============================================================================
Script Name : 01_database_exploration.sql
Purpose     : Explore database metadata and available objects
Layer       : Analytics / EDA
==============================================================================
*/

-- Explore all tables in the database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns in the database
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS;
