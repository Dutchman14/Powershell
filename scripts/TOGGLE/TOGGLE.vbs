command = "powershell.exe -nologo -command C:\TOGGLE\SCRIPT.PS1"

set shell = CreateObject("WScript.Shell")

shell.Run command,0

