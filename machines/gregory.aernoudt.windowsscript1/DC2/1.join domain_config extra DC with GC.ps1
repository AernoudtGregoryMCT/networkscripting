# documentation in comment!

#commands to remote computer
    ##https://docs.microsoft.com/en-us/powershell/module/addsdeployment/install-addsdomaincontroller?view=win10-ps#examples
    ##https://www.howtogeek.com/117192/how-to-run-powershell-commands-on-remote-computers/
    ##https://rdr-it.com/en/active-directory-add-a-domain-controller-to-powershell/
        

# Een remote poweshell sessie uitvoeren om daarop volgende commando's uit te voeren.
Enter-PSSession -ComputerName 192.168.1.3 -Credential (Get-Credential "intranet.mijnschool.be\administrator") # IP-address aan te passen volgens machines



#region - Timezone, Install AD ON DC2 and add to existing domain


    #Set Timezone
        TZutil.exe /s "Romance Standard Time" 


    #Install AD & DNS
        #install ADDS Role and (Mgt) LDS TOOLS
            Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
                #The AD DS role is now installed


    #Import ADDSDeployment Module
        Import-Module ADDSDeployment

        ipconfig /flushdns

    #Install-ADDSDomainController : which is used to add an Active Directory domain controller to an existing domain.
        Install-ADDSDomainController -DomainName "intranet.mijnschool.be" -InstallDns:$true -Credential (Get-Credential "administrator@intranet.mijnschool.be") -NoGlobalCatalog:$false -NoRebootOnCompletion:$false -Force:$true
            # DNS optie werd toegevoegd.
                    
    # Replication from DC1 test
        Get-ADReplicationPartnerMetadata -Target DC2



#endregion

# Nu hebben we een 2de domain controller die dezelfde active directory database beheren en replication voorziet.