#!/usr/bin/env bash
# Linux Live Response Commands

# Host and process triage
who; w; last -n 20
ps aux --sort=-%cpu | head -n 30
ss -tulpen

# Startup and persistence triage
systemctl list-unit-files --type=service | grep enabled
crontab -l
sudo ls -la /etc/cron.* /var/spool/cron 2>/dev/null

# Log triage
sudo journalctl -n 300 --no-pager
sudo grep -Ei "failed|invalid user|accepted|sudo|session" /var/log/auth.log 2>/dev/null | tail -n 200
