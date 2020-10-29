#SCRIPT EXECUTION
#USAGE OF THIS SCRIPT
<#
    This script will create a hidden profile share.
#>
############ GLOBAL VARIABLES ############
$computer = "DC2"

Invoke-Command -Computer $computer -ScriptBlock {
    ############ GLOBAL VARIABLES ############
    $masterPath = "C:\#SMB-Shares\"
    $profileShare = "Profile"
    $profileShareName = 'Profile$'
    $profilePath = $masterPath + $profileShare
    ############ CREATE PUBLIC SHARE WITH NTFS RIGHTS ############
    # region profileShare
    try {
        # If the folder is not created, create it
        if (-not (Test-Path -LiteralPath $profilePath )) {
            New-Item $profilePath -Type Directory -Force
        }
        # Creating the share
        New-SmbShare -Name $profileShareName -Path $profilePath -FullAccess everyone -ErrorAction SilentlyContinue
                
        $acl = Get-Acl $profilePath
        $rule0 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
        $acl.AddAccessRule($rule0)
            
        $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","Modify", "None", "NoPropagateInherit", "Allow")
        $acl.AddAccessRule($rule1)
        
        Set-Acl $profilePath $acl
    }
    catch {
        Write-Host "Creating $profileShare was unsucessful."
    }   
    # endregion 
}