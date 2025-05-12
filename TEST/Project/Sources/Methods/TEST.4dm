//%attributes = {"invisible":true,"preemptive":"incapable"}
SET CURRENT PRINTER:C787("clawPDF")

$vbs:=File:C1566(File:C1566("/RESOURCES/clawPDF.vbs").platformPath; fk platform path:K87:2)

$out:=System folder:C487(Desktop:K41:16)+"ああああ.pdf"

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $vbs.parent.platformPath)
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")

var $StdIn; $stdOut; $stdErr : Blob
CONVERT FROM TEXT:C1011($out; "UTF-16LE"; $StdIn)
LAUNCH EXTERNAL PROCESS:C811("cscript /nologo /u clawPDF.vbs"; $StdIn; $stdOut; $stdErr)

SET PRINT OPTION:C733(Paper option:K47:1; "A5")
SET PRINT OPTION:C733(Spooler document name option:K47:10; "test")

OPEN PRINTING JOB:C995
$h:=Print form:C5("test")
CLOSE PRINTING JOB:C996