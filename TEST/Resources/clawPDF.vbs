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

Dim clawPDFObj
Set clawPDFObj = CreateObject("clawPDF.clawPdfObj")

If Not clawPDFObj.IsInstanceRunning Then
    WScript.Echo "No running instance of clawPDF"
    WScript.Quit
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
    If printJob Is Nothing Then
        WScript.Echo "No job object returned."
        WScript.Quit
    Else
        printJob.ConvertTo(fullPath)

        Do While Not printJob.IsFinished
            WScript.Sleep 500  
        Loop

        If(printJob.IsSuccessful) Then
            WScript.Echo "Success: "  & fullPath
        Else  
            WScript.Echo "Fail:" & fullPath
        End If
    End If
End If
 
On Error Resume Next
clawPDFQueue.ReleaseCom()
On Error GoTo 0

WScript.Sleep 2000