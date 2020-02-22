###THIS FORCES SCRIPT TO RUN AS ADMIN
#####################################################################################################################################################################
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments -windowstyle hidden
    Break
}
#####################################################################################################################################################################
###////////////////////////////////////////////////////////////////////////////////////////////////////////##########################################################


$ethernet = Get-NetAdapter | Select-Object -Property InterfaceName,InterfaceIndex | Select-Object -First 1 

Set-DnsClientServerAddress -InterfaceIndex $ethernet.InterfaceIndex -ResetServerAddresses