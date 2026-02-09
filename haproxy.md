# HAProxy

## Ссылки (с описанием)
- https://docs.haproxy.org/2.8/configuration.html — конфигурационный мануал (EN)
- https://www.haproxy.com/documentation/ — индекс документации (EN)

## Команды (шпаргалка: команда — что делает)
- `apt install haproxy -y` — установить HAProxy
- `haproxy -c -f /etc/haproxy/haproxy.cfg` — проверить конфиг
- `systemctl restart haproxy` — перезапуск сервиса
- `journalctl -u haproxy -f` — смотреть логи

## Мини‑пример (HTTP reverse proxy)
```
global
  log /dev/log local0

defaults
  mode http
  timeout connect 5s
  timeout client  30s
  timeout server  30s

frontend fe_http
  bind *:80
  default_backend be_app

backend be_app
  server app1 10.20.20.10:8080 check
```
