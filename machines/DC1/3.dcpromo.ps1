# documentation in comment!

#region - Timezone, Install AD ON DC1


#Set Timezone
    TZutil.exe /s "Romance Standard Time" 


#Install AD & DNS
    #install ADDS Role and (Mgt) LDS TOOLS
        Install-WindowsFeature AD-Domain-Services -IncludeManagementTools


    ##Import ADDSDeployment Module
        Import-Module ADDSDeployment


    ##Install a new AD Forest #Install-ADDSForest : which is used for creating a new Active Directory forest.
        Install-ADDSForest
            -CreateDnsDelegation:$false
            -DatabasePath "C:\Windows\NTDS"
            -DomainMode "7"
            -DomainName "intranet.mijnschool.be"
            -DomainNetbiosName "intranet.mijnschool"
            -ForestMode "7"
            -InstallDns:$true
            -LogPath "C:\Windows\NTDS"
            -NoRebootOnCompletion:$false
            -SysvolPath "C:\Windows\SYSVOL"
            -Force:$true
#endregion


 