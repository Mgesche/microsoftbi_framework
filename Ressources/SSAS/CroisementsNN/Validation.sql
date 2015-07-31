select	'F_PMSI_MCO_ACTE_WRK' AS [TABLE], CASE WHEN DIM.ID_CCAM IS NULL THEN 'Dimension' ELSE
		CASE WHEN INT.ID_VALUE IS NULL THEN 'Correspondance' ELSE
		CASE WHEN WRK.MATRIX_KEY IS NULL THEN 'Matrixe' ELSE 'OK' END END END AS MB_MANQUANT
from DWH.dbo.D_PMSI_CCAM DIM
LEFT JOIN DWH.MTX.D_PMSI_CCAM_INT INT
  ON INT.ID_VALUE = DIM.ID_CCAM + DIM.ID_CCAM_PHASE + DIM.ID_CCAM_ACTIVITE
LEFT JOIN DWH.MTX.F_PMSI_MCO_ACTE_WRK WRK
  ON WRK.MATRIX_KEY = INT.ID_KEY
WHERE DIM.ID_CCAM = '#'
GROUP BY CASE WHEN DIM.ID_CCAM IS NULL THEN 'Dimension' ELSE
		CASE WHEN INT.ID_VALUE IS NULL THEN 'Correspondance' ELSE
		CASE WHEN WRK.MATRIX_KEY IS NULL THEN 'Matrixe' ELSE 'OK' END END END

/* Valeurs bien remplies */
select	'DSVDebitSousFamilleCRM' AS [TABLE],
        CASE WHEN IDT_PROFIL IS NULL THEN 1 ELSE 0 END AS IDT_PROFIL, 
		CASE WHEN IDT_PROFIL_TEMPS IS NULL THEN 1 ELSE 0 END AS IDT_PROFIL_TEMPS, 
		CASE WHEN IDT_CLASSE IS NULL THEN 1 ELSE 0 END AS IDT_CLASSE, 
		CASE WHEN IDT_CLASSE_TEMPS IS NULL THEN 1 ELSE 0 END AS IDT_CLASSE_TEMPS,
		COUNT(*)
from DSVDebitSousFamilleCRM
GROUP BY CASE WHEN IDT_PROFIL IS NULL THEN 1 ELSE 0 END, 
	  	 CASE WHEN IDT_PROFIL_TEMPS IS NULL THEN 1 ELSE 0 END, 
		 CASE WHEN IDT_CLASSE IS NULL THEN 1 ELSE 0 END, 
		 CASE WHEN IDT_CLASSE_TEMPS IS NULL THEN 1 ELSE 0 END