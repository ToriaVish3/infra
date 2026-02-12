# Linux Forensics Overview (CTF/IR)

## Goal
Быстро установить: кто, когда, откуда, что запускал, как закрепился, что изменил.

## Core Workflow
1. Time and scope.
2. Auth and user activity.
3. Process/network state.
4. Persistence.
5. File-system timeline.
6. Evidence correlation.

## Step 1: Time and scope
```bash
date -u
timedatectl
hostnamectl
uname -a
cat /etc/os-release
```

## Step 2: User and auth activity
```bash
who
w
last -a | head -n 50
lastb -a | head -n 50
id
cat /etc/passwd
cat /etc/group
```

## Step 3: Process and network
```bash
ps aux --sort=-%cpu | head -n 40
ps aux --sort=-%mem | head -n 40
pstree -ap
ss -tulpen
lsof -i -P -n | head -n 120
```

## Step 4: Persistence surfaces
```bash
crontab -l || true
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /var/spool/cron 2>/dev/null
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled
```

## Step 5: File-change hotspots
```bash
sudo find /tmp /var/tmp /dev/shm -type f -mmin -240 2>/dev/null
sudo find /home /root -xdev -type f -mtime -2 2>/dev/null | head -n 300
sudo find / -xdev -perm -4000 -type f 2>/dev/null
sudo getcap -r / 2>/dev/null
```

## Common high-value paths
- `/var/log/` (auth, syslog, audit)
- `/etc/ssh/`, `~/.ssh/`
- `/etc/cron*`, `/var/spool/cron`
- `/etc/systemd/system`, `/usr/lib/systemd/system`
- `/tmp`, `/var/tmp`, `/dev/shm`
- `/home/*`, `/root`
- `/opt`, `/usr/local/bin`, `/usr/local/sbin`, `/var/www`
