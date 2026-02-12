# Plan of Action (with commands)

## 1. Start (first 3 minutes)
1. Create workspace and capture time.
```bash
mkdir -p case && cd case
date -u
```
2. Create tracking files.
```bash
touch findings.txt timeline.txt
```

## 2. Windows sequence
```powershell
Get-Date
hostname
whoami
Get-Process | Sort-Object CPU -Descending | Select-Object -First 30
Get-NetTCPConnection | Sort-Object State,RemotePort
Get-ScheduledTask | Select-Object TaskName,TaskPath,State
Get-CimInstance Win32_StartupCommand | Select-Object Name,Command,Location,User
Get-WinEvent -LogName Security -MaxEvents 500
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 500
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 500 -ErrorAction SilentlyContinue
```

## 3. Linux sequence
```bash
date -u
who; w; last -n 20
ps aux --sort=-%cpu | head -n 30
ss -tulpen
crontab -l
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled
sudo journalctl -n 300 --no-pager
sudo grep -Ei "failed|invalid user|accepted|sudo|session" /var/log/auth.log 2>/dev/null | tail -n 200
sudo find /tmp /var/tmp /dev/shm -type f -mmin -180 2>/dev/null
sudo find / -xdev -perm -4000 -type f 2>/dev/null
```

## 4. Memory sequence
```bash
python vol.py -f mem.raw windows.pslist
python vol.py -f mem.raw windows.pstree
python vol.py -f mem.raw windows.cmdline
python vol.py -f mem.raw windows.netscan
```

## 5. Final submit check
```bash
grep -RinE "flag\{|THM\{" . 2>/dev/null
```
- Confirm timezone.
- Confirm answer by at least two artifacts.
