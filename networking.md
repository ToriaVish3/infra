# Сети и iproute2

## Ссылки (с описанием)
- https://habr.com/ru/articles/108690/ — базовые сетевые команды Linux
- https://www.k-max.name/linux/nastrojka-i-upravlenie-setevoj-podsistemoj-linux-paket-iproute2/ — iproute2
- https://manpages.debian.org/experimental/iproute2/ip.8.en.html — ip(8) (EN)

## Команды (шпаргалка: команда — что делает)
- `ip a` — показать IP-адреса интерфейсов
- `ip link set eth0 up` — поднять интерфейс
- `ip address add 10.10.10.10/24 dev eth0` — назначить IP
- `ip route` — показать маршруты
- `ip route add 10.10.30.0/24 via 10.10.20.2` — добавить маршрут
- `ip rule` — показать policy rules
- `ip route replace default via 10.10.10.1` — заменить default маршрут
- `ss -tulpn` — показать слушающие порты
- `tcpdump -ni eth0 port 80` — захват трафика по порту 80

## Диагностика
- `ping 10.10.30.10` — проверить связность
- `traceroute 10.10.30.10` — трассировка маршрута
- `dig @10.10.10.1 example.local` — проверить DNS

## Дополнительные команды (шпаргалка: команда — что делает)
- `ip neigh` — показать ARP/ND таблицу
- `ip -br a` — краткий вывод интерфейсов
- `ip route get 10.10.30.10` — посмотреть, каким маршрутом пойдёт трафик
- `ss -tulpen` — порты с PID и пользователем
- `arp -n` — ARP таблица (legacy)
- `ethtool eth0` — параметры линка
- `nmcli dev status` — статус устройств NetworkManager (если используется)
- `ping -c 3 10.10.30.10` — быстрый тест связности
- `traceroute -n 10.10.30.10` — трассировка без DNS
- `mtr -rw 10.10.30.10` — комбинированный ping/traceroute (если установлен)
