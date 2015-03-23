' https://msdn.microsoft.com/en-us/library/ee240819.aspx
' https://msdn.microsoft.com/en-us/library/dd207057.aspx
' =Code.MakeList(LookupSet(Fields!PAR_PartyID.Value, Fields!PAR_PartyID.Value, Fields!EventName.Value, "Evenement"))
Function MakeList(ByVal items As Object()) As String
   If items Is Nothing Then
      Return Nothing
   End If

   Dim builder As System.Text.StringBuilder = New System.Text.StringBuilder()
   builder.Append("<ul>")

   For Each item As Object In items
      builder.Append("<li>")
      builder.Append(item)
   Next
   builder.Append("</ul>")

   Return builder.ToString()
End Function

Function Length(ByVal items as Object()) as Integer
   If items is Nothing Then
      Return 0
   End If
   Return items.Length
End Function