CREATE PROCEDURE [push_reporting].[RAZPushReporting]
AS
  /* =============================================================================== */
  /* Cette procédure remet a zero le paramétrahe du push reporting                   */
  /*                                                                                 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

DECLARE	@return_value int

EXEC	@return_value = [push_reporting].[RAZPushReporting]

SELECT	'Return Value' = @return_value

GO
*/

DELETE FROM push_reporting.[user];
DELETE FROM push_reporting.groupe;
DELETE FROM push_reporting.sous_groupe;
DELETE FROM push_reporting.param;
DELETE FROM push_reporting.rapport;
DELETE FROM push_reporting.rel_groupe_user;
DELETE FROM push_reporting.rel_sous_groupe_rapport;
DELETE FROM push_reporting.rel_sous_groupe_param;

RETURN 0;

GO