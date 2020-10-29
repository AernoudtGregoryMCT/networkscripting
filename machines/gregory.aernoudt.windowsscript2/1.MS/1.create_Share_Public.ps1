#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will create a master directory for all shares, and create a directory Public that will be shared in the domain.
#>
############ GLOBAL VARIABLES ############
$computer = "MS"

Invoke-Command -Computer $computer -ScriptBlock { 
    ############ GLOBAL VARIABLES ############
    $masterPath = "C:\#SMB-Shares\"
    $publicShare = "Public"
    $publicPath = $masterPath + $publicShare
    ############ CREATE PUBLIC SHARE WITH NTFS RIGHTS ############
    # region homeshare
    try {
        # If the folder is not created, create it
        if (-not (Test-Path -LiteralPath $publicPath )) {
            New-Item $publicPath -Type Directory -Force
        }
        # Creating the share
        New-SmbShare -Name $publicShare -Path $publicPath -FullAccess everyone -ErrorAction SilentlyContinue
                
        $acl = Get-Acl $publicPath
        $rule0 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
        $acl.AddAccessRule($rule0)
            
        $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","Modify", "None", "NoPropagateInherit", "Allow")
        $acl.AddAccessRule($rule1)
        
        Set-Acl $publicPath $acl
    }
    catch {
        Write-Host "Creating $publicShare was unsucessful."
    }    
    # endregion
}