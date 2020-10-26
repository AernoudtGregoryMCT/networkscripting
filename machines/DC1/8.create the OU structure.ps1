# documentation in comment!
##https://docs.microsoft.com/en-us/powershell/module/addsadministration/new-adorganizationalunit?view=win10-ps#examples

#!!! Aanpassen OUs.csv:  DC=intranet,DC=mijnschool,DC=be
##https://docs.microsoft.com/en-us/sysinternals/downloads/adexplorer


#This script will create the OU structure inside Active Directory.
        ############ GLOBAL VARIABLES ############

#OU-structure 
    $ouS = Import-Csv -Path "C:\Users\Administrator\Downloads\intranet.mijnschool.be\OUs.csv" -Delimiter ";"


        ############ CREATE OU's ############

#region Create OU structure
foreach ($ou in $ouS) {
   
        New-ADOrganizationalUnit -Path $ou.Path -Name $ou.Name -DisplayName $ou.DisplayName -Description $ou.Description -ProtectedFromAccidentalDeletion $True -Verbose
    
}
# endregion

