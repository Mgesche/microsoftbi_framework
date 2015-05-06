TRUNCATE TABLE DSV.Partitions

SET IDENTITY_INSERT DSV.Partitions ON

INSERT INTO DSV.Partitions (
	 [id]
      ,[Fact]
      ,[Period]
      ,[StartD]
      ,[EndD]
      ,[SousPeriod]
      ,[ToProcess]
      ,[CreateXMLA]
      ,[UpdateXMLA]
      ,[DatabaseID]
      ,[CubeID]
      ,[MeasureGroupID]
      ,[MeasureGroupIDReference]
      ,[ChampsTableName]
      ,[CreateXMLARef]
      ,[UpdateXMLARef]
      ,[PartitionTableQuery]
      ,[ProcessAction]
      ,[ProcessActionRef]
      ,[ToProcessRef]
      ,[ProcessActionIndex]
      ,[ProcessActionRefIndex]
      ,[DataSourceID]
      ,[TypePlanif]
      ,[export_rapp]
)
SELECT [id]
      ,[Fact]
      ,[Period]
      ,[StartD]
      ,[EndD]
      ,[SousPeriod]
      ,[ToProcess]
      ,[CreateXMLA]
      ,[UpdateXMLA]
      ,[DatabaseID]
      ,[CubeID]
      ,[MeasureGroupID]
      ,[MeasureGroupIDReference]
      ,[ChampsTableName]
      ,[CreateXMLARef]
      ,[UpdateXMLARef]
      ,[PartitionTableQuery]
      ,[ProcessAction]
      ,[ProcessActionRef]
      ,[ToProcessRef]
      ,[ProcessActionIndex]
      ,[ProcessActionRefIndex]
      ,[DataSourceID]
      ,[TypePlanif]
      ,[export_rapp]
FROM dbo.partitions

SET IDENTITY_INSERT DSV.Partitions OFF

/* Creation de PartitionTable */
/*
select distinct 'UPDATE DSV.Partitions SET PartitionTable = '''' WHERE PartitionTableQuery = '''+PartitionTableQuery+''''
FROM [BotanicDW_MEC].[dbo].[partitions]
*/

UPDATE DSV.Partitions SET PartitionTable = 'DSVLigneTicket' WHERE PartitionTableQuery = 'SELECT       DateEdition_id,   HeureEdition_id,   Societe_id,   Article_id,   CauseVariationMarge_id,   CodeClient,   codeOperationCommerciale,   QuantiteVendue,   PrixVenteCaisseUnitaireHT,   PrixVenteCaisseHT,   PrixVenteTicketUnitaireHT,   PrixVenteTicketHT,   MontantCouponValeur,   CA,   PrixVenteImposeUnitaireHT,   PrixVenteForceMagasinUnitaireHT,   PrixVenteGeneralementConstateHT,   MargeEntreeTheoriqueCentrale,   MargeEntreeTheoriqueMagasin,   MargeSortie,   CoutRevientUnitairePMP,   MontantRemise,   FlagRetour,   NumLigneTicket,   NumTicket,   AuditMagasin_id,   JunkLigneTicket_id,   FlagHorsCA,  PVGCHT,   PVKSHT,   TAXE,   enseigne_id, campagne_id  FROM  DSVLigneTicket'
UPDATE DSV.Partitions SET PartitionTable = 'DSVStockMagasin' WHERE PartitionTableQuery = 'SELECT     DateMouvement_id, Article_id, campagne_id, Societe_id, CauseDemarque_id, TypeTransactionStock_id, QuantiteDisponible, QuantiteMouvement, QuantiteSurmarque, QuantiteDemarque, ValeurSurmarqueAuPMP, ValeurDemarqueAuPMP, ValeurDisponibleAuPMP, CoutRevientUnitairePMP, enseigne_id FROM  DSVStockMagasin'
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVDebitFamilleCRM' WHERE PartitionTableQuery = 'SELECT     dbo.DSVDebitFamilleCRM.debitfide,dbo.DSVDebitFamilleCRM.Societe_id, dbo.DSVDebitFamilleCRM.FamilleArticle_id, dbo.DSVDebitFamilleCRM.Temps_id, dbo.DSVDebitFamilleCRM.client_id,                        dbo.DSVDebitFamilleCRM.campagne_id, dbo.DSVDebitFamilleCRM.DebitOpeCo, dbo.DSVDebitFamilleCRM.Debit, dimsociete.enseigne_id, 1 AS Phase, COALESCE(IDT_Profil_Historisation, -1) AS IDT_Profil_Historisation, COALESCE(IDT_Classe_Historisation, -1) AS IDT_Classe_Historisation FROM         dbo.DSVDebitFamilleCRM INNER JOIN                       dbo.DimSociete ON dimsociete.societe_id = DSVDebitFamilleCRM.societe_id '
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVDebitGroupeCRM' WHERE PartitionTableQuery = 'SELECT     dbo.DSVDebitGroupeCRM.debitfide, dbo.DSVDebitGroupeCRM.Societe_id, dbo.DSVDebitGroupeCRM.Temps_id, dbo.DSVDebitGroupeCRM.client_id, dbo.DSVDebitGroupeCRM.campagne_id,                        dbo.DSVDebitGroupeCRM.DebitOpeCo, dbo.DSVDebitGroupeCRM.Debit, dbo.DSVDebitGroupeCRM.GroupeArticle_id, dbo.DimSociete.enseigne_id, 1 AS Phase, COALESCE(IDT_Profil_Historisation, -1) AS IDT_Profil_Historisation, COALESCE(IDT_Classe_Historisation, -1) AS IDT_Classe_Historisation FROM         dbo.DSVDebitGroupeCRM INNER JOIN                       dbo.DimSociete ON Dimsociete.societe_id = DSVDebitGroupeCRM.societe_id '
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVDebitSousFamilleCRM' WHERE PartitionTableQuery = 'SELECT     dbo.DSVDebitSousFamilleCRM.debitfide, dbo.DSVDebitSousFamilleCRM.Societe_id, dbo.DSVDebitSousFamilleCRM.Temps_id, dbo.DSVDebitSousFamilleCRM.client_id,                        dbo.DSVDebitSousFamilleCRM.campagne_id, dbo.DSVDebitSousFamilleCRM.DebitOpeCo, dbo.DSVDebitSousFamilleCRM.Debit,                        dbo.DSVDebitSousFamilleCRM.SousFamilleArticle_id, dbo.DimSociete.enseigne_id, 1 AS Phase, COALESCE(IDT_Profil_Historisation, -1) AS IDT_Profil_Historisation, COALESCE(IDT_Classe_Historisation, -1) AS IDT_Classe_Historisation FROM         dbo.DSVDebitSousFamilleCRM INNER JOIN                       dbo.DimSociete ON DimSociete.societe_id = DSVDebitSousFamilleCRM.societe_id '
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVDebitTotauxCRM' WHERE PartitionTableQuery = 'SELECT     dbo.DSVDebitTotauxCRM.debitfide, dbo.DSVDebitTotauxCRM.Societe_id, dbo.DSVDebitTotauxCRM.Temps_id, dbo.DSVDebitTotauxCRM.client_id, dbo.DSVDebitTotauxCRM.campagne_id,                        dbo.DSVDebitTotauxCRM.DebitOpeCo, dbo.DSVDebitTotauxCRM.Debit, dimsociete.enseigne_id, 1 AS Phase, COALESCE(IDT_Profil_Historisation, -1) AS IDT_Profil_Historisation, COALESCE(IDT_Classe_Historisation, -1) AS IDT_Classe_Historisation FROM         dbo.DSVDebitTotauxCRM INNER JOIN                       dbo.DimSociete ON dimsociete.societe_id = DSVDebitTotauxCRM.societe_id '
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVRemun' WHERE PartitionTableQuery = 'SELECT     dbo.DSVRemun.Mois, DSVRemun.Societe_Id, dbo.DSVRemun.FournisseurCondition_id, dbo.DSVRemun.FournisseurRemun_id, dbo.DSVRemun.SousFamille_Id, dbo.DSVRemun.CodeTypeLigne, dbo.DSVRemun.CodeStatutLigne, dbo.DSVRemun.Prestation_id, dbo.DSVRemun.TypeDocument_id, dbo.DSVRemun.TypeCondition_id, dbo.DSVRemun.MtFactureMagasin, dbo.DSVRemun.MtFraisDiversRegul, dbo.DSVRemun.MtRemun, 1 AS Phase,  DimSociete.enseigne_id, dbo.DSVRemun.TypeCritereCalcul_id , dbo.DSVRemun.Invoiced FROM         dbo.DSVRemun LEFT OUTER JOIN dbo.DimSociete ON DimSociete.Societe_id = DSVRemun.Societe_Id'
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVStock' WHERE PartitionTableQuery = 'SELECT     dbo.DSVStock.MoisCliche, DSVStock.Societe_Id, dbo.DSVStock.SousFamille_Id, dbo.DSVStock.Fournisseur_id, dbo.DSVStock.CodeTypeLigne, dbo.DSVStock.QtDisponible, dbo.DSVStock.PMPDisponible, 1 AS Phase, DimSociete.enseigne_id FROM         dbo.DSVStock LEFT OUTER JOIN dbo.DimSociete ON DimSociete.Societe_id = DSVStock.Societe_Id'
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVFactures' WHERE PartitionTableQuery = 'SELECT     DimSociete.enseigne_id, dbo.DSVFactures.Mois, dbo.DSVFactures.Societe_Id, dbo.DSVFactures.FournisseurAccordCo_Id, dbo.DSVFactures.FournisseurFacture_Id,dbo.DSVFactures.SousFamille_Id, dbo.DSVFactures.CodeTypeLigne, dbo.DSVFactures.CodeStatutLigne, dbo.DSVFactures.QtFacture, dbo.DSVFactures.MtCAPVGC,dbo.DSVFactures.MtHABrutTheo, dbo.DSVFactures.MtHANetTheo, dbo.DSVFactures.MtHANetFacture, dbo.DSVFactures.MtFraisDivers, dbo.DSVFactures.MtFraisImport,dbo.DSVFactures.MtEscompte, dbo.DSVFactures.MtCoutStockage, dbo.DSVFactures.MtCoutTransport, dbo.DSVFactures.MtCrossDock, dbo.DSVFactures.NbPalette,dbo.DSVFactures.MtCoutPaletteStandard, 1 AS Phase, dbo.DSVFactures.MtCAAuxine FROM dbo.DSVFactures LEFT OUTER JOIN dbo.DimSociete ON DimSociete.Societe_id = DSVFactures.Societe_Id'
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVTicketCRM' WHERE PartitionTableQuery = 'SELECT     enseigne_id, client_id, montanttva, inseeenquete, montantttc, codepostal, NumTicket, Statut, Societe_id, dateedition_id, intHeure_id, idasp, idax, numcarte, prenom,                        nom, villeinscritticket, fide, 1 as Phase, COALESCE(IDT_Profil_Historisation, -1) AS IDT_Profil_Historisation, COALESCE(IDT_Classe_Historisation, -1) AS IDT_Classe_Historisation FROM         dbo.DSVTicketCRM'
UPDATE DSV.Partitions SET PartitionTable = 'dbo.DSVDebitUniversCRM' WHERE PartitionTableQuery = 'SELECT    dbo.DSVDebitUniversCRM.debitfide, dbo.DSVDebitUniversCRM.Societe_id, dbo.DSVDebitUniversCRM.Temps_id, dbo.DSVDebitUniversCRM.client_id, dbo.DSVDebitUniversCRM.campagne_id,                        dbo.DSVDebitUniversCRM.DebitOpeCo, dbo.DSVDebitUniversCRM.Debit, dbo.DSVDebitUniversCRM.UniversArticle_id, dbo.DimSociete.enseigne_id, 1 AS Phase, COALESCE(IDT_Profil_Historisation, -1) AS IDT_Profil_Historisation, COALESCE(IDT_Classe_Historisation, -1) AS IDT_Classe_Historisation FROM         dbo.DSVDebitUniversCRM INNER JOIN                       dbo.DimSociete ON DimSociete.societe_id = DSVDebitUniversCRM.societe_id '
UPDATE DSV.Partitions SET PartitionTable = 'DSVStockCliche' WHERE PartitionTableQuery = 'SELECT     DSVStockCliche.DateCliche_id,     DSVStockCliche.Article_id,    DSVStockCliche.Societe_id,    DSVStockCliche.QuantiteDisponible,   DSVStockCliche.ValeurDisponibleAuPMP,    DSVStockCliche.enseigne_id   FROM DSVStockCliche'
UPDATE DSV.Partitions SET PartitionTable = '[dbo].[DSVDebitFamille]' WHERE PartitionTableQuery = 'SELECT [dbo].[DSVDebitFamille].[FamilleArticle_id],[dbo].[DSVDebitFamille].[Debit],[dbo].[DSVDebitFamille].[Societe_id],[dbo].[DSVDebitFamille].[TypeDebit_id],[dbo].[DSVDebitFamille].[Temps_id],[dbo].[DSVDebitFamille].[campagne_id],[dbo].[DSVDebitFamille].[DebitOpeCo] FROM [dbo].[DSVDebitFamille]'
UPDATE DSV.Partitions SET PartitionTable = '[dbo].[DSVDebitGroupe]' WHERE PartitionTableQuery = 'SELECT [dbo].[DSVDebitGroupe].[GroupeArticle_id],[dbo].[DSVDebitGroupe].[Debit],[dbo].[DSVDebitGroupe].[Temps_id],[dbo].[DSVDebitGroupe].[Societe_id],[dbo].[DSVDebitGroupe].[TypeDebit_id],[dbo].[DSVDebitGroupe].[campagne_id],[dbo].[DSVDebitGroupe].[DebitOpeCo] FROM [dbo].[DSVDebitGroupe]'
UPDATE DSV.Partitions SET PartitionTable = '[dbo].[DSVDebitSousFamille]' WHERE PartitionTableQuery = 'SELECT [dbo].[DSVDebitSousFamille].[SousFamilleArticle_id],[dbo].[DSVDebitSousFamille].[Debit],[dbo].[DSVDebitSousFamille].[Temps_id],[dbo].[DSVDebitSousFamille].[Societe_id],[dbo].[DSVDebitSousFamille].[TypeDebit_id],[dbo].[DSVDebitSousFamille].[campagne_id],[dbo].[DSVDebitSousFamille].[DebitOpeCo] FROM [dbo].[DSVDebitSousFamille]'
UPDATE DSV.Partitions SET PartitionTable = '[dbo].[DSVDebitSousGroupe]' WHERE PartitionTableQuery = 'SELECT [dbo].[DSVDebitSousGroupe].[sousGroupeArticle_id],[dbo].[DSVDebitSousGroupe].[Debit],[dbo].[DSVDebitSousGroupe].[Temps_id],[dbo].[DSVDebitSousGroupe].[Societe_id],[dbo].[DSVDebitSousGroupe].[TypeDebit_id],[dbo].[DSVDebitSousGroupe].[campagne_id],[dbo].[DSVDebitSousGroupe].[DebitOpeCo] FROM [dbo].[DSVDebitSousGroupe]'
UPDATE DSV.Partitions SET PartitionTable = '[dbo].[DSVDebitTotaux]' WHERE PartitionTableQuery = 'SELECT [dbo].[DSVDebitTotaux].[Debit],[dbo].[DSVDebitTotaux].[Temps_id],[dbo].[DSVDebitTotaux].[Societe_id],[dbo].[DSVDebitTotaux].[TypeDebit_id],[dbo].[DSVDebitTotaux].[campagne_id],[dbo].[DSVDebitTotaux].[DebitOpeCo] FROM [dbo].[DSVDebitTotaux]'
UPDATE DSV.Partitions SET PartitionTable = '[dbo].[DSVDebitUnivers]' WHERE PartitionTableQuery = 'SELECT [dbo].[DSVDebitUnivers].[Debit],[dbo].[DSVDebitUnivers].[Temps_id],[dbo].[DSVDebitUnivers].[Societe_id],[dbo].[DSVDebitUnivers].[TypeDebit_id],[dbo].[DSVDebitUnivers].[campagne_id],[dbo].[DSVDebitUnivers].[DebitOpeCo],[dbo].[DSVDebitUnivers].[UniversArticle_id] FROM [dbo].[DSVDebitUnivers]'
UPDATE DSV.Partitions SET PartitionTable = '[dbo].[DSVSoldePoints]' WHERE PartitionTableQuery = 'SELECT [typeevenement_id] ,[origineevenement_id]      ,[raisonevenement_id]      ,[temps_id]      ,[id_client]      ,[societeclient_id]      ,[enseigneclient_id]      ,[pt_acquis]      ,[soldecalculebddreferentiel]      ,[mois_id]      ,[solde_neg],1 as Phase, COALESCE(IDT_Profil_Historisation, -1) AS IDT_Profil_Historisation, COALESCE(IDT_Classe_Historisation, -1) AS IDT_Classe_Historisation  FROM [BotanicDW_MEC].[dbo].[DSVSoldePoints] '
UPDATE DSV.Partitions SET PartitionTable = 'DSVStockCliche' WHERE PartitionTableQuery = 'SELECT DSVStockCliche.DateCliche_id,   DSVStockCliche.Article_id, DSVStockCliche.Societe_id, DSVStockCliche.QuantiteDisponible,DSVStockCliche.ValeurDisponibleAuPMP, DSVStockCliche.enseigne_id FROM DSVStockCliche'
UPDATE DSV.Partitions SET PartitionTable = '[dbo].[DSVLigneTicketCRM]' WHERE PartitionTableQuery = 'SELECT TIK.[DateEdition_id] ,TIK.[HeureEdition_id] ,TIK.[Societe_id] ,TIK.[Article_id] ,TIK.[QuantiteVendue] ,TIK.[CA] ,TIK.[MargeEntreeTheoriqueCentrale] ,TIK.[MargeEntreeTheoriqueMagasin] ,TIK.[MargeSortie] ,TIK.[MontantRemise] ,TIK.[FlagRetour] ,TIK.[FlagHorsCA] ,TIK.[PVGCHT] ,TIK.[PVKSHT] ,TIK.[TAXE] ,TIK.[client_id] ,TIK.[campagne_id] ,TIK.[enseigne_id] ,TIK.[fide],1 as Phase, COALESCE(TIK.IDT_Profil_Historisation, -1) AS IDT_Profil_Historisation, COALESCE(TIK.IDT_Classe_Historisation, -1) AS IDT_Classe_Historisation, CLI.datedebutadhesion_int, CLI.datefinadhesion_int, TIK.Nb_Achat_Carte, TIK.Nb_Nouvelles_Adhesion, TIK.Nb_Readhesion_Payante, TIK.Nb_Readhesion_Gratuite, CLI.datereadhesion_int   FROM [BotanicDW_MEC].[dbo].[DSVLigneTicketCRM] AS TIK LEFT JOIN dbo.DimClient AS CLI ON CLI.id = TIK.client_id '
