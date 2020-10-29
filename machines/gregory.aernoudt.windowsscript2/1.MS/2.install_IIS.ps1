#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will installIIS.
#>
############ GLOBAL VARIABLES ############
$computer = "MS"

Invoke-Command -Computer $computer -ScriptBlock { 
    ############ INSTALLATION OF IIS ############   
    #region Install IIS
    try {
        if (-not (Get-Module -ListAvailable -Name web-server)) {
            Install-WindowsFeature web-server
        } 
        else {
            Write-Host "WindowsFeatures web-server is already installed."
            Write-Host ("Skipping...")
        }
        if (-not (Get-Module -ListAvailable -Name web-asp-net)) {
            Install-WindowsFeature web-asp-net
        } 
        else {
            Write-Host "WindowsFeatures web-asp-net is already installed."
            Write-Host ("Skipping...")
        }
        if (-not (Get-Module -ListAvailable -Name Web-Mgmt-Service)) {
            Install-WindowsFeature Web-Mgmt-Service
        } 
        else {
            Write-Host "WindowsFeatures Web-Mgmt-Service is already installed."
            Write-Host ("Skipping...")
        }
        if (-not (Get-Module -ListAvailable -Name IIS-WindowsAuthentication)) {
            Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication
        }
        else {
            Write-Host "WindowsFeatures IIS-WindowsAuthentication is already installed."
            Write-Host ("Skipping...")
        }
    }
    catch {
        Write-Error ("WindowsFeatures AD-Domain-Services, RSAT-AD-AdminCenter & RSAT-ADDS-Tools could not be installed.")
    }
    #endregion
}