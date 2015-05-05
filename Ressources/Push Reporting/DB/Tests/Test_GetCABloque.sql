IF COALESCE([BotanicDW_MEC].[push_reporting].[GetCABloque] (20150401, 'Enseigne', 1), -1) <> 195
BEGIN
	RAISERROR(N'Erreur sur GetCABloque concernant les enseignes', 15, 0)
END

IF COALESCE([BotanicDW_MEC].[push_reporting].[GetCABloque] (20150401, 'Region', 'B_SIAL'), 1) <> 40
BEGIN
	RAISERROR(N'Erreur sur GetCABloque concernant les regions', 15, 0)
END

IF COALESCE([BotanicDW_MEC].[push_reporting].[GetCABloque] (20150401, 'Magasin', '415'), 1) <> 0
BEGIN
	RAISERROR(N'Erreur sur GetCABloque concernant les magasins', 15, 0)
END