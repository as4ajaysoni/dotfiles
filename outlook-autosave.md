# Outlook Email Backup Macro — Setup Guide

A one-click macro to automatically save important emails and their attachments into a neatly named folder (`YYYY-MM-DD HHMM <Subject Title>`).

---

## Step 1: Open the VBA Editor

1. Open **Microsoft Outlook**
2. Press **Alt + F11** to open the Visual Basic for Applications editor
3. In the left panel, double-click **ThisOutlookSession**

---

## Step 2: Paste the Macro Code

1. Select any existing code and delete it
2. Paste the following code:

```vba
Sub SaveEmailAndAttachments()

    Dim objMail As Outlook.MailItem
    Dim objItem As Object
    Dim strSubject As String
    Dim strDate As String
    Dim strFolderName As String
    Dim strBasePath As String
    Dim strFullPath As String
    Dim objAttachment As Outlook.Attachment

    ' ── Ask user for the save location at runtime ──
    strBasePath = InputBox("Enter the folder path to save the email & attachments:", "Save Location", "C:\EmailBackups\")

    If strBasePath = "" Then
        MsgBox "No path entered. Operation cancelled.", vbExclamation
        Exit Sub
    End If

    ' Ensure path ends with backslash
    If Right(strBasePath, 1) <> "\" Then strBasePath = strBasePath & "\"

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
```

3. Press **Ctrl + S** to save
4. Close the VBA editor

---

## Step 3: Enable Macros (if blocked)

If you see a warning that macros are disabled:

1. In Outlook, go to **File → Options**
2. Click **Trust Center** → then **Trust Center Settings...**
3. Click **Macro Settings** in the left panel
4. Select **"Notifications for all macros"** *(recommended)*
5. Click **OK → OK**
6. **Restart Outlook** fully for the setting to apply

---

## Step 4: Add Macro to Quick Access Toolbar (QAT)

1. In Outlook, go to **File → Options**
2. Click **Quick Access Toolbar**
3. Under "Choose commands from", select **Macros**
4. Find `SaveEmailAndAttachments` in the list
5. Click **Add >>** to add it to the toolbar
6. Click **Modify** to assign a friendly name (e.g. `Save Email`) and pick an icon
7. Click **OK**

---

## Step 5: Assign a Keyboard Shortcut (Alt + Number)

Outlook automatically assigns Alt shortcuts to QAT buttons:

1. Press the **Alt** key in Outlook — numbers will appear over each QAT button
2. Note the number shown over your macro button (e.g. **1**, **2**, **3**)
3. Your shortcut is now **Alt + [that number]**

> 💡 To control which number it gets, reorder QAT buttons via **File → Options → Quick Access Toolbar** using the **up/down arrows** on the right side.

---

## Using the Macro

| Step | Action |
|------|--------|
| 1 | Select the important email in Outlook |
| 2 | Press your shortcut e.g. **Alt + 1** (or click the toolbar button) |
| 3 | Enter or confirm the folder path in the dialog box |
| 4 | Click **OK** |
| 5 | Done! ✅ |

The macro will automatically:
- Create a folder named `YYYY-MM-DD HHMM <Subject Title>`
- Save the email as a `.msg` file inside it
- Save all attachments inside the same folder

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| "Macros are disabled" error | Follow Step 3 above to enable macros |
| Macro doesn't appear in list | Make sure code is in `ThisOutlookSession`, not a different module |
| Folder not created | Check that the path you entered exists and you have write permission |
| Option greyed out in Trust Center | Macro settings are controlled by your IT/company policy — contact your admin |
