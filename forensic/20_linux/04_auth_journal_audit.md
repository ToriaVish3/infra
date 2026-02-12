# Auth, Journal, Auditd: Detailed Investigation

## Auth logs

### Debian/Ubuntu/Kali
```bash
sudo grep -Ei 'failed|invalid user|accepted|sudo|session opened|session closed' /var/log/auth.log | tail -n 500
sudo zgrep -Ei 'failed|invalid user|accepted|sudo' /var/log/auth.log* 2>/dev/null | tail -n 500
```

### RHEL-family
```bash
sudo grep -Ei 'failed|invalid user|accepted|sudo|session opened|session closed' /var/log/secure | tail -n 500
sudo zgrep -Ei 'failed|invalid user|accepted|sudo' /var/log/secure* 2>/dev/null | tail -n 500
```

## Journalctl usage

Useful filters:
- `-u <unit>` by service
- `--since/--until` time window
- `-p` by priority
- `-k` kernel messages only
- `-b` current boot

Commands:
```bash
sudo journalctl -n 500 --no-pager
sudo journalctl --since '2026-02-12 00:00:00' --until '2026-02-12 23:59:59' --no-pager
sudo journalctl -u ssh --since '-24h' --no-pager
sudo journalctl -p err..alert --since '-24h' --no-pager
sudo journalctl -k -b --no-pager | tail -n 200
```

## Auditd (if enabled)

Check service and config:
```bash
systemctl status auditd --no-pager
sudo cat /etc/audit/auditd.conf
sudo cat /etc/audit/rules.d/*.rules 2>/dev/null
```

Query examples:
```bash
sudo ausearch -ts recent -m USER_LOGIN,USER_AUTH,CRED_ACQ
sudo ausearch -k privileged -ts recent
sudo aureport -au
sudo aureport -x --summary
```

## Correlation tip
- Match auth success in `auth.log`/`secure` with subsequent `sudo`, process start, and outbound network.
