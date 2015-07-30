USE [BotanicDW_MEC]
GO

/****** Object:  UserDefinedFunction [dbo].[Jobs_SansDescription]    Script Date: 06/16/2015 10:03:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =======================================================
-- Lister les jobs actifs sans descriptions fonctionnelles
-- =======================================================
CREATE FUNCTION [dbo].[Jobs_SansDescription]()
RETURNS TABLE 
AS
RETURN 
(
	SELECT JOB.name as Nom, 'Aucune Description' AS Probleme
	FROM msdb.dbo.sysjobs JOB
	JOIN msdb.dbo.syscategories CAT
	  ON JOB.category_id = CAT.category_id
	WHERE JOB.enabled = '1'
	  AND JOB.description IN ('Pas de description disponible.', 'No description available.')
	  AND CAT.Name <> 'Report Server'
	UNION
	SELECT JOB.name as Nom, 'Description manquante' AS Probleme
	FROM msdb.dbo.sysjobs JOB
	JOIN msdb.dbo.syscategories CAT
	  ON JOB.category_id = CAT.category_id
	WHERE JOB.enabled = '1'
	  AND JOB.description NOT IN ('Pas de description disponible.', 'No description available.')
	  AND JOB.description NOT LIKE '%Description:%'
	  AND CAT.Name <> 'Report Server'
	UNION
	SELECT JOB.name as Nom, 'Procedure de reprise manquante' AS Probleme
	FROM msdb.dbo.sysjobs JOB
	JOIN msdb.dbo.syscategories CAT
	  ON JOB.category_id = CAT.category_id
	WHERE JOB.enabled = '1'
	  AND JOB.description NOT IN ('Pas de description disponible.', 'No description available.')
	  AND JOB.description NOT LIKE '%Procedure de reprise:%'
	  AND CAT.Name <> 'Report Server'
	UNION
	SELECT JOB.name as Nom, 'Impacts manquants' AS Probleme
	FROM msdb.dbo.sysjobs JOB
	JOIN msdb.dbo.syscategories CAT
	  ON JOB.category_id = CAT.category_id
	WHERE JOB.enabled = '1'
	  AND JOB.description NOT IN ('Pas de description disponible.', 'No description available.')
	  AND JOB.description NOT LIKE '%Impacts:%'
	  AND CAT.Name <> 'Report Server'
	UNION
	SELECT JOB.name as Nom, 'Alerte manquante' AS Probleme
	FROM msdb.dbo.sysjobs JOB
	JOIN msdb.dbo.syscategories CAT
	  ON JOB.category_id = CAT.category_id
	WHERE JOB.enabled = '1'
	  AND JOB.description NOT IN ('Pas de description disponible.', 'No description available.')
	  AND JOB.description NOT LIKE '%Alerte:%'
	  AND CAT.Name <> 'Report Server'
)

GO


