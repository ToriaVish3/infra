# Windows live response commands
Get-Date
hostname
whoami

# Processes
Get-Process | Sort-Object CPU -Descending | Select-Object -First 30
Get-CimInstance Win32_Process | Select-Object ProcessId,ParentProcessId,Name,CommandLine

# Network
Get-NetTCPConnection | Sort-Object State,RemoteAddress,RemotePort
ipconfig /all
arp -a

# Persistence
Get-ScheduledTask | Select-Object TaskName,TaskPath,State
Get-CimInstance Win32_StartupCommand | Select-Object Name,Command,Location,User
Get-Service | Where-Object {$_.StartType -eq "Automatic"} | Select-Object Name,DisplayName,Status

# Logs
Get-WinEvent -LogName Security -MaxEvents 500
Get-WinEvent -LogName System -MaxEvents 500
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 500
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 500 -ErrorAction SilentlyContinue
