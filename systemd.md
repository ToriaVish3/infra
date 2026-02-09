# systemd (systemctl)

## Ссылки (с описанием)
- https://habr.com/ru/articles/942760/ — systemd/journalctl
- https://the.hosting/ru/help/systemctl-podrobnoe-rukovodstvo-po-upravleniju-sluzhbami-v-linux — systemctl

## Команды (шпаргалка: команда — что делает)
- `systemctl status nginx` — статус сервиса
- `systemctl start nginx` — запуск сервиса
- `systemctl stop nginx` — остановка сервиса
- `systemctl restart nginx` — перезапуск сервиса
- `systemctl reload nginx` — перечитать конфигурацию без остановки
- `systemctl enable nginx` — включить автозапуск
- `systemctl disable nginx` — выключить автозапуск
- `systemctl --failed` — список упавших юнитов
- `journalctl -u nginx` — логи сервиса
