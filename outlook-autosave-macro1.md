Sub SaveEmailAndAttachments()

    Dim objMail As Outlook.MailItem
    Dim objItem As Object
    Dim strSubject As String
    Dim strDate As String
    Dim strFolderName As String
    Dim strBasePath As String
    Dim strFullPath As String
    Dim objAttachment As Outlook.Attachment
    Dim i As Integer

    ' -- CONFIG: Change this to your preferred backup root folder --
    strBasePath = "C:\ABC\<PATH TO DOWNLOAD>"
    ' -------------------------------------------------------------

    ' Get the currently selected email
    Set objItem = Application.ActiveExplorer.Selection.Item(1)
    
    If objItem.Class <> olMail Then
        MsgBox "Please select an email first.", vbExclamation
        Exit Sub
    End If
    
    Set objMail = objItem

    ' Build folder name: YYYY-MM-DD HHMM <Subject>
    strDate = Format(objMail.ReceivedTime, "YYYY-MM-DD HHMM")
    
    ' Sanitize subject (remove characters invalid in folder names)
    strSubject = objMail.Subject
    strSubject = ReplaceInvalidChars(strSubject)
    
    strFolderName = strDate & " " & strSubject
    strFullPath = strBasePath & strFolderName & "\"

    ' Create the folder if it doesn't exist
    If Dir(strFullPath, vbDirectory) = "" Then
        MkDir strFullPath
    End If

    ' Save the email as .msg
    objMail.SaveAs strFullPath & strSubject & ".msg", olMSG

    ' Save all attachments
    If objMail.Attachments.Count > 0 Then
        For Each objAttachment In objMail.Attachments
            objAttachment.SaveAsFile strFullPath & objAttachment.FileName
        Next objAttachment
        MsgBox "Done! Saved " & objMail.Attachments.Count & " attachment(s) + email to:" & vbCrLf & strFullPath, vbInformation
    Else
        MsgBox "Done! No attachments found. Email saved to:" & vbCrLf & strFullPath, vbInformation
    End If

End Sub

' Helper: strips characters not allowed in Windows folder names
Function ReplaceInvalidChars(str As String) As String
    Dim invalidChars As Variant
    Dim c As Variant
    invalidChars = Array("\", "/", ":", "*", "?", """", "<", ">", "|")
    For Each c In invalidChars
        str = Join(Split(str, c), "-")
    Next c
    ' Trim to max 80 chars to keep paths manageable
    If Len(str) > 80 Then str = Left(str, 80)
    ReplaceInvalidChars = str
End Function


