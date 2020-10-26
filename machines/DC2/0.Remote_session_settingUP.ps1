# Een remote poweshell sessie uitvoeren om daarop volgende commando's uit te voeren.
Enter-PSSession -ComputerName 192.168.1.3 -Credential (Get-Credential "intranet.mijnschool.be\administrator") # IP-address aan te passen volgens machines
