Dim fullPath
fullPath = WScript.StdIn.ReadLine()

' Optional? Set as default printer
Set shell = CreateObject("WScript.Network")
shell.SetDefaultPrinter "clawPDF"

' Query all running processes with the specified name
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colProcesses = objWMIService.ExecQuery("Select * from Win32_Process where Name = 'clawPDF.exe'")
For Each objProcess In colProcesses
    objProcess.Terminate
Next

Set clawPDFObj = CreateObject("clawPDF.clawPdfObj")
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
        WScript.Sleep 500  
    Loop

    If(printJob.IsSuccessful) Then
        WScript.Echo "Success: "  & fullPath
    Else  
        WScript.Echo "Fail: " & fullPath
    End If
End If
 
On Error Resume Next
clawPDFQueue.ReleaseCom()
On Error GoTo 0