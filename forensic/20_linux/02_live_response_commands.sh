#!/usr/bin/env bash
set -euo pipefail

# Linux live triage (read-mostly)

echo "== Time/System =="
date -u
timedatectl || true
hostname
hostnamectl || true
uname -a
cat /etc/os-release

echo "== Users/Auth =="
id
who
w
last -a | head -n 40
lastb -a | head -n 40 || true

# Account and privilege checks
getent passwd | head -n 80
getent group | head -n 80
awk -F: '$3 == 0 {print}' /etc/passwd
sudo cat /etc/sudoers 2>/dev/null | sed -n '1,120p' || true
sudo ls -la /etc/sudoers.d 2>/dev/null || true

echo "== Processes/Network =="
ps aux --sort=-%cpu | head -n 40
ps aux --sort=-%mem | head -n 40
pstree -ap | head -n 120
ss -tulpen
ss -tpn
lsof -i -P -n | head -n 120
ip a
ip r
arp -an || true

echo "== Persistence =="
crontab -l || true
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /var/spool/cron 2>/dev/null || true
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled || true
sudo find /etc/systemd/system /usr/lib/systemd/system -type f -name '*.service' 2>/dev/null | head -n 200

echo "== SSH =="
sudo grep -Ei 'PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|AuthorizedKeysFile' /etc/ssh/sshd_config 2>/dev/null || true
sudo find /home /root -type f -name authorized_keys -exec ls -la {} \; 2>/dev/null || true

echo "== Logs =="
sudo journalctl -n 300 --no-pager
sudo journalctl -u ssh --since '-12h' --no-pager 2>/dev/null || true
sudo grep -Ei 'failed|invalid user|accepted|sudo|session opened|session closed' /var/log/auth.log 2>/dev/null | tail -n 300 || true
sudo grep -Ei 'failed|invalid user|accepted|sudo|session opened|session closed' /var/log/secure 2>/dev/null | tail -n 300 || true
sudo ausearch -ts recent -m USER_LOGIN,USER_AUTH,CRED_ACQ 2>/dev/null | tail -n 200 || true

echo "== Filesystem hotspots =="
sudo find /tmp /var/tmp /dev/shm -type f -mmin -360 2>/dev/null | head -n 300
sudo find /home /root -xdev -type f -mtime -2 2>/dev/null | head -n 300
sudo find / -xdev -perm -4000 -type f 2>/dev/null | head -n 300
sudo getcap -r / 2>/dev/null | head -n 300

echo "== Package history =="
sudo tail -n 200 /var/log/apt/history.log 2>/dev/null || true
sudo tail -n 200 /var/log/dpkg.log 2>/dev/null || true
sudo tail -n 200 /var/log/yum.log 2>/dev/null || true
sudo dnf history 2>/dev/null || true

echo "== Quick flag scan =="
sudo grep -RinE 'flag\{|thm\{|ctf\{' /home /root /opt /var/www 2>/dev/null | head -n 200 || true
