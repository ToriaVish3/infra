# 10_windows_ctf_checklist

## Steps
1. Run host baseline commands.
2. Extract high-value artifacts.
3. Correlate events around incident time.

## Commands
```powershell
Get-Date
hostname
whoami
Get-Process | Sort-Object CPU -Descending | Select-Object -First 20
Get-NetTCPConnection
Get-WinEvent -LogName Security -MaxEvents 200
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 200
```
