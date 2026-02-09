# Бэкапы (rsync + ssh + cron)

## Ссылки (с описанием)
- https://habr.com/ru/articles/947630/ — rsync практика
- https://habr.com/ru/articles/948104/ — резервное копирование
- https://help.ubuntu.ru/wiki/cron — cron
- https://platformv.sbertech.ru/docs/public/SLO/9.0-fstec/common/documents/pfstec/administration-guide/ssh-keygen.html — ssh-keygen
- https://man7.org/linux/man-pages/man1/rsync.1.html — rsync manpage (EN)

## Команды (шпаргалка: команда — что делает)
- `ssh-keygen -t ed25519 -a 32 -f ~/.ssh/backup_key` — создать ключ для бэкапов
- `ssh-copy-id -i ~/.ssh/backup_key.pub user@backup-host` — установить ключ на сервер
- `rsync -avz /etc/nginx user@backup-host:/backup/app/` — синхронизация каталогов
- `rsync -avzn --delete user@host:/src/ /dst/` — тест синхронизации с удалением (dry-run)
- `tar -czf /tmp/app-backup.tgz /etc/nginx /opt/app/docker-compose.yml` — архивный бэкап
- `crontab -e` — открыть расписание задач

## Пример cron (каждые 6 часов)
```
0 */6 * * * /usr/bin/rsync -avz /etc/nginx user@backup-host:/backup/app/
```
