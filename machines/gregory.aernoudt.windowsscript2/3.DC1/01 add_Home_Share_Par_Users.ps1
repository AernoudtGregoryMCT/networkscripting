#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will create add a Home Share for the previous created Users inside Active Directory.
#>
############ GLOBAL VARIABLES ############
$users = Import-Csv -Path "C:\Users\Administrator\Downloads\intranet.mijnschool.be\UserAccounts.csv" -Delimiter ";"
$homedrive = "H"
$homeDirectory = "\\MS\Homes"

############ UPDATE USERS ############
#region UPDATE AD users
foreach ($user in $users) {
    try {
        Set-ADUser -Identity $user.SamAccountName -HomeDrive $homedrive -HomeDirectory $homeDirectory
    }
    catch {
        Write-Host "User "$user.Name"'s homeshare could not be added."
        Write-Host "Not creating this, skip to other user."
    }
}
#endregion