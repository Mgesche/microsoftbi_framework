select SUM(NB) from (
select MATRIX_KEY, DIMENTION_KEY,
COUNT(*) AS NB
from MTX.F_PMSI_SSR_RHA_CSARR_WRK
GROUP BY MATRIX_KEY, DIMENTION_KEY
having COUNT(*) > 1) res


