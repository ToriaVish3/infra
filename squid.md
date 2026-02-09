# Squid Proxy

## Ссылки (с описанием)
- https://help.ubuntu.ru/wiki/руководство_по_ubuntu_server/web_сервера/squid_proxy_server — RU: установка и базовая настройка
- https://help.ubuntu.com/community/Squid — EN: базовая конфигурация и файлы
- https://ubuntu.com/server/docs/how-to/web-services/install-a-squid-server/ — EN: установка и пример директив

## Команды (шпаргалка: команда — что делает)
- `apt install squid -y` — установить squid
- `cp /etc/squid/squid.conf /etc/squid/squid.conf.original` — сохранить оригинальный конфиг
- `chmod a-w /etc/squid/squid.conf.original` — защитить оригинал
- `systemctl restart squid` — перезапустить squid
- `tail -f /var/log/squid/access.log` — смотреть логи доступа

## Мини‑директивы в squid.conf
```
http_port 3128
visible_hostname proxy1
acl localnet src 192.168.1.0/24
http_access allow localnet
http_access deny all
```
