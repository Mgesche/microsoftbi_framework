#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; Recuperation des infos INI
Local $IniLogMode = IniRead("MatrixTransformation.ini", "General", "LogMode", "NotFound")
Local $IniDossier = IniRead("MatrixTransformation.ini", "General", "Dossier", "NotFound")
Local $IniFichierSource = IniRead("MatrixTransformation.ini", "General", "FichierSource", "NotFound")
Local $IniFichierCible = IniRead("MatrixTransformation.ini", "General", "FichierCible", "NotFound")

Dim $sFileLog
LogCreate()
LogW("Lancement")

If ($IniFichierSource = "NotFound") Then
  LogW("Recuperation $IniFichierSource en ligne commande")
  $IniFichierSource = $CmdLine[1]
EndIf
If ($IniFichierCible = "NotFound") Then
   LogW("Recuperation $IniFichierCible en ligne commande")
   $IniFichierCible = $CmdLine[2]
EndIf

LogW("Ouverture des fichiers")
$sFileSource = FileOpen($IniDossier&"\"&$IniFichierSource, 0)
$sFileCible = FileOpen($IniDossier&"\"&$IniFichierCible, 2)

; Compteur de ligne
Dim $iLigne = 1
Dim $FirstRow = True
Dim $aLigne
Dim $IDCLE1
Dim $IDDIMENSIONKEY1
Dim $IDDIMENSIONKEY2
Dim $PreviousCLE1
Dim $LinearMatrixString
Dim $LigneInsert

; Lecture
While 1

   $line = FileReadLine($sFileSource)
   If @error = -1 Then ExitLoop

   LogW("Lancement de la boucle "&$iLigne)
   LogW("Ligne "&$line)

   ; Recuperation des valeurs
   $aLigne = StringSplit($line, ";")
   $IDCLE1 = $aLigne[1]
   $IDDIMENSIONKEY1 = $aLigne[2]
   $IDDIMENSIONKEY2 = $aLigne[3]

   ; Est ce que l'on a parcouru toutes les clé dimensionnelles liée a la clé foncitonnelle ?
   If ($IDCLE1 <> $PreviousCLE1) Then

	  If Not $FirstRow Then
		 ; Add row
		 $LigneInsert = $PreviousCLE1 & ";" & $LinearMatrixString
		 LogW("To add "&$LigneInsert)
		 FileWriteLine($sFileCible, $LigneInsert)
	  EndIf
	  $LinearMatrixString = $IDDIMENSIONKEY1 & "-" & $IDDIMENSIONKEY2
   Else
	  $LinearMatrixString = $LinearMatrixString & "," & $IDDIMENSIONKEY1 & "-" & $IDDIMENSIONKEY2
   EndIf

   $FirstRow = False
   $PreviousCLE1 = $IDCLE1

   $iLigne = $iLigne + 1

WEnd

LogW("Lancement de la boucle de cloture")
If $FirstRow = False Then
   $LigneInsert = $PreviousCLE1 & ";" & $LinearMatrixString
   FileWriteLine($sFileCible, $LigneInsert)
EndIf

; Cloture des fichiers
FileClose($sFileSource)
FileClose($sFileCible)
LogClose()
LogW("Fermeture des fichiers")

Func LogCreate()
   If $IniLogMode = 1 Then
	  $sFileLog = FileOpen($IniDossier&"\Log.txt", 2)
   EndIf
EndFunc

Func LogClose()
   If $IniLogMode = 1 Then
	  FileClose($sFileLog)
   EndIf
EndFunc

Func LogW($Message)
   FileWriteLine($sFileLog, $Message)
EndFunc