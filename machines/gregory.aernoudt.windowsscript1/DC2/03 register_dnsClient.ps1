#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will register this server inside the DNS server.
#>




############ GLOBAL VARIABLES ############
$computer = "192.168.1.3"
$credential = "Administrator"

# Een remote poweshell sessie uitvoeren om daarop volgende commando's uit te voeren.
Enter-PSSession -ComputerName $computer -Credential (Get-Credential $credential) # IP-address aan te passen volgens machines

Invoke-Command -Computer $computer -Credential (Get-Credential $credential) -ScriptBlock { 
    # register the server in DNS server
    Register-DnsClient
}