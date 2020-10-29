#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will add the Users in to the Security Groups inside Active Directory.
#>
############ GLOBAL VARIABLES ############
$groupMembers = Import-Csv -Path "C:\Users\Administrator\Downloads\intranet.mijnschool.be\GroupMembers.csv" -Delimiter ";"

############ GROUPMEMBERS ############
#region ad AD users to groups
foreach ($groupMember in $groupMembers) {
    try {
        Add-ADGroupMember -Identity $groupMember.Identity -Members $groupMember.Member
    }
    catch {
        Write-Host "User $user already exists."
        Write-Host "Not creating this, skip to other user."
    }
}
#endregion