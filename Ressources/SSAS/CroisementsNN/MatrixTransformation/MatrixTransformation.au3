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

If ($IniFichierSource = "NotFound") Then
   $IniFichierSource = $CmdLine[1]
EndIf
If ($IniFichierCible = "NotFound") Then
   $IniFichierCible = $CmdLine[2]
EndIf

Dim $sFileLog
LogCreate()
LogW("Lancement")

$sFileSource = FileOpen($IniDossier&"\"&$IniFichierSource, 0)
$sFileCible = FileOpen($IniDossier&"\"&$IniFichierCible, 2)
LogW("Ouverture des fichiers")

; Compteur de ligne
Dim $iLigne = 1
Dim $FirstRow = True
Dim $aLigne
Dim $IDANNEE
Dim $IDTFINESS
Dim $IDTRSA
Dim $IDDIMENSIONKEY
Dim $PreviousAnnee
Dim $PreviousFiness
Dim $PreviousRSA
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
   $IDANNEE = $aLigne[1]
   $IDTFINESS = $aLigne[2]
   $IDTRSA = $aLigne[3]
   $IDDIMENSIONKEY = $aLigne[4]

   ; Est ce que l'on a parcouru toutes les clé dimensionnelles liée a la clé foncitonnelle ?
   If ($IDANNEE <> $PreviousAnnee) Or ($IDTFINESS <> $PreviousFiness) Or ($IDTRSA <> $PreviousRSA) Then

	  If Not $FirstRow Then
		 ; Add row
		 $LigneInsert = $PreviousAnnee & ";" & $PreviousFiness & ";" & $PreviousRSA & ";" & $LinearMatrixString
		 LogW("To add "&$LigneInsert)
		 FileWriteLine($sFileCible, $LigneInsert)
	  EndIf
	  $LinearMatrixString = $IDDIMENSIONKEY
   Else
	  $LinearMatrixString = $LinearMatrixString & "," & $IDDIMENSIONKEY
   EndIf

   $FirstRow = False
   $PreviousAnnee = $IDANNEE
   $PreviousFiness = $IDTFINESS
   $PreviousRSA = $IDTRSA

   $iLigne = $iLigne + 1

WEnd

LogW("Lancement de la boucle de cloture")
If $FirstRow = False Then
   $LigneInsert = $PreviousAnnee & ";" & $PreviousFiness & ";" & $PreviousRSA & ";" & $LinearMatrixString
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