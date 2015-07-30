IF object_id(N'Webservices.GetDifferencesTables', N'P') IS NOT NULL
    DROP PROCEDURE Webservices.GetDifferencesTables;
GO

CREATE PROCEDURE [Webservices].[GetDifferencesTables]
AS
  /* =============================================================================== */
  /* Renvois les tables différentes entre la DEV et la PROD                          */
  /*                                                                                 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

EXEC [BotanicDW_MEC].[Webservices].[GetDifferencesTables];

GO
*/
BEGIN

  DECLARE @Query NVARCHAR(MAX)
  
  SET @Query = N'
  EXEC [BotanicDW_MEC].[Utils].[JSONify] ''
  SELECT ''''En trop'''' as Statut, DEV.TABLE_NAME as NomTable
  FROM BotanicDW_MEC.INFORMATION_SCHEMA.TABLES DEV
  LEFT JOIN (SELECT *
  FROM decsqlprod.BotanicDW_MEC.INFORMATION_SCHEMA.TABLES) PROD
    ON DEV.TABLE_CATALOG = PROD.TABLE_CATALOG
   AND DEV.TABLE_NAME = PROD.TABLE_NAME
   AND DEV.TABLE_SCHEMA = PROD.TABLE_SCHEMA
   AND DEV.TABLE_TYPE = PROD.TABLE_TYPE
  WHERE PROD.TABLE_CATALOG IS NULL
    AND DEV.TABLE_SCHEMA = ''''DSV''''
  UNION
  SELECT ''''Manquant'''' as Statut, PROD.TABLE_NAME as NomTable
  FROM BotanicDW_MEC.INFORMATION_SCHEMA.TABLES DEV
  RIGHT JOIN (SELECT *
  FROM decsqlprod.BotanicDW_MEC.INFORMATION_SCHEMA.TABLES) PROD
    ON DEV.TABLE_CATALOG = PROD.TABLE_CATALOG
   AND DEV.TABLE_NAME = PROD.TABLE_NAME
   AND DEV.TABLE_SCHEMA = PROD.TABLE_SCHEMA
   AND DEV.TABLE_TYPE = PROD.TABLE_TYPE
  WHERE DEV.TABLE_CATALOG IS NULL
    AND PROD.TABLE_SCHEMA = ''''DSV''''
  '', ''Statut,NomTable''';
  
  EXECUTE sp_executesql @Query
  
  RETURN 0

END

GO