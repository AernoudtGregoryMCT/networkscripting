#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will configure DNS inside Active Directory.
#>

############ GLOBAL VARIABLES ############
[String[]]$globalDNSServers = "172.20.0.2", "172.20.0.3"
$NetworkID = "192.168.1.0/24"
$reverseZoneName = "1.168.192." + "in-addr.arpa"

############ CONFIGURE DNS SERVER ############
#region configure DNS server and reverse DNS
# Add's the forwarding DNS servers
foreach ($DNSServer in $globalDNSServers) {
    Set-DnsServerForwarder -IPAddress $DNSServer -PassThru
}

# register the server in DNS server
Register-DnsClient

# Creates the reverse zone
try {
    if (-not (Get-DnsServerZone -Name $reverseZoneName)) {
        Add-DnsServerPrimaryZone -NetworkID $NetworkID -ReplicationScope "Domain" -DynamicUpdate Secure
    }
    else {
        Write-Host "Reverse DNS zone $reverseZoneName already exists."    
    }
}
catch {
    Write-Error "Zone $reverseZoneName could not be created!"
    Read-Host "Press any key to exit..."
    exit
}
#endregion