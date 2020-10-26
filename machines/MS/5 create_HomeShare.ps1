#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will create a master directory for all shares, and create a directory Home that will be shared in the domain.
#>
############ GLOBAL VARIABLES ############
$computer = "MS"

Invoke-Command -Computer $computer -ScriptBlock { 
    ############ CREATE HOME SHARE WITH NTFS RIGHTS ############
    # region homeshare
    $masterPath = "C:\#SMB-Shares\"
    $homeShare = "Homes"
    $homePath = $masterPath + $homeShare
    # Check if the MasterPath is created, if not create it
    try {
        if (-not (Test-Path -LiteralPath $homePath )) {
            New-Item $MasterPath -Type Directory -Force
        }
    }
    catch {
        Write-Host "Folder $MasterPath already exists. Skipping..."
    }
    # Create the folder, create share and set permissions
    try {
        # If the folder is not created, create it
        if (-not (Test-Path -LiteralPath $homePath )) {
            New-Item $homePath -Type Directory -Force
        }
        # Creating the share
        New-SmbShare -Name $homeShare -Path $homePath -FullAccess everyone -ErrorAction SilentlyContinue
                
        $acl = Get-Acl $homePath
        $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
        $acl.AddAccessRule($rule1)
        
        $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","ReadAndExecute", "None", "NoPropagateInherit", "Allow")
        $acl.AddAccessRule($rule2)
        
        Set-Acl $homePath $acl
    }
    catch {
        Write-Host "Creating $homeShare was unsucessful."
    }
}