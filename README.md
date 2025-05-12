![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=win-64&color=blue)

# 4d-topic-clawpdf

[clawPDF](https://github.com/clawsoftware/clawPDF)は，オープンソースだった初期のPDF Creatorをベースに開発された仮想プリンタードライバーです。

## 自動保存オブションを使用する方法

* **clawPDF**アプリを起動し，*Profile settings/Auto-Save* を開きます。

<img src="https://github.com/user-attachments/assets/e60673fb-7b15-4159-a77e-3ba68211e527" width=500 height=auto />

* *Enable automatic saving* を有効にします。
* 保存パスを`C:\Users\<Username>\<PrinterName>`に設定します。

下記の要領で印刷できます。

```4d
SET CURRENT PRINTER("clawPDF")

PRINTERS LIST($printers)
SET CURRENT PRINTER("clawPDF")

$name:="請求書"
var $file : 4D.File
$file:=Folder(fk home folder).folder("clawPDF").file($name+".pdf")
If ($file.exists)
	$file.delete()
End if 

SET PRINT OPTION(Paper option; "A5")
SET PRINT OPTION(Spooler document name option; $name)

OPEN PRINTING JOB
$h:=Print form("test")
CLOSE PRINTING JOB

OPEN URL($file.platformPath)
```
