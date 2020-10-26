#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will create the Security Groups inside Active Directory.
#>
############ GLOBAL VARIABLES ############
$groups = Import-Csv -Path "C:\Users\Administrator\Downloads\intranet.mijnschool.be\Groups.csv" -Delimiter ";"

############ CREATE SECURITY GROUPS ############
# region Create security groups
foreach ($group in $groups) {

        New-AdGroup -Name $group.Name -Path $group.Path -DisplayName $group.DisplayName -GroupScope $group.GroupScope -GroupCategory $group.GroupCategory
    

}
# endregion