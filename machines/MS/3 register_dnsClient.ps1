#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will register this server inside the DNS server.
#>
############ GLOBAL VARIABLES ############
$computer = "192.168.1.4"
$credential = "intranet.mijnschool.be\administrator"

Invoke-Command -Computer $computer -Credential (Get-Credential $credential) -ScriptBlock { 
    # register the server in DNS server
    Register-DnsClient
}