# DHCP (dnsmasq)

## Ссылки (с описанием)
- https://wiki.debian.org/dnsmasq — установка и базовая настройка DNS/DHCP (EN)
- https://wiki.debian.org/ru/ris — пример конфигурации dnsmasq с DHCP (RU)

## Команды (шпаргалка: команда — что делает)
- `apt update && apt install dnsmasq -y` — установить dnsmasq
- `systemctl status dnsmasq` — проверить статус
- `journalctl -u dnsmasq -f` — логи в реальном времени
- `dig @127.0.0.1 debian.org` — проверить DNS‑форвардинг

## Мини‑конфиг /etc/dnsmasq.conf (пример)
```
# слушать только нужные интерфейсы
interface=eth0
listen-address=192.168.10.1,127.0.0.1

# DHCP диапазон
# выдаёт адреса 192.168.10.100-192.168.10.150, аренда 4 часа
 dhcp-range=192.168.10.100,192.168.10.150,255.255.255.0,4h

# опции DHCP (например DNS и NTP)
 dhcp-option=option:dns-server,192.168.10.1
 dhcp-option=option:ntp-server,192.168.10.1
```

## Проверка
- клиент получает адрес из диапазона
- `journalctl -u dnsmasq` показывает выдачу lease
