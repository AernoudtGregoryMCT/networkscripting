# documentation in comment!


# Check if UPN suffixes exists or empty?
Get-ADForest | Format-List UPNSuffixes

Get-ADForest

Get-ADForest | Set-ADForest -UPNSuffixes @{add="mijnschool.be"}
Get-ADForest | Format-List UPNSuffixes
