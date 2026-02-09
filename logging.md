# Логи (journalctl + logrotate)

## Ссылки (с описанием)
- https://habr.com/ru/articles/942760/ — systemd/journalctl
- https://the.hosting/ru/help/systemctl-podrobnoe-rukovodstvo-po-upravleniju-sluzhbami-v-linux — systemctl
- https://disnetern.ru/logrotate-debian-ubuntu/ — logrotate
- https://help.ubuntu.ru/wiki/cron — cron

## Команды (шпаргалка: команда — что делает)
- `journalctl` — показать все логи systemd
- `journalctl -u nginx` — логи конкретного сервиса
- `journalctl -u nginx -f` — лог в режиме tail -f
- `journalctl -p err` — только ошибки
- `logrotate -d /etc/logrotate.d/nginx` — тест ротации (dry-run)
- `logrotate -f /etc/logrotate.d/nginx` — принудительная ротация

## Мини-конфиг logrotate для nginx
```
/var/log/nginx/*.log {
  weekly
  rotate 52
  compress
  delaycompress
  missingok
  notifempty
  create 0640 www-data adm
  sharedscripts
  postrotate
    [ -s /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`
  endscript
}
```
