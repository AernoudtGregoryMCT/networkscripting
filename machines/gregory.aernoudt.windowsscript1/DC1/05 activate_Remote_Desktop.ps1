#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will activate remote desktop on a Windows Machine.
#>

############ ACTIVATE REMOTE DESKTOP ############
#region Remote desktop
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
#endregion