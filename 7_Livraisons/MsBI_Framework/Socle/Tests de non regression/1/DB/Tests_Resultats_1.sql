IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'Adm'
				  AND TABLE_NAME = 'Tests_Resultats')
BEGIN

CREATE TABLE [Adm].[Tests_Resultats](
	idResultat	int IDENTITY(1,1) NOT NULL,
	Domaine		varchar(50), 
	Colonne		varchar(50), 
	Ecart		varchar(50),
	DtResultat	datetime,
	isCurrent   int,
	ValeurCle1	varchar(255), 
	ValeurCle2	varchar(255),
	ValeurCle3	varchar(255),
	ValeurCle4	varchar(255)
) ON [PRIMARY]

END