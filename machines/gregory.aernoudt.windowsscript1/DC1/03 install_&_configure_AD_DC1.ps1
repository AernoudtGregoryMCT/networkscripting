#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will install & configure AD on a Windows Server.
#>

############ GLOBAL VARIABLES ############
$domainName = "intranet.mijnschool.be"
$safeModeAdministratorPassword = "P@ssw0rd"

############ INSTALL & CONFIGURE AD ############
# region installation & configuration of Active Directory
# INSTALLATION
try {
    if (-not (Get-Module -ListAvailable -Name AD-Domain-Services)) {
        Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
    } 
    else {
        Write-Host "WindowsFeatures AD-Domain-Services is already installed."
        Write-Host ("Skipping...")
    }
    if (-not (Get-Module -ListAvailable -Name RSAT-AD-AdminCenter)) {
        Install-WindowsFeature RSAT-AD-AdminCenter
    } 
    else {
        Write-Host "WindowsFeatures RSAT-AD-AdminCenter is already installed."
        Write-Host ("Skipping...")
    }
    if (-not (Get-Module -ListAvailable -Name RSAT-ADDS-Tools)) {
        Install-WindowsFeature RSAT-ADDS-Tools
    } 
    else {
        Write-Host "WindowsFeatures RSAT-ADDS-Tools is already installed."
        Write-Host ("Skipping...")
    }
}
catch {
    Write-Error ("WindowsFeatures AD-Domain-Services, RSAT-AD-AdminCenter & RSAT-ADDS-Tools could not be installed.")
    Read-Host ("Press any key to exit...")
    exit(1)
}

if (Get-Module -ListAvailable -Name AD-Domain-Services, RSAT-AD-AdminCenter, RSAT-ADDS-Tools) {
    #Role configuratie
    Install-ADDSForest -DomainName $domainName -SafeModeAdministratorPassword (ConvertTo-SecureString -String $safeModeAdministratorPassword -AsPlainText -Force) -InstallDns -Force:$True
} 
# Install additional DC
Install-ADDSDomainController -CreateDnsDelegation:$True -DatabasePath 'C:\Windows\NTDS' -DomainName $domainName -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$True -Force:$True
Write-Information("Pleasse reboot the computer now, before running the other parts of this script!")
# endregion
