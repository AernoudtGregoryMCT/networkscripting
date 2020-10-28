# documentation in comment!

##https://docs.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps
##https://docs.microsoft.com/en-us/powershell/module/dhcpserver/add-dhcpserverv4failover?view=win10-ps#examples

#1.Installs the DHCP-server role
#2.Creates a DHCP-server 
#3.Configures a DHCP failover  
        Install-WindowsFeature -Name DHCP -IncludeManagementTools

    #Import the DHCPServer module
         Import-Module DHCPServer 

    #Configure DHCP-server
    Set-DhcpServerv4OptionValue -DnsServer 192.168.1.2 -DnsDomain company.local -Force
    
    #DHCP-server Scopes #TIP: ComputerName toevoegen zodat je het commando remote kan uitvoeren naar een ander pc.

        Add-DhcpServerv4Scope -ComputerName "DC1" -name "Subnet Kortrijk" -StartRange 192.168.1.1 -EndRange 192.168.1.254 -SubnetMask 255.255.255.0 -State Active
   
        Set-DhcpServerv4OptionValue -ComputerName "DC1" -ScopeId 192.168.1.0 -Router 192.168.1.254

    #Sluit de eerste 10 adressen uit van het subnet
        Add-DhcpServerv4ExclusionRange -ComputerName "DC1" -ScopeId 192.168.1.0 -StartRange 192.168.1.1 -EndRange 192.168.1.10

    #Configure DHCP failover
        Add-DhcpServerv4Failover -ComputerName "DC1" -Name "DefaultDHCPFailover" -PartnerServer "DC2" -LoadBalancePercent 50 -MaxClientLeadTime 01:00:00 -AutoStateTransition $False -ScopeID 192.168.1.0 -SharedSecret "P@ssw0rd" 
    
    #Maak een reservation voor een printer met specifiek MAC adres:
        ##https://docs.microsoft.com/en-us/powershell/module/dhcpserver/add-dhcpserverv4reservation?view=win10-ps
        Add-DhcpServerv4Reservation -ScopeId 192.168.1.0 -IPAddress 192.168.1.128 -ClientId "b8-e9-37-3e-55-86" -Description "Reservation for Printer"

    # Register DHCP in AD
    Add-DhcpServerInDC -DnsName "DC1.intranet.mijnschool.be" -IPAddress 192.168.1.2