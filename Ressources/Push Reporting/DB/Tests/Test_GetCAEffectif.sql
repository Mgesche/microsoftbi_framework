IF COALESCE([BotanicDW_MEC].[push_reporting].[GetCAEffectif] (20150401, 'Enseigne', 1) <> 400
BEGIN
	RAISERROR(N'Erreur sur GetCAEffectif concernant les enseignes', 15, 0)
END

IF COALESCE([BotanicDW_MEC].[push_reporting].[GetCAEffectif] (20150401, 'Region', 'B_SIAL'), 1) <> 100
BEGIN
	RAISERROR(N'Erreur sur GetCAEffectif concernant les regions', 15, 0)
END

IF COALESCE([BotanicDW_MEC].[push_reporting].[GetCAEffectif] (20150401, 'Magasin', '415'), 1) <> 45
BEGIN
	RAISERROR(N'Erreur sur GetCAEffectif concernant les magasins', 15, 0)
END