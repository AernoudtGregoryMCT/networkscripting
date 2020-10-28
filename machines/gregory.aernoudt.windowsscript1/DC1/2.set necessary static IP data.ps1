#documentation in comment!

#checking the ip config
    Get-NetIPAddress

#change the ip to a specifiek static ip first
    New-NetIPAddress -IPAddress 192.168.1.2 -PrefixLength 24 -DefaultGateway 192.168.1.1 -InterfaceAlias Ethernet0
