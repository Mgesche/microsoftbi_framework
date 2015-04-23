Private bOddRow As Boolean, n As String
 
Function AlternateColor(ByVal OddColor As String, _
         ByVal EvenColor As String, ByVal Toggle As Boolean, ByVal projno As String) As String
'on inverse la couleur de base a chaque ligne
bOddRow = Not bOddRow 
 
'si le n° de projet est le meme qu'a la ligne précédente, on réinverse la couleur
If projno = n then bOddRow = Not bOddRow
 
'n prend la valeur du n° de projet de la ligne
n = projno
 
'En fonction de bOddRow, on renvoie la couleur
If bOddRow Then
        Return OddColor
    Else
        Return EvenColor
    End If
End Function

' Exemple d'utilisation sans les groupes
' =Code.AlternateColor("AliceBlue", "White", True) pour la 1ere colonne
' =Code.AlternateColor("AliceBlue", "White", False) pour toutes les autres

' Exemple d'utilisation avec un groupe
' =Code.AlternateColor("LightGrey", "White", True, Fields!Project_Number.Value) pour la 1ere colonne
' =Code.AlternateColor("LightGrey", "White", False, Fields!Project_Number.Value) pour les autres