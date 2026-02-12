# Astra Linux Detailed IR Plan (Step-by-Step)

## Phase 0: Evidence safety
1. Start session logging:
```bash
script -a astra_ir_session.log
```
2. Record host and time:
```bash
date -u
timedatectl
hostnamectl
uname -a
cat /etc/os-release
```
3. Create working structure:
```bash
mkdir -p case/{notes,logs,exports,hashes}
```

## Phase 1: Triage identity and control model
1. Current user and groups:
```bash
id
whoami
groups
```
2. Check Astra integrity/mandatory state:
```bash
sudo astra-mic-control status
sudo pdpl-user $(whoami)
```
3. Enumerate PARSEC privilege context:
```bash
usercaps -M
usercaps $(whoami)
usercaps -M $(whoami)
usercaps -L $(whoami)
```

What to look at:
- Integrity level unexpectedly high for ordinary account.
- Additional PARSEC privileges not justified by role.

## Phase 2: Authentication timeline
1. Interactive activity:
```bash
who
w
last -a | head -n 100
lastb -a | head -n 100
```
2. Auth logs:
```bash
sudo grep -Ei 'failed|invalid user|accepted|sudo|session opened|session closed' /var/log/auth.log 2>/dev/null | tail -n 500
sudo grep -Ei 'failed|invalid user|accepted|sudo|session opened|session closed' /var/log/secure 2>/dev/null | tail -n 500
sudo journalctl -u ssh --since '-24h' --no-pager
```

What to look at:
- Brute-force then successful login.
- New source IP followed by privilege escalation.

## Phase 3: Process and network triage
```bash
ps aux --sort=-%cpu | head -n 60
ps aux --sort=-%mem | head -n 60
pstree -ap | head -n 200
ss -tulpen
ss -tpn
lsof -i -P -n | head -n 200
```

What to look at:
- Suspicious parent-child chains.
- Unknown binaries from `/tmp`, `/dev/shm`, user home.
- Outbound connections to uncommon IP/ports.

## Phase 4: Persistence and execution
1. SSH persistence:
```bash
sudo grep -Ei 'PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|AuthorizedKeysFile|AllowUsers|AllowGroups' /etc/ssh/sshd_config
sudo find /home /root -type f -name authorized_keys -exec ls -la {} \; 2>/dev/null
sudo find /home /root -type f -name authorized_keys -exec cat {} \; 2>/dev/null
```
2. Cron/systemd persistence:
```bash
crontab -l || true
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /var/spool/cron 2>/dev/null
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled
sudo grep -RinE 'curl|wget|nc |bash -c|python -c|/tmp/' /etc/cron* /etc/systemd/system /usr/lib/systemd/system 2>/dev/null
```
3. Startup/profile scripts:
```bash
sudo grep -RinE 'curl|wget|bash -c|python -c|nc |/tmp/' /etc/profile /etc/profile.d /home/*/.bashrc /home/*/.profile /root/.bashrc /root/.profile 2>/dev/null
```

## Phase 5: Filesystem and privilege escalation artifacts
1. Hot paths:
```bash
sudo find /tmp /var/tmp /dev/shm -type f -mmin -720 2>/dev/null
sudo find /opt /usr/local/bin /usr/local/sbin -type f -mtime -7 2>/dev/null
```
2. Privileged binary checks:
```bash
sudo find / -xdev -perm -4000 -type f 2>/dev/null
sudo find / -xdev -perm -2000 -type f 2>/dev/null
sudo getcap -r / 2>/dev/null
sudo cat /etc/sudoers
sudo ls -la /etc/sudoers.d
```

What to look at:
- Newly introduced SUID binaries.
- Dangerous capabilities (`cap_setuid`, `cap_sys_admin`).
- Weak sudo rules (`NOPASSWD`, wildcard misuse).

## Phase 6: Astra-specific label checks
1. Label status on critical dirs/files:
```bash
sudo pdpl-file /etc
sudo pdpl-file /etc/ssh
sudo pdpl-file /var/log
sudo pdpl-file /home
sudo pdpl-file /root
```
2. User label checks for key accounts:
```bash
sudo pdpl-user root
sudo pdpl-user <suspected_user>
```

What to look at:
- Label/integrity mismatches with expected policy.
- Unexpected high integrity grants enabling sensitive operations.

## Phase 7: Build timeline and report
1. Timeline export:
```bash
sudo find /home /root /tmp /var/tmp -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %s %p\n' | sort > case/exports/files_timeline.txt
```
2. Save IOC material:
```bash
sudo grep -RinE 'flag\{|thm\{|ctf\{' /home /root /opt /var/www 2>/dev/null | tee case/exports/flag_hits.txt
```
3. Hash suspicious files:
```bash
sha256sum /path/to/suspicious1 /path/to/suspicious2 2>/dev/null | tee case/hashes/suspicious.sha256
```

## Phase 8: Final validation before submit
- Each conclusion backed by at least two artifacts.
- Timezone confirmed.
- Command transcript preserved (`astra_ir_session.log`).
- For Astra-specific findings, include integrity/label output snippets.
