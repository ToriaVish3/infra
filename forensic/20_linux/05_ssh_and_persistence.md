# 05 ssh and persistence

## SSH artefacts from THM flow
```bash
ls -a /home/jane
# Показать скрытые файлы в home
ls -al /home/jane/.ssh
# Проверить права и содержимое .ssh
cat /home/jane/.ssh/authorized_keys
# Проверить authorized_keys
stat /home/jane/.ssh/authorized_keys
# Полные таймстемпы и inode для authorized_keys
ls -al /home/jane/.ssh/authorized_keys
# Права доступа к authorized_keys
```

## Persistence checks
```bash
crontab -l
# Cron текущего пользователя
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /var/spool/cron 2>/dev/null
# Системные cron директории
systemctl list-timers --all
# Все systemd timers
systemctl list-unit-files --type=service | grep enabled
# Список enabled сервисов
```

## Extra forensic commands
```bash
sudo grep -Ei "PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|AuthorizedKeysFile" /etc/ssh/sshd_config
# Ключевые SSH security-настройки
sudo find /home /root -maxdepth 3 -type f -name 'authorized_keys' -exec ls -la {} \;
# Найти все authorized_keys и их права
sudo find /home /root -maxdepth 3 -type f -name 'authorized_keys' -exec stat {} \;
# Полный stat для каждого authorized_keys
sudo find /etc/systemd/system /usr/lib/systemd/system -type f -name '*.service' -mtime -7 -print
# Новые/измененные systemd service файлы за 7 дней
sudo systemctl cat ssh 2>/dev/null
# Показать итоговый unit-файл ssh
```
