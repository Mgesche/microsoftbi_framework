IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'Adm'
				  AND TABLE_NAME = 'ODS_Type_Fichier')
BEGIN

CREATE TABLE [Adm].[ODS_Type_Fichier](
	[idTypeFichier] [int] IDENTITY(1,1) NOT NULL,
	[strTypeFichier] [varchar](50) NULL,
	[strDescription] [varchar](100) NULL,

) ON [PRIMARY]

INSERT INTO [Adm].[ODS_Type_Fichier] (strTypeFichier, strDescription)
SELECT 'TXT', 'Fichier TXT';

INSERT INTO [Adm].[ODS_Type_Fichier] (strTypeFichier, strDescription)
SELECT 'CSV', 'Fichier CSV';

END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'Adm'
				  AND TABLE_NAME = 'ODS_Fichier')
BEGIN

CREATE TABLE [Adm].[ODS_Fichier](
	[idFichier] [int] IDENTITY(1,1) NOT NULL,
	[idTypeFichier] [varchar](50) NULL,
	[strFichier] [varchar](50) NULL,
	[strDescription] [varchar](100) NULL,
	[strChemin] [varchar](255) NULL
) ON [PRIMARY]

END
