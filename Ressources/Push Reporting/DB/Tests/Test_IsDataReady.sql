/* Preparation des données de tests */
EXEC	[Test].[CreeTableTest]
		@strTableOrigine = 'FactTicketLocalisation',
		@strSchemaOrigine = 'suivi_tickets',
		@strSchemaTest = 'suivi_tickets',
		@overwrite = 1;

EXEC	[Test].[CreeTableTest]
		@strTableOrigine = 'FactTicketLocalisationBloque',
		@strSchemaOrigine = 'suivi_tickets',
		@strSchemaTest = 'suivi_tickets',
		@overwrite = 1;

/* Pas Botanic France */
INSERT INTO suivi_tickets.Test_FactTicketLocalisation
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 433, 50

/* Botanic France, Alpes */
INSERT INTO suivi_tickets.Test_FactTicketLocalisation
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 415, 45
INSERT INTO suivi_tickets.Test_FactTicketLocalisation
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 416, 55

/* Botanic France, Littoral */
INSERT INTO suivi_tickets.Test_FactTicketLocalisation
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 417, 145
INSERT INTO suivi_tickets.Test_FactTicketLocalisation
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 418, 155

/* Pas Botanic France */
INSERT INTO suivi_tickets.Test_FactTicketLocalisationBloque
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 433, 0

/* Botanic France, Alpes */
INSERT INTO suivi_tickets.Test_FactTicketLocalisationBloque
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 415, 0
INSERT INTO suivi_tickets.Test_FactTicketLocalisationBloque
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 416, 40

/* Botanic France, Littoral */
INSERT INTO suivi_tickets.Test_FactTicketLocalisationBloque
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 417, 0
INSERT INTO suivi_tickets.Test_FactTicketLocalisationBloque
(DateTicket_int, DateRemontee_int, Societe_id, Somme_CATTC)
SELECT 20150401, 20150401, 418, 155

EXEC	[Test].[BasculeTest]
		@strSchemaOrigine = 'suivi_tickets',
		@strTableOrigine = 'FactTicketLocalisation',
		@iEtatTestNew = 1

EXEC	[Test].[BasculeTest]
		@strSchemaOrigine = 'suivi_tickets',
		@strTableOrigine = 'FactTicketLocalisationBloque',
		@iEtatTestNew = 1

/* Enseigne 1 : 400 / 595 = 67,2% */
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady] (20150401, 67, 'Enseigne', 1);
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady] (20150401, 68, 'Enseigne', 1);

/* ALP : 100 / 140 = 71,4% */
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady] (20150401, 71, 'Region', 'B_SIAL');
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady] (20150401, 72, 'Region', 'B_SIAL');

/* 415 : 45 / 45 = 100% */
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady] (20150401, 100, 'Magasin', '415');

/* 418 : 145 / 290 = 50% */
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady] (20150401, 50, 'Magasin', '418');
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady] (20150401, 51, 'Magasin', '418');