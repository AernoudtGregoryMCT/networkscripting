# documentation in comment!



#Step1: Creating a new site
    ## DC’s niet in verschillende subnetten/sites anders = sync problemen
    ##https://docs.microsoft.com/en-us/powershell/module/activedirectory/new-adreplicationsite?view=winserver2012-ps
         New-ADReplicationSite -Name "KORTRIJK"
     

#Step2: Creating Subnets
    ##https://docs.microsoft.com/en-us/powershell/module/activedirectory/new-adreplicationsubnet?view=winserver2012-ps
        New-ADReplicationSubnet -Name "192.168.1.0/24" -Site "KORTRIJK"
       

#Step3: Creating Site Links
    ##https://docs.microsoft.com/en-us/powershell/module/activedirectory/new-adreplicationsitelink?view=winserver2012-ps#examples


#Step4: Moving the Domain controllers to the newly created sites
    ##https://docs.microsoft.com/en-us/powershell/module/addsadministration/move-addirectoryserver?view=win10-ps
        ###Move-ADDirectoryServer -Identity "DC1" -Site "KORTRIJK"



####This completes the configuration of sites, subnets and site links####