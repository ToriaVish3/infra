# Linux CTF Checklist (Command-Driven)

## 1) Host baseline
```bash
date -u
hostname
uname -a
cat /etc/os-release
```

## 2) Login and auth
```bash
who
w
last -a | head -n 50
lastb -a | head -n 50
sudo grep -Ei 'failed|invalid user|accepted|sudo|session' /var/log/auth.log 2>/dev/null | tail -n 300
sudo grep -Ei 'failed|invalid user|accepted|sudo|session' /var/log/secure 2>/dev/null | tail -n 300
```

## 3) Processes and network
```bash
ps aux --sort=-%cpu | head -n 40
pstree -ap | head -n 120
ss -tulpen
lsof -i -P -n | head -n 120
```

## 4) Persistence
```bash
crontab -l || true
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /var/spool/cron 2>/dev/null
systemctl list-unit-files --type=service | grep enabled
systemctl list-timers --all
```

## 5) Privilege escalation traces
```bash
sudo find / -xdev -perm -4000 -type f 2>/dev/null
sudo getcap -r / 2>/dev/null
sudo cat /etc/sudoers
sudo ls -la /etc/sudoers.d
```

## 6) File and flag hunt
```bash
sudo find /tmp /var/tmp /dev/shm -type f -mmin -360 2>/dev/null
sudo grep -RinE 'flag\{|thm\{|ctf\{' /home /root /opt /var/www 2>/dev/null | head -n 200
```

## 7) Final validation
- Answer is backed by at least 2 independent artifacts.
- Timezone/time window confirmed.
- Command output saved for replay.
