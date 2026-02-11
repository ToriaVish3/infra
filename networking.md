# Сети и iproute2

## Ссылки (с описанием)
- https://habr.com/ru/articles/108690/ — базовые сетевые команды Linux
- https://www.k-max.name/linux/nastrojka-i-upravlenie-setevoj-podsistemoj-linux-paket-iproute2/ — iproute2
- https://manpages.debian.org/experimental/iproute2/ip.8.en.html — ip(8) (EN)

## Команды (шпаргалка: команда — что делает)
Где: **на ПК/сервере Debian**
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
Где: **на ПК/сервере Debian**
- `ping 10.10.30.10` — проверить связность
- `traceroute 10.10.30.10` — трассировка маршрута
- `dig @10.10.10.1 example.local` — проверить DNS

## Дополнительные команды (шпаргалка: команда — что делает)
Где: **на ПК/сервере Debian**
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

# Настройка IP на Debian‑подобных (где писать и как)

## Важно: временная vs постоянная
`ip` меняет состояние только до перезагрузки. Для постоянной настройки нужен сетевой менеджер (ifupdown, systemd‑networkd, NetworkManager).

## Временная настройка через `ip` (до ребута)
Где: **на ПК/сервере Debian**
- `ip -br link` — кратко показать интерфейсы и состояние
- `ip link set eth0 up` — поднять интерфейс
- `ip address add 10.10.10.10/24 dev eth0` — назначить IP
- `ip address del 10.10.10.10/24 dev eth0` — удалить IP
- `ip route add default via 10.10.10.1` — добавить default
- `ip route add 10.10.30.0/24 via 10.10.20.2` — статический маршрут

## Постоянная настройка (где лежат файлы)

### 1) ifupdown (классический Debian)
Где: **на ПК/сервере Debian**
Файлы:
- `/etc/network/interfaces`
- `/etc/network/interfaces.d/*.cfg`

Как править через nano:
- `nano /etc/network/interfaces` — открыть файл
- `Ctrl+O`, `Enter`, `Ctrl+X` — сохранить и выйти

Пример содержимого (вариант 1):
- `auto ens3`
- `iface ens3 inet static`
- `address 10.10.10.10/24`
- `gateway 10.10.10.1`
- `dns-nameservers 10.10.10.53 10.10.10.54`

Пример содержимого (вариант 2, рандомные данные):
- `auto ens4`
- `iface ens4 inet static`
- `address 172.16.50.23/24`
- `gateway 172.16.50.1`
- `dns-nameservers 1.1.1.1 8.8.8.8`

Применить:
- `systemctl restart networking` — применить конфиг

### 2) systemd-networkd (часто в минимальных образах)
Где: **на ПК/сервере Debian**
Файлы:
- `/etc/systemd/network/*.network`

Как править через nano:
- `nano /etc/systemd/network/10-ens3.network`

Пример содержимого (вариант 1):
- `[Match]`
- `Name=ens3`
- `[Network]`
- `Address=10.10.10.10/24`
- `Gateway=10.10.10.1`
- `DNS=10.10.10.53`

Пример содержимого (вариант 2, рандомные данные):
- `[Match]`
- `Name=ens4`
- `[Network]`
- `Address=192.168.77.14/24`
- `Gateway=192.168.77.1`
- `DNS=9.9.9.9`

Применить:
- `systemctl restart systemd-networkd` — применить изменения

### 3) NetworkManager
Где: **на ПК/сервере Debian с NetworkManager**
Файлы:
- `/etc/NetworkManager/system-connections/*.nmconnection`

Как править через nano:
- `nano /etc/NetworkManager/system-connections/Wired\ connection\ 1.nmconnection`

Применить:
- `systemctl restart NetworkManager`

## DNS и резолвер (где писать)
Где: **на ПК/сервере Debian**
Файлы:
- `/etc/resolv.conf` — текущий резолвер (часто генерируется)
- `/etc/systemd/resolved.conf` — настройки systemd‑resolved
- `/run/systemd/resolve/resolv.conf` — автогенерированный файл resolved

Команды:
- `resolvectl status` — проверить активные DNS/домен
- `resolvectl query example.local` — тест резолвинга

# Маршрутизация и “роутер” на Linux

## Включить IP‑forwarding
Где: **на маршрутизаторе Linux**
Файлы:
- `/etc/sysctl.conf` или `/etc/sysctl.d/*.conf`

Команды:
- `sysctl net.ipv4.ip_forward` — проверить
- `sysctl -w net.ipv4.ip_forward=1` — включить до ребута
- `sysctl -p` — применить `/etc/sysctl.conf`
- `sysctl --system` — применить все `/etc/sysctl.d/*.conf`

## Статическая маршрутизация
Где: **на маршрутизаторе Linux**
Команды:
- `ip route add 10.20.0.0/24 via 10.10.10.2` — добавить маршрут
- `ip route add 10.30.0.0/24 dev eth1` — маршрут в directly‑connected сеть
- `ip route del 10.20.0.0/24` — удалить маршрут
- `ip route` — проверить таблицу

## Policy‑routing (если нужно)
Где: **на маршрутизаторе Linux**
Команды:
- `ip rule add from 10.10.10.0/24 table 100` — трафик от подсети в отдельную таблицу
- `ip route add default via 10.10.10.1 table 100` — default в таблице 100
- `ip rule show` — посмотреть правила
- `ip route show table 100` — таблица 100

# Динамическая маршрутизация (OSPF/BGP через FRR)

## Где конфиг FRR
Где: **на маршрутизаторе Linux**
Файлы:
- `/etc/frr/daemons`
- `/etc/frr/frr.conf`

Команды:
- `systemctl enable --now frr` — включить FRR
- `systemctl status frr` — статус сервиса
- `vtysh` — вход в CLI FRR
- `vtysh -c "show ip route"` — маршруты
- `vtysh -c "show ip ospf neighbor"` — OSPF соседи
- `vtysh -c "show ip bgp summary"` — BGP статус

## OSPF (краткий пример логики)
Где: **на маршрутизаторе Linux**
- `router ospf` — включить процесс OSPF
- `network 10.10.10.0/24 area 0` — объявить сеть
- `passive-interface eth0` — не поднимать соседства

## BGP (краткий пример логики)
Где: **на маршрутизаторе Linux**
- `router bgp 65001` — локальная AS
- `neighbor 10.10.10.2 remote-as 65002` — сосед
- `network 10.20.0.0/24` — объявить сеть

# MikroTik (RouterOS): IP, Bridge, OSPF

## Важно: не используйте interface=*ID
В адресах и OSPF не привязывайтесь к `interface=*15` и т.п. Эти ID могут меняться после перезагрузки. Всегда указывайте имя интерфейса (`ether1`, `bridge1`).

## Bridge
Показать бриджи:
- `/interface bridge print`

Показать порты в бридже:
- `/interface bridge port print`
- `/interface bridge port print where bridge="bridge1"`

Удалить и создать заново:
- `/interface bridge remove [find name="bridge1"]`
- `/interface bridge add name=bridge1`

Добавить порты в бридж:
- `/interface bridge port add bridge=bridge1 interface=etherXX`
- `/interface bridge port add bridge=bridge1 interface=etherYY`

Привязать IP к бриджу:
- `/ip address add address=10.10.20.1/24 interface=bridge1`

## OSPF (RouterOS v7/v8)
Сбросить OSPF полностью:
- `/routing ospf instance remove [find]`
- `/routing ospf area remove [find]`
- `/routing ospf interface-template remove [find]`
- `/routing ospf neighbor remove [find]`

Настроить заново (пример):
- `/routing ospf instance add name=ospf1 router-id=10.10.10.1`
- `/routing ospf area add name=backbone instance=ospf1 area-id=0.0.0.0`
- `/routing ospf interface-template add area=backbone networks=10.10.10.0/30`
- `/routing ospf interface-template add area=backbone networks=10.10.20.0/24`

Проверка:
- `/routing ospf neighbor print`
- `/ip route print where protocol=ospf`

Раздача default‑route в OSPF:
- `/routing ospf instance set [find name="ospf1"] originate-default=always`
- `/routing ospf instance set [find name="ospf1"] originate-default=if-installed`

## OSPF: другие вендоры (краткие примеры синтаксиса)

Cisco IOS:
- `conf t`
- `router ospf 1`
- `router-id 10.10.10.1`
- `network 10.10.10.0 0.0.0.3 area 0`
- `network 10.10.20.0 0.0.0.255 area 0`

JunOS:
- `set routing-options router-id 10.10.10.1`
- `set protocols ospf area 0 interface ge-0/0/0`
- `set protocols ospf area 0 interface ge-0/0/1`
- `commit`

FRR (Linux):
- `vtysh`
- `conf t`
- `router ospf`
- `ospf router-id 10.10.10.1`
- `network 10.10.10.0/30 area 0`
- `network 10.10.20.0/24 area 0`

# Траблшутинг: типовые ситуации (где выполнять)

## Нет линка или интерфейс DOWN
Где: **на ПК или на маршрутизаторе Linux**
- `ip -br link` — проверить UP/DOWN
- `ethtool eth0` — линк и скорость
- `dmesg | tail` — ошибки по NIC

## IP есть, связи нет
Где: **на ПК или на маршрутизаторе Linux**
- `ip a` — адрес/маска
- `ip route` — default‑маршрут
- `ping -c 3 10.10.10.1` — до шлюза
- `ip neigh` — ARP

## Пинг до шлюза есть, дальше нет
Где: **на ПК или на маршрутизаторе Linux**
- `traceroute -n 10.10.30.10` — где обрывается
- `ip route get 10.10.30.10` — куда реально пойдет трафик
- `tcpdump -ni eth0` — проверить, уходит ли трафик

## Нет резолвинга
Где: **на ПК/сервере Debian**
- `resolvectl status` — активные DNS
- `dig @10.10.10.53 example.local` — проверка DNS‑сервера
- `cat /etc/resolv.conf` — что реально используется

## Ассиметричная маршрутизация
Где: **на маршрутизаторе Linux**
- `ip route get <dst>` — путь туда
- `tcpdump -ni eth0` — приходит ли ответ обратно
- проверить `rp_filter` в `/etc/sysctl.d/` (может дропать ответы)

## Конфликты IP или дубликаты
Где: **на ПК или на маршрутизаторе Linux**
- `ip neigh` — необычные MAC‑адреса
- `arping -I eth0 10.10.10.10` — проверить, кто отвечает на IP

# DNS и NetworkManager (типовые проблемы в лабе)

## Симптом: IP пингуется, домен — нет
Если `ping 8.8.8.8` проходит, а `ping google.com` нет — это DNS.

Проверки:
- `cat /etc/resolv.conf`
- `getent hosts google.com`
- `dig @1.1.1.1 google.com +short`
- `dig @8.8.8.8 google.com +short`

## NetworkManager активен
DNS и IP нужно задавать через NM, иначе после ребута слетит.
Проверка:
- `systemctl is-active NetworkManager`

Пример статической настройки:
- `nmcli con mod "Wired connection 1" ipv4.method manual`
- `nmcli con mod "Wired connection 1" ipv4.addresses "10.10.20.10/24"`
- `nmcli con mod "Wired connection 1" ipv4.gateway "10.10.20.1"`
- `nmcli con mod "Wired connection 1" ipv4.dns "1.1.1.1 8.8.8.8"`
- `nmcli con mod "Wired connection 1" ipv4.ignore-auto-dns yes`
- `nmcli con down "Wired connection 1"`
- `nmcli con up "Wired connection 1"`

## Правильный формат /etc/resolv.conf
Должно быть без “/n”:
- `# Generated by NetworkManager`
- `nameserver 1.1.1.1`
- `nameserver 8.8.8.8`

Быстро исправить:
- `printf "# Generated by NetworkManager\nnameserver 1.1.1.1\nnameserver 8.8.8.8\n" | tee /etc/resolv.conf`

## NetworkManager не активен
Настройки нужно писать в менеджер, который реально работает:
- ifupdown: `/etc/network/interfaces` + `systemctl restart networking`
- systemd-networkd: `/etc/systemd/network/*.network` + `systemctl restart systemd-networkd`
- netplan (Ubuntu): `/etc/netplan/*.yaml` + `netplan apply`

# Где может лежать конфиг сети в Debian‑подобных и когда что использовать

## 1) ifupdown (классический Debian, сервера без NetworkManager)
- Файлы: `/etc/network/interfaces`, `/etc/network/interfaces.d/*.cfg`
- Когда: старые/минимальные инсталляции Debian, где нет `systemd-networkd` и NetworkManager
- Проверка: `dpkg -l | grep ifupdown`, наличие `/etc/network/interfaces`

## 2) systemd-networkd (часто в минимальных образах/контейнерах)
- Файлы: `/etc/systemd/network/*.network`
- Когда: минимальные образы, серверы, где явно включен `systemd-networkd`
- Проверка: `systemctl status systemd-networkd`, `networkctl status`

## 3) NetworkManager (desktop и некоторые серверы)
- Файлы: `/etc/NetworkManager/system-connections/*.nmconnection`, `/etc/NetworkManager/NetworkManager.conf`
- Когда: рабочие станции, десктопные установщики, серверы где NM используется как основной менеджер
- Проверка: `systemctl status NetworkManager`, `nmcli dev status`

## 4) netplan (чаще Ubuntu, но может быть и в Debian‑подобных)
- Файлы: `/etc/netplan/*.yaml`
- Когда: системы, где сеть генерируется netplan’ом (обычно Ubuntu)
- Проверка: наличие `/etc/netplan/`, команда `netplan get`

## 5) resolv.conf и systemd-resolved (DNS)
- Файлы: `/etc/resolv.conf`, `/etc/systemd/resolved.conf`, `/run/systemd/resolve/resolv.conf`
- Когда: DNS управляется `systemd-resolved` или другими менеджерами
- Проверка: `resolvectl status`, `ls -l /etc/resolv.conf` (часто это симлинк)

## 6) cloud-init (облачные образы)
- Файлы: `/etc/cloud/cloud.cfg`, `/etc/cloud/cloud.cfg.d/*.cfg` (часто генерирует netplan)
- Когда: облачные/образные VM, где сеть задается через метаданные
- Проверка: `cloud-init status`, файлы в `/etc/cloud/`
