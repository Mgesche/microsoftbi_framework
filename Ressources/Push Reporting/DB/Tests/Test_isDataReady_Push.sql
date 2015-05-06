/* Enseigne 1 : 400 / 595 = 67,2% */
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady_Push] (20150401, 67, '1', '', '');
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady_Push] (20150401, 68, '1', '', '');

/* ALP : 100 / 140 = 71,4% */
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady_Push] (20150401, 71, '', 'LIT Littoral', '');
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady_Push] (20150401, 72, '', 'LIT Littoral', '');

/* 415 : 45 / 45 = 100% */
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady_Push] (20150401, 100, '', '', '415');

/* 418 : 145 / 290 = 50% */
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady_Push] (20150401, 50, '', '', '418');
SELECT [BotanicDW_MEC].[push_reporting].[IsDataReady_Push] (20150401, 51, '', '', '418');