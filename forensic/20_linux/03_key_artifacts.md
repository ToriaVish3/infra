# 03_key_artifacts

## Steps
1. Review auth and interactive activity.
2. Check persistence and privileged binaries.
3. Build quick timeline from logs/files.

## Commands
```bash
date -u
who; w; last -n 20
ps aux --sort=-%cpu | head -n 20
ss -tulpen
sudo journalctl -n 200 --no-pager
sudo find / -xdev -perm -4000 -type f 2>/dev/null
sudo getcap -r / 2>/dev/null
```
