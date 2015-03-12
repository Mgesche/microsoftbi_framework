SELECT definition, uses_ansi_nulls, uses_quoted_identifier, is_schema_bound
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('CA.Customer_Customer_Level'); 