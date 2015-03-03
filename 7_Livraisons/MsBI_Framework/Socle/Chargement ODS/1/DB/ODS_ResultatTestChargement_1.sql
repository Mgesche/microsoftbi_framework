IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'Adm'
				  AND TABLE_NAME = 'ODS_ResultatTestChargement')
BEGIN

CREATE TABLE [Adm].[ODS_ResultatTestChargement](
	[idResultatTest] [int] IDENTITY(1,1) NOT NULL,
	[strResultatTest] [varchar](100) NULL
) ON [PRIMARY]

END