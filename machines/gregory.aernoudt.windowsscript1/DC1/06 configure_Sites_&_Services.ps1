#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will configure DNS inside Active Directory.
#>

############ GLOBAL VARIABLES ############
[String[]]$sites = "Kortrijk", "Brugge"
[String[]]$subnets = "192.168.1.0/24", "192.168.2.0/24"

############ CONFIGURE SITES & SERVICES ############
#region configures sites & services
# Add's the Active Directory Site
foreach ($site in $sites) 
{
    try 
    {
        if ( Get-ADReplicationSite -Filter 'Name -like Default-First-Site-Name')
        {
            Get-ADReplicationSite -Filter 'Name -like Default-First-Site-Name' | Rename-ADObject -NewName $site
        }
        # rename Default-First-Site-Name
        if (-not ( Get-ADReplicationSite -Filter 'Name -like '$site)) 
        {
            New-ADReplicationSite -Name $site
        }
        else 
        {
            Write-Host "Site $site already exist. Skipping..."    
        }
        # Add's the Active Directory Subnet and add it tothe Site
        foreach ($subnet in $subnets ) 
        {
            try 
            {
                if (-not (Get-ADReplicationSubnet -Filter 'Name -like '$subnet)) 
                {
                    New-ADReplicationSubnet -Name $subnet -Site $site
                }
                else 
                {
                    Write-Host "Subnet $subnet already exist. Skipping..."    
                }
            }
            catch {
                Write-Error "Subnet $subnet could not be created. Ending script."
                Exit
            }
        }
    }
    catch 
    {
        Write-Error "Site $site & $subnet could not be created. Ending script."
        Exit
    }
}
#endregion