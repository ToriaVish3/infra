# Astra Linux Forensics: Platform-Specific Checks

## Why Astra is different
Astra Linux Special Edition includes PARSEC mechanisms (mandatory controls and integrity model), so Linux triage must include label/integrity checks.

## 1) Identify edition and mode
```bash
cat /etc/os-release
uname -a
```

## 2) Check integrity/mandatory control state
```bash
sudo astra-mic-control status
sudo pdpl-user $(whoami)
```

## 3) Inspect labels on critical objects
```bash
sudo pdpl-file /etc
sudo pdpl-file /etc/ssh
sudo pdpl-file /var/log
sudo pdpl-file /home
```

## 4) Inspect user privileges (Linux + PARSEC)
```bash
usercaps -M
usercaps $(whoami)
usercaps -M $(whoami)
usercaps -L $(whoami)
```

## 5) Group and admin model specifics
Astra often uses `astra-admin` group for admin rights in integrated policies.
```bash
id
getent group astra-admin
getent group sudo
getent group wheel
```

## 6) Standard Linux checks still mandatory
```bash
sudo journalctl -n 300 --no-pager
sudo grep -Ei 'failed|invalid user|accepted|sudo|session' /var/log/auth.log 2>/dev/null | tail -n 300
ps aux --sort=-%cpu | head -n 40
ss -tulpen
```

## 7) Investigative focus in Astra incidents
- Account has too-high integrity level unexpectedly.
- Suspicious changes in label/integrity policies.
- Non-standard PARSEC privileges for service/user accounts.
- Traditional persistence (cron/systemd/ssh) combined with label bypass attempts.

## Notes
Command availability depends on installed edition/profile. If a PARSEC utility is missing, record it and continue with standard Linux triage.
