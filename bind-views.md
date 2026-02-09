# BIND9 Views (Split DNS)

## Ссылки (с описанием)
- https://ftp.arnes.si/mirrors/ftp.isc.org/bind9/9.17.2/doc/arm/Bv9ARM.pdf — BIND 9 ARM: синтаксис и пример view (EN)
- https://bind9.readthedocs.io/_/downloads/en/v9_18_0/pdf/ — BIND 9 ARM (новее): view statement (EN)

## Команды (шпаргалка: команда — что делает)
- `apt install bind9 bind9utils -y` — установить BIND и утилиты
- `named-checkconf` — проверить конфигурацию
- `named-checkzone example.local /etc/bind/db.example.local` — проверить зону
- `systemctl restart bind9` — перезапуск сервиса
- `dig @127.0.0.1 example.local` — проверка ответа

## Пример view (split DNS)
```
view "internal" {
  match-clients { 10.0.0.0/8; };
  recursion yes;
  zone "example.com" {
    type master;
    file "/etc/bind/db.example.internal";
  };
};

view "external" {
  match-clients { any; };
  recursion no;
  zone "example.com" {
    type master;
    file "/etc/bind/db.example.external";
  };
};
```
