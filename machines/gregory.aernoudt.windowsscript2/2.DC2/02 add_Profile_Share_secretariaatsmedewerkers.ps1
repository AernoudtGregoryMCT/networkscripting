#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will give all the secretariaatsmedewerkers a Profile Share and a roaming profile.
#>
############ GLOBAL VARIABLES ############
$OUpath = 'ou=Secretariaat,ou=Mijn School,dc=intranet,dc=mijnschool,dc=be'
$profileShare = "\\DC2\Profile$\"

# Get all the ADUsers inside the OU Secretariaat
$users = Get-ADUser -Filter * -SearchBase $OUpath | Select-object DistinguishedName,Name,UserPrincipalName 

# Create a profile share for each ADUser inside the OU Secretariaat and assign it to the ADUser object
foreach ($user in $users)
{
    $profilePath = $profileShare + $user.Name + ".V6"
    New-Item -Path $profilePath -ItemType Directory
    Set-ADUser -Identity $user.Name -ProfilePath $profilePath
}