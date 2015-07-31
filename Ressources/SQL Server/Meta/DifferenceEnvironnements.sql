/* Mettre en prod : Présent en DEV et pas en Prod */
SELECT 'Mettre en prod' as Action, DEV.SPECIFIC_SCHEMA, DEV.SPECIFIC_NAME,
       DEV.LAST_ALTERED, DEV.ROUTINE_DEFINITION
FROM BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES DEV
LEFT JOIN DECSQLPROD.BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES PROD
  ON DEV.SPECIFIC_SCHEMA = PROD.SPECIFIC_SCHEMA
 AND DEV.SPECIFIC_NAME = PROD.SPECIFIC_NAME
WHERE PROD.SPECIFIC_NAME IS NULL
UNION
/* Mise a jour en prod : Présent en DEV et en Prod mais different et plus recent en DEV */
SELECT 'Mise a jour en prod' as Action, DEV.SPECIFIC_SCHEMA, DEV.SPECIFIC_NAME,
       DEV.LAST_ALTERED, DEV.ROUTINE_DEFINITION
FROM BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES DEV
JOIN DECSQLPROD.BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES PROD
  ON DEV.SPECIFIC_SCHEMA = PROD.SPECIFIC_SCHEMA
 AND DEV.SPECIFIC_NAME = PROD.SPECIFIC_NAME
LEFT JOIN DECSQLPROD.BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES PROD2
  ON DEV.SPECIFIC_SCHEMA = PROD2.SPECIFIC_SCHEMA
 AND DEV.SPECIFIC_NAME = PROD2.SPECIFIC_NAME
 AND DEV.ROUTINE_DEFINITION = PROD2.ROUTINE_DEFINITION
WHERE PROD2.SPECIFIC_NAME IS NULL
  AND DEV.LAST_ALTERED > PROD.LAST_ALTERED
UNION
/* Mise a jour en dev : Présent en DEV et en Prod mais different et plus recent en PROD */
SELECT 'Mise a jour en dev' as Action, PROD.SPECIFIC_SCHEMA, PROD.SPECIFIC_NAME,
       PROD.LAST_ALTERED, PROD.ROUTINE_DEFINITION
FROM BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES DEV
JOIN DECSQLPROD.BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES PROD
  ON DEV.SPECIFIC_SCHEMA = PROD.SPECIFIC_SCHEMA
 AND DEV.SPECIFIC_NAME = PROD.SPECIFIC_NAME
LEFT JOIN DECSQLPROD.BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES PROD2
  ON DEV.SPECIFIC_SCHEMA = PROD2.SPECIFIC_SCHEMA
 AND DEV.SPECIFIC_NAME = PROD2.SPECIFIC_NAME
 AND DEV.ROUTINE_DEFINITION = PROD2.ROUTINE_DEFINITION
WHERE PROD2.SPECIFIC_NAME IS NULL
  AND DEV.LAST_ALTERED <= PROD.LAST_ALTERED
UNION
/* Mettre en dev : Présent en PROD et pas en DEV */
SELECT 'Mettre en dev' as Action, PROD.SPECIFIC_SCHEMA, PROD.SPECIFIC_NAME,
       PROD.LAST_ALTERED, PROD.ROUTINE_DEFINITION
FROM DECSQLPROD.BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES PROD
LEFT JOIN BotanicDW_MEC.INFORMATION_SCHEMA.ROUTINES DEV
  ON DEV.SPECIFIC_SCHEMA = PROD.SPECIFIC_SCHEMA
 AND DEV.SPECIFIC_NAME = PROD.SPECIFIC_NAME
WHERE DEV.SPECIFIC_NAME IS NULL