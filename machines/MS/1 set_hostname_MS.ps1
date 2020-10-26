#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will change the hostname of the server.
#>
############ GLOBAL VARIABLES ############
$computer = "192.168.1.4"
$credential = "intranet.mijnschool.be\administrator"

Set-item WSMAN:\Localhost\Client\TrustedHosts -value 192.168.1.4

Invoke-Command -Computer $computer -Credential (Get-Credential $credential) -ScriptBlock {
    ############ GLOBAL VARIABLES ############
    $hostnameMS = "MS"
    ############ CONFIGURE COMPUTERNAME ############
    #region configure computername
    try {
        if ($env:COMPUTERNAME -notlike $hostnameMS) {
            Rename-Computer -NewName $hostnameMS
            Write-Information("Computername was changed to $hostnameMS.")
            Write-Information("Pleasse reboot the computer now, before running the other parts of this script!")
        }
        else {
            Write-Information("The computername is the same, skipping...")
        }
    }
    catch {
        Write-Error("Computername could not be changed.")        
    }
    #endregion
}