SELECT COUNT(*)
FROM TABLE_FAIT FAC
JOIN TABLE_RELATION REL
  ON FAC.CLE = REL.CLE
WHERE FAC.MATRIX_KEY = -1
