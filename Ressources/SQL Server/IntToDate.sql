CREATE FUNCTION [Utils].[IntToDate](
	@ladate int
) RETURNS date
as
  /* =============================================================================== */
  /* Cette fonction convertit un entier au format YYYYMMDD en date                   */
  /*                                                                                 */
  /* @ladate : Date au format Int a convertir                                        */
  /*																				 */
  /* =============================================================================== */
  
/*

SELECT [Utils].[IntToDate] (20150407);

*/
BEGIN

DECLARE @DtDate date
DECLARE @YearDate int
DECLARE @MonthDate int
DECLARE @DayDate int

SET @YearDate = @ladate/10000
SET @MonthDate = (@ladate/100)%100
SET @DayDate = @ladate%100

RETURN DATEADD(YY, @YearDate-1900, DATEADD(M, @MonthDate-1, DATEADD(D, @DayDate-1, 0)));

END

GO
