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

#DESIRED ALTERNATIVE DNS SERVER
$cloudflare = "1.1.1.1", "1.0.0.1"

#GET PI-HOLE IP FROM HOSTNAME
$piip = [System.Net.Dns]::GetHostAddresses("pi.hole").Where({$_.AddressFamily -eq 'InterNetwork'}).IPAddressToString


###BALLOON NOTIFICATIONS########################################################################################

Add-Type -AssemblyName System.Windows.Forms
$global:balmsg = New-Object System.Windows.Forms.NotifyIcon
$path = (Get-Process -id $pid).Path
$balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
$balmsg.BalloonTipText = ‘NOW ON PI-HOLE'
$balmsg.BalloonTipTitle = "Attention $Env:USERNAME"
$balmsg.Visible = $true


Add-Type -AssemblyName System.Windows.Forms
$global:bal1msg = New-Object System.Windows.Forms.NotifyIcon
$path = (Get-Process -id $pid).Path
$bal1msg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$bal1msg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
$bal1msg.BalloonTipText = ‘NOW ON CLOUDFLARE DNS'
$bal1msg.BalloonTipTitle = "Attention $Env:USERNAME"
$bal1msg.Visible = $true


###############################################################################################################

##GRAB DEFAULT ETHERNET INTERFACE INDEX
$ethernet = Get-NetAdapter | Select-Object -Property InterfaceName,InterfaceIndex | Select-Object -First 1 

$currentdns = Get-DnsClientServerAddress -InterfaceIndex $ethernet.InterfaceIndex | Select-Object -First 1 

#################################################################################################################




if ($currentdns.ServerAddresses -eq $piip)
{
    #SAVE PI-HOLE's IP for future toggle
    $foo = $piip 
    $foo | Export-CliXml foo.xml

    #SWITCH TO CLOUDFLARE DNS
    Set-DnsClientServerAddress -InterfaceIndex $ethernet.InterfaceIndex -ServerAddresses $cloudflare
    Clear-DnsClientCache
    ECHO "NOW ON CLOUDFLARE DNS"
    $bal1msg.ShowBalloonTip(20000)

}
else
{
    #IMPORT PI-HOLE IP FROM FOO.XML
    $foo = Import-CliXml foo.xml

    #SET PI-HOLE AS DNS
    Set-DnsClientServerAddress -InterfaceIndex $ethernet.InterfaceIndex -ServerAddresses $foo
    Clear-DnsClientCache
    ECHO "BACK TO PI-HOLE"
    $balmsg.ShowBalloonTip(20000)
}


###########################################################################################################
#########################################NOTES#############################################################
###########################################################################################################

#SET DNS TO CLOUDFLARE
#Set-DnsClientServerAddress -InterfaceIndex $x.InterfaceIndex -ServerAddresses 1.1.1.1



#RESET DNS TO DEFAULT 
#Set-DnsClientServerAddress -InterfaceIndex $x.InterfaceIndex -ResetServerAddresses


