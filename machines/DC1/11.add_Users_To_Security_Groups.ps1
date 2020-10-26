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
  
        Add-ADGroupMember -Identity $groupMember.Identity -Members $groupMember.Member
    

 
}
#endregion