/*
FN = Scalar Function
IF = Inlined Table Function
TF = Table Function
*/
IF object_id(N'WebServices.GetCA', N'TF') IS NOT NULL
    DROP FUNCTION WebServices.GetCA
GO

CREATE FUNCTION [WebServices].[GetCA](
	@iDate int = 0
) RETURNS @Exports TABLE (StrDate varchar(50), CA int)
as
  /* =============================================================================== */
  /* Recupere le CA sur les 5 derniers jours                                         */
  /*                                                                                 */
  /* @iDate : Date de remontee a teter (par defaut, date de la veille)               */
  /*																			                                        	 */
  /* =============================================================================== */
  
/*
USE [BotanicDW_MEC]
GO

SELECT [BotanicDW_MEC].[WebServices].[GetCA] (0);

GO
*/
BEGIN
  
DECLARE @dtDate datetime

/* Valeur par defaut de la date */
IF @iDate = 0
BEGIN
  SET @iDate = dbo.DateToInt(GETDATE()-1);
END

SET @dtDate = dbo.IntToDate(@iDate);

INSERT INTO @Exports
SELECT CONVERT(varchar(10), dbo.IntToDate(DateRemontee_int), 20), SUM(Somme_CATTC) 
FROM [BotanicDW_MEC].[suivi_tickets].[FactTicketLocalisation]
/* TODO : bascule dd */
WHERE dbo.IntToDate(DateRemontee_int) BETWEEN DATEADD(yy, -5, @dtDate) AND @dtDate
GROUP BY CONVERT(varchar(10), dbo.IntToDate(DateRemontee_int), 20)

RETURN
END

GO