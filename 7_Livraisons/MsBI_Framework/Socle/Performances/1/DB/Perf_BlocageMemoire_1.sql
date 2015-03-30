IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_SCHEMA = 'Adm'
				  AND TABLE_NAME = 'Perf_BlocageMemoire')
BEGIN

CREATE TABLE [Adm].[Perf_BlocageMemoire](
	DtCreation			datetime,
	idTypeRequete		int,
	Nb_Requete_Attente	int, 
	Nb_Requete_Pourvue	int, 
	Memoire_Dispo		bigint,
	Memoire_Alloue		bigint,
	Memoire_Utilisee	bigint
) ON [PRIMARY]

END