IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'Adm'
				  AND TABLE_NAME = 'ODS_Chargement')
BEGIN

CREATE TABLE [Adm].[ODS_Chargement](
	[idChargement] [int] IDENTITY(1,1) NOT NULL,
	[idOrigine] [int] NULL,
	[dtChargement] [datetime] NULL,
	[strFichierArchive] [varchar](100) NULL
) ON [PRIMARY]

END