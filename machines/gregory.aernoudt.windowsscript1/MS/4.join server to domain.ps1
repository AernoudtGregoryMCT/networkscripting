# documentation in comment!

#set ipadres + static
    #New-NetIPAddress -InterfaceIndex 6 -IPAddress 192.168.1.4 -PrefixLength 24 -DefaultGateway 192.168.1.1

#region -Name Computer RUN ON DC1

    #Rename-Computer -NewName MS
    #Restart-Computer

#endregion

#Remote PS sessie
    Enter-PSSession -ComputerName 192.168.1.4 -Credential (Get-Credential "intranet.mijnschool.be\administrator") # IP-address aan te passen volgens machines

# PartOfDomain (boolean Property) check
    (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain

# Workgroup (string Property)
#(Get-WmiObject -Class Win32_ComputerSystem).Workgroup
    Get-WmiObject -Class Win32_ComputerSystem

Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ("192.168.1.2","8.8.8.8")

Add-Computer -DomainName "intranet.mijnschool.be" -Credential (Get-Credential "intranet.mijnschool.be\Administrator") -PassThru -Verbose

Restart-Computer

# nu lid domain!
