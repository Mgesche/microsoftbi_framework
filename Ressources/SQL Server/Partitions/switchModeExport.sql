/* Exemple d'utilisation : 

Cas d'un export partitionné
EXECUTE [export_differentiel].[switchModeExport] 387, 'DSVTicketCRM', 'RIEN'

Cas dun export non partitionné
EXECUTE [export_differentiel].[switchModeExport] -1, 'Clients', 'RIEN'
*/

ALTER PROCEDURE [export_differentiel].[switchModeExport] (
	@idPartition	int,
	@Fact			varchar(50),
	@newMode		varchar(50)
)
AS
BEGIN

DECLARE @Query NVARCHAR(MAX)

/* Cas sans modifications */
IF @idPartition <> -2
BEGIN

/* Cas non partitionné */
IF @idPartition = -1
BEGIN

SET @Query = 
N' UPDATE export_differentiel.nopartition '
+' SET export_rapp = '''+@newMode+''' '
+' WHERE Fact = '''+@Fact+''' '

EXECUTE sp_executesql @Query

/* Cas partitionné */
END ELSE BEGIN

SET @Query = 
N' UPDATE dbo.partitions '
+' SET export_rapp = '''+@newMode+''' '
+' WHERE id = '+CAST(@idPartition AS VARCHAR)+' '

EXECUTE sp_executesql @Query

END
END

END