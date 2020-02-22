This script should work for wired and wireless connections.
Your PC should already be set to use PI-HOLE as DNS. 
Either through the DHCP on the router or manually set in network adapter properties.


////////////////////////////////////////////////////////////////////////////////////////////////////
The script will detect the active network adapter and toggle the DNS between Cloudflare and PI-HOLE.
///////////////////////////////////////////////////////////////////////////////////////////////////
##########################SETUP####################################################################
Put the folder in the root as such:
C:\Toggle


********************************************
IN ORDER TO RUN powershell scripts from vbs,YOU MUST SET EXECUTIONPOLICY TO REMOTESIGNED as such:
Set-ExecutionPolicy remotesigned

###################################################################################################


To run the script, run Toggle.vbs

This will force the windows to remain hidden, and also to use admin rights.


Running Set-Default ps script will set windows 10 to default DNS settings.



ADDITIONAL INFO:
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


It should automatically find your PI-HOLE's IP by using the command:

[System.Net.Dns]::GetHostAddresses($pi.hole) which returns the IP of pi-hole