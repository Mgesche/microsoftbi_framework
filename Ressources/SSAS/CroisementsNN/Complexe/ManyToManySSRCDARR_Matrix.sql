/* Modif DDE */

/* Ajout de la cl� a la table de fait */
ALTER TABLE dbo.F_PMSI_SSR_RHA
Add [ID_CDARR] [int] NULL;

UPDATE dbo.F_PMSI_SSR_RHA
SET [ID_CDARR] = -1;

CREATE NONCLUSTERED INDEX WRK_F_PMSI_SSR_RHA_ID_CDARR
ON DWH.dbo.F_PMSI_SSR_RHA (ID_CDARR)
INCLUDE (ID_ANNEE, IDT_FINESS, IDT_RHA);

/* Creation de la table intermediaire */
CREATE TABLE [dbo].[F_PMSI_SSR_RHA_CDARR_WRK](
	[MATRIX_KEY] [int] NOT NULL,
	[DIMENTION_KEY] [nvarchar](4) NOT NULL
);

/* Cr�ation de la matrice : Technique */
CREATE TABLE [dbo].[F_PMSI_SSR_RHA_CDARR_MTX_WRK](
	ID_ANNEE INT NULL,
	IDT_FINESS NUMERIC(9,0) NULL,
	IDT_RHA NUMERIC(10,0) NULL,
	[LINEAR_MATRIX_STRING] [varchar](4000) NOT NULL
);

/* Cr�ation de la matrice */
CREATE TABLE [dbo].[F_PMSI_SSR_RHA_CDARR_MTX](
	[MATRIX_KEY] [int] NOT NULL identity(1,1),
	[LINEAR_MATRIX_STRING] [varchar](4000) NOT NULL
CONSTRAINT [PK_F_PMSI_SSR_RHA_CDARR_MTX] PRIMARY KEY CLUSTERED 
([MATRIX_KEY] ASC));

/* Cr�ation du lookup SSIS */
CREATE TABLE [dbo].[F_PMSI_SSR_R�HA_CDARR_MTX_Lookup](
	[MATRIX_KEY] [int] NULL,
	ID_ANNEE INT NULL,
	IDT_FINESS NUMERIC(9,0) NULL,
	IDT_RHA NUMERIC(10,0) NULL
);

CREATE TABLE [dbo].[F_PMSI_SSR_RHA_CDARR_INT](
	[ID_CDARR_KEY] [int] IDENTITY(1,1) PRIMARY KEY,
	[ID_CDARR] [nvarchar](4) NULL
) ON [PRIMARY]