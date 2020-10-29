#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will install & configure the DHCP Server.
#>

############ GLOBAL VARIABLES ############
$scopeName = "Subnet Kortrijk"
$scopeId = "192.168.1.0"
$startRange = "192.168.1.1"
$endRange = "192.168.1.254"
$subnetMask = "255.255.255.0"
$startRangeExclusions = "192.168.1.1"
$endRangeExclusions = "192.168.1.11"
$sharedDHCPSecret = "P@ssw0rd"
$dhcpReservationIP = "192.168.1.254"
$dhcpReservationMAC = "b8-e9-37-3e-55-86"
$defaultGateway = "192.168.1.1"
[String[]]$domainDNSServers = "192.168.1.2", "192.168.1.3"
$domainName = "intranet.mijnschool.be"

############ INSTALL, CONFIGURE & CREATE DHCP SERVER ############
# region
# Verify if DHCPServer role is installed. If not, install it.
try {
    if (-not (Get-Module -ListAvailable -Name DHCP)) {  
        Install-WindowsFeature -Name DHCP –IncludeManagementTools
        
    }
    else {
        Write-Host "DHCP-server role already installed. Skipping..."
    }
}
catch {
    Write-Error "Could not install the DHCP-server role. Stop execution of this script."
    Read-Host "Press any key to exit..."
    exit
}
# Import the DHCPServer module
try {
    Import-Module DhcpServer
}
catch {
    Write-Error "The DHCPServer module could not be imported".
    Read-Host "Press any key to exit..."
    exit
}
# Configure DHCP-server options
try {
    if (-not (Get-DhcpServerv4OptionValue -OptionId 6)) {
        Set-DHCPServerv4OptionValue -DnsServer $domainDNSServers[0], $domainDNSServers[1] -Force
    }    
    else {
        Write-Host "DHCP option 6, DnsServer already set. Skipping..."
    }
    if (-not (Get-DhcpServerv4OptionValue -OptionId 15)) {
        Set-DHCPServerv4OptionValue -DnsDomain $domainName -Force
    }    
    else {
        Write-Host "DHCP option 15, DnsDomain already set. Skipping..."
    }
}
catch {
    Write-Host "Unable to set DHCP server options"
}
# Create DHCP scope + add exclusions
try {
    if (-not (Get-DhcpServerv4Scope -ScopeId $scopeId)) {
        Add-DhcpServerv4Scope -name $scopeName -StartRange $startRange -EndRange $endRange -SubnetMask $subnetMask -State Active
        Set-DHCPServerv4OptionValue -ScopeId $scopeId -Router $endRange
        Add-Dhcpserverv4ExclusionRange -ScopeId $scopeId -StartRange $startRangeExclusions -EndRange $endRangeExclusions
    }
    else {
        Write-Host "DHCP scope with name $scopeName and scopeId $scopeId already exists."
    }
}
catch {
    Write-Error "Unable to create DHCP scope with name $scopeName and scopeId $scopeId"
}
# DHCP server reservation
Add-DhcpServerv4Reservation -ScopeId $scopeId -IPAddress $dhcpReservationIP -ClientId $dhcpReservationMAC -Description "Reservation for Printer"
# Register DHCP in AD
Add-DhcpServerInDC -DnsName "$hostnameDC1.$domainName" -IPAddress $IPAddressDC1
# endregion

############ CREATE OU's ############
#region Create OU structure
foreach ($ou in $ouS) {
    try {
        New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path -DisplayName $ou.DisplayName -Description $ou.Description -ProtectedFromAccidentalDeletion $True
    }
    catch {
        Write-Host "OU "$ou.Name" already exists." 
        Write-Host "Not creating this OU, skip to the next OU."
    }
}
# endregion