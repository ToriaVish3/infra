#!/usr/bin/env bash
set -euo pipefail

date -u
hostname
id

who
w
last -n 20

ps aux --sort=-%cpu | head -n 30
ss -tulpen
lsof -i -P -n | head -n 100

crontab -l || true
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /var/spool/cron 2>/dev/null || true
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled || true

sudo journalctl -n 300 --no-pager
sudo grep -Ei "failed|invalid user|accepted|sudo|session" /var/log/auth.log 2>/dev/null | tail -n 200 || true
