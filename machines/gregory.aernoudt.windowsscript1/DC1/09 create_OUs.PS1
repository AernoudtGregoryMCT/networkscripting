#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will create the OU structure inside Active Directory.
#>
############ GLOBAL VARIABLES ############
# OU-structure 
    $ouS = Import-Csv -Path "C:\Users\Administrator\Downloads\intranet.mijnschool.be\OUs.csv" -Delimiter ";"

############ CREATE OU's ############
#region Create OU structure
foreach ($ou in $ouS) {
    try {
        New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path -DisplayName $ou.DisplayName -Description $ou.Description -ProtectedFromAccidentalDeletion $True
    }
    catch {
        Write-Host "OU "$ou.Name" already exists." 
        Write-Host "Not creating this OU, skip to the next OU."
    }
}
# endregion