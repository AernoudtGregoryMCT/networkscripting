#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will change the hostname of the server.
#>
############ GLOBAL VARIABLES ############
$hostnameDC1 = "DC1"
############ CONFIGURE COMPUTERNAME ############
#region configure computername
try {
    if ($env:COMPUTERNAME -notlike $hostnameDC1) {
        Rename-Computer -NewName $hostnameDC1
        Write-Information("Computername was changed to $hostnameDC1.")
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