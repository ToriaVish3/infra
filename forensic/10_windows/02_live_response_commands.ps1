# Windows Live Response Commands

# Process and network triage
Get-Process | Sort-Object CPU -Descending | Select-Object -First 30
Get-NetTCPConnection | Sort-Object State,RemotePort

# Persistence triage
Get-ScheduledTask | Select-Object TaskName,TaskPath,State
Get-CimInstance Win32_StartupCommand | Select-Object Name,Command,Location,User

# Logging and PowerShell traces
Get-WinEvent -LogName Security -MaxEvents 200
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 200
