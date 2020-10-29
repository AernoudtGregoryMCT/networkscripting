#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will create the Users inside Active Directory.
#>
############ GLOBAL VARIABLES ############
$users = Import-Csv -Path "C:\Users\Administrator\Downloads\intranet.mijnschool.be\UserAccounts.csv" -Delimiter ";"
############ CREATE USERS ############
#region create AD users
foreach ($user in $users) {
    try {
        New-ADUser -Name $user.Name -SamAccountName $user.SamAccountName -GivenName $user.GivenName -Surname $user.Surname -DisplayName $user.DisplayName -AccountPassword (ConvertTo-SecureString $user.AccountPassword -AsPlainText -Force) -HomeDrive $user.HomeDrive -HomeDirectory $user.HomeDirectory -ScriptPath $user.ScriptPath -Path $user.Path -ChangePasswordAtLogon $false -Enabled $True
    }
    catch {
        Write-Host "User "$user.Name" already exists."
        Write-Host "Not creating this, skip to other user."
    }
}
#endregion