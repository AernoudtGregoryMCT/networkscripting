#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will configure a additional UPN suffix.
#>

############ GLOBAL VARIABLES ############
$UPNSuffix = "mijnschool.be"

############ UPN Suffix ############
#region Create UPNSuffix
Get-ADForest | Set-ADForest -UPNSuffixes @{add = "$UPNSuffix" }
#endregion