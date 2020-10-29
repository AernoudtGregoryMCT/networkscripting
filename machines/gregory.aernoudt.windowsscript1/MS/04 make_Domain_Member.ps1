#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will register this server as member of the Active Directory Domain.
#>
############ GLOBAL VARIABLES ############
$computer = "192.168.1.4"
$credential = "Administrator"

Invoke-Command -Computer $computer -Credential (Get-Credential $credential) -ScriptBlock { 
    ############ GLOBAL VARIABLES ############
    $domainName = "intranet.mijnschool.be"
    $domainCredentials = "INTRANET\Administrator"

    ############ BECOME MEMBER OF DOMAIN ############
    add-computer –domainname $domainName -restart -Credential(Get-Credential $domainCredentials)
}