# Linux Key Artifacts: Where to Look, What to Prove

## 1) Auth and login artifacts
- `/var/log/auth.log` (Debian/Ubuntu/Kali)
- `/var/log/secure` (RHEL-family)
- `journalctl`
- `/var/log/wtmp`, `/var/log/btmp`, `/var/log/lastlog`

What to prove:
- source IP, username, success/fail auth, sudo escalation window.

Commands:
```bash
sudo grep -Ei 'failed|invalid user|accepted|sudo|session' /var/log/auth.log 2>/dev/null | tail -n 300
sudo grep -Ei 'failed|invalid user|accepted|sudo|session' /var/log/secure 2>/dev/null | tail -n 300
last -a | head -n 80
lastb -a | head -n 80
```

## 2) SSH artifacts
- `/etc/ssh/sshd_config`
- `~/.ssh/authorized_keys`, `/root/.ssh/authorized_keys`
- `~/.ssh/known_hosts`

Commands:
```bash
sudo grep -Ei 'PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|AllowUsers|AllowGroups' /etc/ssh/sshd_config
sudo find /home /root -type f -name authorized_keys -exec ls -la {} \; 2>/dev/null
sudo find /home /root -type f -name known_hosts -exec ls -la {} \; 2>/dev/null
```

## 3) Persistence artifacts
- cron: `/etc/crontab`, `/etc/cron.*`, `/var/spool/cron`
- systemd: `/etc/systemd/system`, `/usr/lib/systemd/system`
- shell startup: `.bashrc`, `.profile`, `/etc/profile`, `/etc/profile.d/`

Commands:
```bash
crontab -l || true
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /var/spool/cron 2>/dev/null
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled
sudo grep -RinE 'bash -c|curl|wget|nc |python -c|/tmp/' /etc/systemd/system /usr/lib/systemd/system 2>/dev/null
```

## 4) Execution and filesystem traces
- temp folders: `/tmp`, `/var/tmp`, `/dev/shm`
- local bin paths: `/usr/local/bin`, `/usr/local/sbin`, `/opt`

Commands:
```bash
sudo find /tmp /var/tmp /dev/shm -type f -mmin -360 2>/dev/null
sudo find /usr/local/bin /usr/local/sbin /opt -type f -mtime -7 2>/dev/null
stat /path/to/suspicious_file
file /path/to/suspicious_file
sha256sum /path/to/suspicious_file
```

## 5) Privilege escalation artifacts
- SUID/SGID bits
- Linux capabilities
- sudoers misconfig

Commands:
```bash
sudo find / -xdev -perm -4000 -type f 2>/dev/null
sudo find / -xdev -perm -2000 -type f 2>/dev/null
sudo getcap -r / 2>/dev/null
sudo cat /etc/sudoers
sudo ls -la /etc/sudoers.d
```
