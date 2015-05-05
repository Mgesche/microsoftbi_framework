CREATE TABLE [push_reporting].[groupe](
	[idGroupe] [int] IDENTITY(1,1) NOT NULL,
	[strGroupe] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[param](
	[idParam] [int] IDENTITY(1,1) NOT NULL,
	[strParam] [varchar](500) NULL,
	[idTypeParam] [int] NULL,
	[StrDescription] [varchar](100) NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[planification](
	[idPlanification] [int] IDENTITY(1,1) NOT NULL,
	[idRapport] [int] NULL,
	[idSousGroupe] [int] NULL,
	[idParam] [int] NULL,
	[titreMail] [varchar](200) NULL,
	[dt_creation] [datetime] NULL,
	[dt_lancement] [datetime] NULL,
	[dt_errorExport] [datetime] NULL,
	[strErrorExport] [varchar](500) NULL,
	[nbErrorExport] [int] NULL,
	[dt_errorMail] [datetime] NULL,
	[strErrorMail] [varchar](500) NULL,
	[nbErrorMail] [int] NULL,
	[typeExportMail] [varchar](50) NULL,
	[dt_cloture] [datetime] NULL,
	[strPlanif] [varchar](50) NULL,
	[strPackageTraitement] [varchar](100) NULL,
	[isReadyDonnee] INT
) ON [PRIMARY]

CREATE TABLE [push_reporting].[planification_histo](
	[idPlanification] [int] NULL,
	[idRapport] [int] NULL,
	[idSousGroupe] [int] NULL,
	[idParam] [int] NULL,
	[dt_creation] [datetime] NULL,
	[dt_lancement] [datetime] NULL,
	[dt_errorExport] [datetime] NULL,
	[strErrorExport] [varchar](500) NULL,
	[nbErrorExport] [int] NULL,
	[dt_errorMail] [datetime] NULL,
	[strErrorMail] [varchar](500) NULL,
	[nbErrorMail] [int] NULL,
	[typeExportMail] [varchar](50) NULL,
	[dt_cloture] [datetime] NULL,
	[strPlanif] [varchar](50) NULL,
	[strPackageTraitement] [varchar](100) NULL,
	[isReadyDonnee] INT
) ON [PRIMARY]

CREATE TABLE [push_reporting].[planification_update](
	[idPlanification] [int] NULL,
	[dt_lancement] [datetime] NULL,
	[dt_cloture] [datetime] NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[rapport](
	[idRapport] [int] IDENTITY(1,1) NOT NULL,
	[strURLRapport] [varchar](200) NULL,
	[strNomRapport] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[rel_groupe_user](
	[idGroupe] [int] NULL,
	[idUser] [int] NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[rel_sous_groupe_param](
	[idSousGroupe] [int] NULL,
	[idParam] [int] NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[rel_sous_groupe_rapport](
	[idSousGroupe] [int] NULL,
	[idRapport] [int] NULL,
	[typeExportMail] [varchar](50) NULL,
	[titreMail] [varchar](200) NULL,
	[strPlanif] [varchar](50) NULL,
	[strGroupement] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[sous_groupe](
	[idSousGroupe] [int] IDENTITY(1,1) NOT NULL,
	[idGroupe] [int] NULL,
	[strSousGroupe] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[trad_libelle](
	[strLibelle] [varchar](500) NULL,
	[strTraduction] [varchar](500) NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[user](
	[idUser] [int] IDENTITY(1,1) NOT NULL,
	[strMail] [varchar](100) NULL,
	[enabled] [int] NULL
) ON [PRIMARY]

CREATE TABLE [push_reporting].[variables](
	[strVariable] [varchar](100) NULL,
	[strValeur] [varchar](100) NULL
) ON [PRIMARY]