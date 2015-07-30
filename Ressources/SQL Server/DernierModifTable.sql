select SCE.name, TAB.name, TAB.modify_date
from sys.tables TAB
JOIN sys.schemas SCE
  ON SCE.schema_id = TAB.schema_id
WHERE TAB.name = 'DimCampagne'

/* Attention : changement d'index clusted compte comme modif */