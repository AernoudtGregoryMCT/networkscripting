#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will register this server inside the DNS server.
#>

# Een remote poweshell sessie uitvoeren om daarop volgende commando's uit te voeren.
Enter-PSSession -ComputerName 192.168.1.3 -Credential (Get-Credential "intranet.mijnschool.be\administrator") # IP-address aan te passen volgens machines

############ GLOBAL VARIABLES ############
$computer = "192.168.1.3"
$credential = "intranet.mijnschool.be\administrator"

Invoke-Command -Computer $computer -Credential (Get-Credential $credential) -ScriptBlock { 
    # register the server in DNS server
    Register-DnsClient
}