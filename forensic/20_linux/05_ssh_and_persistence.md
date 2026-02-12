# SSH and Persistence Forensics

## SSH configuration and abuse checks

Files:
- `/etc/ssh/sshd_config`
- `~/.ssh/authorized_keys`
- `~/.ssh/known_hosts`
- `/root/.ssh/*`

Commands:
```bash
sudo grep -Ei 'PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|AllowUsers|AllowGroups|AuthorizedKeysFile' /etc/ssh/sshd_config
sudo find /home /root -type f -name authorized_keys -exec ls -la {} \; 2>/dev/null
sudo find /home /root -type f -name authorized_keys -exec cat {} \; 2>/dev/null
sudo find /home /root -type f -name known_hosts -exec ls -la {} \; 2>/dev/null
sudo grep -RinE 'ssh-rsa|ssh-ed25519' /home /root 2>/dev/null | head -n 200
```

## Cron persistence
```bash
crontab -l || true
sudo cat /etc/crontab
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /var/spool/cron 2>/dev/null
sudo grep -RinE 'curl|wget|nc |bash -c|python -c|/tmp/' /etc/cron* /var/spool/cron 2>/dev/null
```

## systemd persistence
```bash
systemctl list-unit-files --type=service | grep enabled
systemctl list-timers --all
sudo find /etc/systemd/system -type f -name '*.service' -o -name '*.timer' 2>/dev/null
sudo grep -RinE 'ExecStart=.*(curl|wget|bash -c|python|/tmp/)' /etc/systemd/system 2>/dev/null
sudo systemctl cat ssh 2>/dev/null
```

## Shell startup and profile persistence
```bash
sudo grep -RinE 'curl|wget|nc |bash -c|python -c|/tmp/' /etc/profile /etc/profile.d /home/*/.bashrc /home/*/.profile /root/.bashrc /root/.profile 2>/dev/null
```
