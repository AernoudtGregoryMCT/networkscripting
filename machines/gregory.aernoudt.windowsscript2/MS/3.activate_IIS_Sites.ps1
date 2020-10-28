#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will activate en configure IIS sites on the Member Server.
    This file requires 2 html files on the DC1 under C:\Websites!
#>
############ GLOBAL VARIABLES ############
$computer = "MS"
$DNSZone = "intranet.mijnschool.be"
$CNameSite1 = "www"
$CNameSite2 = "resto"
$hostNameAlias = "ms.intranet.mijnschool.be"
$localWebsitePath = "C:\Websites\"
$msWebsitePath = "\\MS\c$\Websites\"

# Create the CName records
Add-DnsServerResourceRecordCName -Name $CNameSite1 -HostNameAlias $hostNameAlias -ZoneName $DNSZone
Add-DnsServerResourceRecordCName -Name $CNameSite2 -HostNameAlias $hostNameAlias -ZoneName $DNSZone

Copy-Item -Recurse -Path $localWebsitePath -destination $msWebsitePath 

Invoke-Command -Computer $computer -ScriptBlock {
    ############ GLOBAL VARIABLES ############
    $site1Name = "IntranetMijnschool"
    $site1NamePool = "IntranetMijnschoolPool"
    $site1 = "www.intranet.mijnschool.be"
    $site2Name = "RestoIntranetMijnschool"
    $site2NamePool = "RestoIntranetMijnschoolPool"
    $site2 = "resto.intranet.mijnschool.be"
    $sitePath = "C:\Websites\"
    $site1Path = 'c:\Websites\' + $site1Name
    $site2Path = 'c:\Websites\' + $site2Name
    
    #region Configure ISS and create the sites
    Import-Module WebAdministration

    # Set the wmsvc services to automatic start
    Set-Service wmsvc -StartupType Automatic
    restart-service wmsvc

    # Copies the files under the correct path
    $acl = Get-Acl $sitePath
    $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule1)       
    Set-Acl $sitePath $acl

    try {
        Write-Host("Creating site $site1")        
        # Creates a new WebappPool
        New-WebappPool -name $site1NamePool
        # Create the $site1 under the WebappPool
        New-Website -name $site1Name -HostHeader $site1 -physicalPath $site1Path -ApplicationPool $site1NamePool
        # Disable Anonymous Authentication
        Set-WebConfigurationProperty –filter /system.webServer/security/authentication/AnonymousAuthentication –Name 'enabled' –value False –PSPath IIS:\ -location $site1Name/$site1NamePool  
        # Enable Windows Authentication
        Set-WebConfigurationProperty –filter /system.webServer/security/authentication/WindowsAuthentication –Name 'enabled' –value True –PSPath IIS:\ -location $site1Name/$site1NamePool
        Start-IISite $site1Name
        Write-Host("Site $site1 succesfully created.")
    }
    catch {
        Write-Host("Site $site1 could not be created.")        
    }
    
    try {
        Write-Host("Creating site $site2")
        # Creates a new WebappPool
        New-WebappPool -name $site2NamePool
        # Create the $site2 under the WebappPool
        New-Website -name $site2Name -HostHeader $site2 -physicalPath $site2Path -ApplicationPool $site2NamePool      
        # Disable Anonymous Authentication
        Set-WebConfigurationProperty –filter /system.webServer/security/authentication/AnonymousAuthentication –Name 'enabled' –value False –PSPath IIS:\ -location $site2Name/$site2NamePool  
        # Enable Windows Authentication
        Set-WebConfigurationProperty –filter /system.webServer/security/authentication/WindowsAuthentication –Name 'enabled' –value True –PSPath IIS:\ -location $site2Name/$site2NamePool
        Start-IISite $site2Name
        Write-Host("Site $site2 succesfully created.") 
    }
    catch {
        Write-Host("Site $site2 could not be created.")        
    }
    # endregion
}