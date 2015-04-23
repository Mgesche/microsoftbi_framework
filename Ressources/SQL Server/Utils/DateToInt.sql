CREATE FUNCTION [Utils].[DateToInt](
	@ladate date
) RETURNS int
as
  /* =============================================================================== */
  /* Cette fonction convertit une date en entier au format YYYYMMDD                  */
  /*                                                                                 */
  /* @ladate : Date a convertir                                                      */
  /*																				 */
  /* =============================================================================== */
  
/*

SELECT [Utils].[DateToInt] (GETDATE());

*/
BEGIN

RETURN CAST(CONVERT(varchar, @ladate, 112) as int)

END

GO
