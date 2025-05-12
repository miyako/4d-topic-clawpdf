Dim args 
Set args = WScript.Arguments

Dim fullPath
fullPath = WScript.StdIn.ReadLine()

Dim clawPDFObj
Set clawPDFObj = CreateObject("clawPDF.clawPdfObj")

If clawPDFObj.IsInstanceRunning Then
' Create a WMI object to interact with system processes
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
' Query all running processes with the specified name
    Set colProcesses = objWMIService.ExecQuery("Select * from Win32_Process where Name = 'clawPDF.exe'")
For Each objProcess In colProcesses
    objProcess.Terminate
Next
End If

Set clawPDFQueue = CreateObject("clawPDF.JobQueue")

On Error Resume Next
clawPDFQueue.Initialize()
On Error GoTo 0

If (Not clawPDFQueue.WaitForJob(10)) Then
    WScript.Echo "The print job did not reach the queue within 10 seconds"
    WScript.Quit
Else
   Dim printJob
   Set printJob = clawPDFQueue.NextJob
   
   printJob.ConvertTo(fullPath)

    Do While Not printJob.IsFinished
    WScript.Sleep 500  ' Wait 500 milliseconds before checking again
    Loop

If(printJob.IsSuccessful) Then
    WScript.Echo "Success: "  & fullPath
Else  
    WScript.Echo "Fail:" & fullPath
End If
 
End If

On Error Resume Next
clawPDFQueue.ReleaseCom()
On Error GoTo 0

WScript.StdIn.ReadLine()