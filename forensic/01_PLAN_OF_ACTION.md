# Forensics Plan of Action (Linux + Astra Linux)

## Track A: Generic Linux (competition mode)

### Step 1: Start and context
```bash
mkdir -p case && cd case
script -a session.log
date -u
timedatectl
hostnamectl
```

### Step 2: Auth and users
```bash
who
w
last -a | head -n 80
lastb -a | head -n 80
id
cat /etc/passwd
cat /etc/group
```

### Step 3: Process and network
```bash
ps aux --sort=-%cpu | head -n 50
pstree -ap | head -n 150
ss -tulpen
lsof -i -P -n | head -n 150
```

### Step 4: Persistence and escalation
```bash
crontab -l || true
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled
sudo find / -xdev -perm -4000 -type f 2>/dev/null
sudo getcap -r / 2>/dev/null
```

### Step 5: Logs and timeline
```bash
sudo journalctl -n 500 --no-pager
sudo grep -Ei 'failed|invalid user|accepted|sudo|session' /var/log/auth.log 2>/dev/null | tail -n 500
sudo find /home /root /tmp /var/tmp -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %p\n' | sort > timeline_files.txt
```

### Step 6: Flags and final answer
```bash
sudo grep -RinE 'flag\{|thm\{|ctf\{' /home /root /opt /var/www 2>/dev/null | head -n 200
```

## Track B: Astra Linux detailed extension

### Step 1: Verify Astra-specific security state
```bash
sudo astra-mic-control status
sudo pdpl-user $(whoami)
usercaps -M
usercaps $(whoami)
```

### Step 2: Mandatory label checks on critical paths
```bash
sudo pdpl-file /etc
sudo pdpl-file /etc/ssh
sudo pdpl-file /var/log
sudo pdpl-file /home
sudo pdpl-file /root
```

### Step 3: Compare user integrity and role expectation
```bash
id
groups
getent group astra-admin
sudo pdpl-user root
sudo pdpl-user <suspected_user>
```

### Step 4: Then run full generic Linux track
Use all commands from Track A and correlate with Astra labels/integrity outputs.

### Step 5: Reporting notes for Astra
Include:
- `astra-mic-control status`
- `pdpl-user` output for relevant accounts
- `pdpl-file` output for touched sensitive paths
- exact command and timestamp of each finding
