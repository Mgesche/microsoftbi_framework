IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'Adm'
				  AND TABLE_NAME = 'ODS_Origine')
BEGIN

CREATE TABLE [Adm].[ODS_Origine](
	[idOrigine] [int] IDENTITY(1,1) NOT NULL,
	[strDomaine] [varchar](50) NULL,
	[strFichier] [varchar](100) NULL
) ON [PRIMARY]

END
