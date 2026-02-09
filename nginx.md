# Nginx

## Ссылки (с описанием)
- https://nginx.org/ru/docs/beginners_guide.html — базовые конфиги и запуск
- https://nginx.org/ru/docs/http/ngx_http_proxy_module.html — proxy_pass и заголовки
- https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/ — reverse proxy (EN)
- https://nginx.org/en/docs/beginners_guide.html — базовое руководство (EN)

## Команды (шпаргалка: команда — что делает)
- `nginx -t` — проверить конфигурацию
- `systemctl reload nginx` — перечитать конфиг без остановки
- `systemctl restart nginx` — перезапуск сервиса
- `nginx -s reload` — отправить сигнал перезагрузки
- `tail -f /var/log/nginx/error.log` — смотреть ошибки

## Пример reverse proxy (HTTP)
```nginx
server {
  listen 80;
  location / {
    proxy_pass http://10.20.20.10:8080;
  }
}
```

## Пример HTTPS + редирект
```nginx
server { listen 80; return 301 https://$host$request_uri; }
server {
  listen 443 ssl;
  ssl_certificate /etc/ssl/certs/rp.crt;
  ssl_certificate_key /etc/ssl/private/rp.key;
  location / { proxy_pass http://10.20.20.10:8080; }
}
```

## Дополнительные команды (шпаргалка: команда — что делает)
- `ls -la /etc/nginx/` — посмотреть структуру конфигов
- `grep -R "server_name" -n /etc/nginx/` — найти виртуальные хосты
- `nginx -T` — вывести конфиг полностью (с include)
- `openssl x509 -in /etc/ssl/certs/rp.crt -noout -text` — проверить сертификат
- `ss -tulpn | grep :80` — проверить, что nginx слушает порт
- `curl -I http://localhost` — проверка ответа сервера
- `curl -k https://localhost` — проверка HTTPS (self‑signed)
