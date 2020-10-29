#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will create a master directory for all shares, and create a directory Home that will be shared in the domain.
#>
############ GLOBAL VARIABLES ############
$computer = "DC2"

Invoke-Command -Computer $computer -ScriptBlock {
     ############ GLOBAL VARIABLES ############
    $hostnameDC2 = "DC2"
    $domainName = "intranet.mijnschool.be"
    $IPAddressDC2 = "192.168.1.3"
    [String[]]$domainDNSServers = "192.168.1.3", "192.168.1.2"
    ############ INSTALL, CONFIGURE & CREATE SECOND DHCP SERVER ############
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
    # Register DHCP in AD
    Add-DhcpServerInDC -DnsName "$hostnameDC2.$domainName" -IPAddress $IPAddressDC2
}
$hostnameDC1 = "DC1"
$hostnameDC2 = "DC2"
$domainName = "intranet.mijnschool.be"
$scopeId = "192.168.1.0"
$sharedDHCPSecret = "Pa$$sW0rd123"

# Configure DHCP failover from DC1 to DC2
try {
    Add-DhcpServerv4Failover -ComputerName "$hostnameDC1.$domainName" -Name "DefaultDHCPFailover" -PartnerServer "$hostnameDC2.$domainName" -ScopeId $scopeId -LoadBalancePercent 50 -MaxClientLeadTime 01:00:00 -AutoStateTransition $False -SharedSecret $sharedDHCPSecret
}
catch {
    Write-Error "Unable to create DHCP-failover"
}