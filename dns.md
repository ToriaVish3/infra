# DNS (BIND9)

## Ссылки (с описанием)
- https://help.ubuntu.ru/wiki/bind9 — BIND9: установка и базовая настройка зон (RU)
- https://wiki.debian.org/BIND9 — Debian Wiki: установка и примеры зон (EN)

## Команды (шпаргалка: команда — что делает)
- `apt update && apt install bind9 bind9utils bind9-doc -y` — установить BIND9 и утилиты
- `systemctl status bind9` — проверить статус сервиса
- `named-checkconf` — проверить конфигурацию
- `named-checkzone example.local /etc/bind/db.example.local` — проверить зону
- `rndc reload` — перечитать конфиги (если настроен rndc)
- `dig @127.0.0.1 example.local` — проверить DNS‑ответ

## Минимальная схема конфигов
Файл: /etc/bind/named.conf.local
```
zone "example.local" {
  type master;
  file "/etc/bind/db.example.local";
};
```

Файл: /etc/bind/db.example.local
```
$TTL    604800
@       IN      SOA     ns1.example.local. admin.example.local. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.example.local.
ns1     IN      A       10.10.10.10
host1   IN      A       10.10.10.20
```

## Типовые проверки
- `dig @10.10.10.10 host1.example.local` — проверка записи
- `dig -x 10.10.10.20 @10.10.10.10` — проверка reverse (если настроена)
