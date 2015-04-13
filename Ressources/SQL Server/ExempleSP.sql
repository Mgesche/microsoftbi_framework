USE [maDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ExempleSP] (
	@Debug int = 0,
	@DateEffet int = 0
)
AS
  /* ===================================================================================== */
  /* Description de la SP															       */
  /*                                                                                       */
  /* @Debug : 1 pour PRINT les requetes et 0 pour EXEC                                     */
  /* @DateEffet : Date d'effet (Remplacement des GETDATE())								   */
  /*																		 		       */
  /* Erreurs : -1 : ...															           */
  /*																		 		       */
  /* ===================================================================================== */
  
/*

Exemple d'execution de la SP :

DECLARE	@Return varchar(100)

EXEC	@Return = [dbo].[ExempleSP]

SELECT	'Return Value' = @Return

GO
*/
BEGIN

/* Gestion date effet au format date */
DECLARE @Dt_DateEffet DATETIME

IF @DateEffet = 0
BEGIN
	SET @Dt_DateEffet = GETDATE()
END
ELSE
BEGIN
	SET @Dt_DateEffet = Utils.[IntToDate] (@DateEffet)
END

/* Creation de la requete a executer */
DECLARE @Query nvarchar(4000)

SET @Query = N'SELECT ...';

/* Gestion Debug */
IF @Debug = 0
BEGIN
	EXEC sp_executesql @Query;
END
ELSE
BEGIN
	PRINT @Query;
END

/* Code erreurs */
RETURN 0;

END

GO


