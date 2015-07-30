truncate table F_PMSI_MCO_RSA_MTX

truncate table F_PMSI_MCO_RSA_DIAG_WRK

alter table dbo.F_PMSI_MCO_RSA
drop column id_diag_all

ALTER TABLE dbo.F_PMSI_MCO_RSA
Add [ID_DIAG_ALL] [int] NULL;
