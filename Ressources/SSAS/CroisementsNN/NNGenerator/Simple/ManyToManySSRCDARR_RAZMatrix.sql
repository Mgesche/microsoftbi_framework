truncate table F_PMSI_SSR_RHA_CDARR_MTX;

truncate table F_PMSI_SSR_RHA_CDARR_WRK;

/* Ajout de la valeur par defaut */
INSERT INTO [dbo].[F_PMSI_SSR_RHA_CDARR_WRK]
SELECT -1, -1;

UPDATE dbo.F_PMSI_SSR_RHA
SET [ID_CDARR] = -1;
