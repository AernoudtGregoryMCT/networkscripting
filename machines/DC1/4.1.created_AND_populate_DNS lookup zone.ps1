# documentation in comment!

#Check the current zones
    Get-DnsServerZone

#Geen DNS forwarders ingegeven TO DO!!!
    #TO DO

#Add a reverse DNS lookup zone
    Add-DnsServerPrimaryZone -NetworkID "192.168.1.0/24" -ReplicationScope Domain

#To confirm
    Get-DnsServerZone
        #This will should display the DNS zones again, with your new zone included

#Get the DNS records to display
    Get-DnsServerResourceRecord -ZoneName 1.168.192.in-addr.arpa