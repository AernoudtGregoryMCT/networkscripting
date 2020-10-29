#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will change the hostname of the server.
#>


############ GLOBAL VARIABLES ############
$computer = "192.168.1.12"
$credential = "Administrator"

Set-item WSMAN:\Localhost\Client\TrustedHosts -value 192.168.1.12

Invoke-Command -Computer $computer -Credential (Get-Credential $credential) -ScriptBlock { 
    ############ GLOBAL VARIABLES ############
    $hostnameDC2 = "DC2"
    ############ CONFIGURE COMPUTERNAME ############
    #region configure computername
    try {
        if ($env:COMPUTERNAME -notlike $hostnameDC2) {
            Rename-Computer -NewName $hostnameDC2
            Write-Information("Computername was changed to $hostnameDC2.")
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