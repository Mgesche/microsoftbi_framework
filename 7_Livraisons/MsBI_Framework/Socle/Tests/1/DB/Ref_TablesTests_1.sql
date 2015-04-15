-- =========================================================================
-- Correspondances entre les tables et leurs tables de tests correspondantes
-- =========================================================================
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'Test'
				  AND TABLE_NAME = 'Ref_TablesTests')
BEGIN

CREATE TABLE [Test].[Ref_TablesTests](
	[idTablesTests] [int] IDENTITY(1,1) NOT NULL,
	[strSchemaOrigine] varchar(50),
	[strTableOrigine] varchar(50),
	[strSchemaTest] varchar(50),
	[strTableTest] varchar(50),
	[iEtatTest] int /* 0 : Donnée origine, 1 : Donnée Test */
) ON [PRIMARY]

END

/* TODO : Reflechir environnment plutot que test, avec table de correspondance sur laquelle on creerait des enregistrements quand on 
insere dans un nouvel environnment */