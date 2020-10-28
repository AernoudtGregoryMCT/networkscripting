#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will configure a static IP on a wired NIC.
    DO NOT RUN THIS REMOTLY, BUT ON THE SYSTEM ITSELF!
#>

############ GLOBAL VARIABLES ############
$hostnameMS = "192.168.1.4"
$prefixLength = 24
$defaultGateway = "192.168.1.1"
[String[]]$domainDNSServers = "192.168.1.2", "192.168.1.3"

############ CONFIGURE STATIC IP ############
#region static IP configuration
$eth0 = Get-NetAdapter -Physical | Where-Object { $_.PhysicalMediaType -match "802.3" -and $_.status -eq "up" }
if (!$eth0) {
    write-host("")
    write-host("No connected ethernet interface found ! Please connect cable ...")
}
$eth0_ip = Get-NetIPInterface -InterfaceIndex $eth0.ifIndex -AddressFamily IPv4

if ($eth0_ip.dhcp) {
    # DHCP enabled → disable DHCP
    $eth0 | Set-NetIPInterface -DHCP Disabled
    # Configure static IP on network interface
    $eth0 | New-NetIPAddress -AddressFamily IPv4 -IPAddress $hostnameMS -PrefixLength $prefixLength -Type Unicast -DefaultGateway $defaultGateway | Out-Null  
    # Set DNS server
    $eth0 | Set-DnsClientServerAddress -ServerAddresses ($domainDNSServers)
}
#endregion