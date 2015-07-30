/* Modif DDE */

/* Ajout de la clé a la table de fait */
ALTER TABLE dbo.F_PMSI_MCO_RSA
Add [ID_DIAG_ALL] [int] NULL;

/* Creation de la table intermediaire */
CREATE TABLE [dbo].[F_PMSI_MCO_RSA_DIAG_WRK](
	[MATRIX_KEY] [int] NOT NULL,
	[DIMENTION_KEY] [nvarchar](6) NOT NULL
);

/* Création de la matrice */
CREATE TABLE [dbo].[F_PMSI_MCO_RSA_MTX](
	[MATRIX_KEY] [int] NOT NULL,
	[LINEAR_MATRIX_STRING] [varchar](100) NOT NULL
CONSTRAINT [PK_F_PMSI_MCO_RSA_MTX] PRIMARY KEY CLUSTERED 
([MATRIX_KEY] ASC));

/* Création du lookup SSIS */
CREATE TABLE [dbo].[F_PMSI_MCO_RSA_MTX_Lookup](
	[MATRIX_KEY] [int] NULL,
	ID_ANNEE INT NULL,
	IDT_FINESS NUMERIC(9,0) NULL,
	IDT_RSA NUMERIC(10,0) NULL
);

/* Création d'une table de correspondance pour travailler sur des entiers : si pertinent */
CREATE TABLE [dbo].[F_PMSI_MCO_RSA_DIAG_INT](
	[ID_DIAG_KEY] [int] IDENTITY(1,1) PRIMARY KEY,
	[ID_DIAG] [nvarchar](6) NULL
) ON [PRIMARY]

/* Modif SSIS */
Renommer la chaine de connection et la faire pointer sur la bonne base

Variables
Renommer "New_SalesReasonMatrixKey" en "New_MatrixKey"
Modifier les clé de comparaison. PAr exemple, remplacer la variable "SalesOrderID" par 3 variables "Id_Annee", "Idt_Finess" et "Id_RSA"

Composant "SQL Get Max Matrix SK"
Remplacer la chaine SQL : 
SELECT
ISNULL(
	(SELECT MAX(SalesReasonMatrixKey)
	FROM DimSalesReasonMatrix)
, 1
)  AS New_SalesReasonMatrixKey
par :
SELECT
ISNULL(
	(SELECT MAX(MATRIX_KEY)
	FROM F_PMSI_MCO_RSA_MTX)
, 1
)  AS New_MatrixKey
Changer dans l'ensemble de résultat par New_MatrixKey

Composant Truncate Matrix Lookup Table
Remplacer l'instruction SQL :
TRUNCATE TABLE [dbo].[SalesOrderToMatrix_Lookup]
par :
TRUNCATE TABLE [dbo].[F_PMSI_MCO_RSA_MTX_Lookup]

Composant Load Sales Reason Matrix :
Renommer le composant en Load RSA Diag Matrix

Composant Sales Order ID and Sales Reason ID
Renommer en Load data
Modifier la chaine SQL
Select convert(int,right(SalesOrderNumber, 5)) as SalesOrderID, SalesReasonKey
from dbo.FactInternetSalesReason
par
SELECT TOP 1000 ID_ANNEE, IDT_FINESS, ID_RSA, ID_DIAG_PRINCIPAL AS ID_DIAG
FROM F_PMSI_MCO_RSA

Si l'une des clés de comparaison ou de résultat n'est pas un entier, ajouter des composants de recherche pour faire la jointure avec une table
de lien comme par exemple F_PMSI_MCO_RSA_DIAG_INT

Composant Sort
Trier par les clés de comparaisond ans l'ordre puis le resultat
Dans notre cas, ID_ANNEE, IDT_FINESS, ID_RSA, ID_DIAG_KEY

Composant script
Mettre en entrée les clés de comparaison + le resultat
Dans notre cas, ID_ANNEE, IDT_FINESS, ID_RSA, ID_DIAG_KEY
Mettre en sortie le LINEAR_MATRIX_STRING puis les clés 

Modifier le script
Modifier les decralaraions de variables
    Dim PreviousAnnee As Int32 = 0
    Dim PreviousFiness As Int32 = 0
    Dim PreviousRSA As Int32 = 0
    Modifier les conditions et les attributions de vraiables
    
Si jamais el cube est partitionné, penser a modifier les requetes des partitions aussi et pas seulement el DSV