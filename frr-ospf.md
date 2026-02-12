# FRR / OSPF (динамическая маршрутизация)

## Ссылки (с описанием)
- https://docs.frrouting.org/en/stable-9.1/ospfd.html — OSPF в FRR (EN)
- https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-43/Layer-3/FRRouting/Configure-FRRouting/ — включение демонов FRR (EN)
- https://www.watchguard.com/help/docs/help-center/en-us/content/en-us/fireware/dynamicrouting/ospf_sample_frr.html — пример конфигурации OSPF (EN)

## Команды (шпаргалка: команда — что делает)
- `apt install frr -y` — установить FRR
- `sed -n '1,200p' /etc/frr/daemons` — посмотреть, какие демоны включены
- `systemctl enable --now frr` — включить и запустить FRR
- `vtysh` — CLI FRR
- `show ip ospf neighbor` — проверить соседей OSPF
- `show ip route` — проверить маршруты

## Мини‑пример (vtysh)
```
configure terminal
router ospf
 network 10.10.10.0/24 area 0
 network 10.10.20.0/30 area 0
exit
write
```

# OSPF (динамическая маршрутизация: FRR / Cisco / MikroTik / JunOS)

## Коротко о OSPF
OSPF — протокол динамической маршрутизации link-state. Роутеры строят общую базу состояния каналов (LSDB) и рассчитывают маршруты по SPF. Для IPv4 используется OSPFv2 (IP protocol 89, multicast 224.0.0.5 и 224.0.0.6). Кост (cost) обычно зависит от скорости интерфейса.

## Общие понятия
- `router-id` — уникальный ID роутера (формат IP, но это логическое значение). Должен быть уникальным в домене OSPF.
- `area` — область. `area 0` — backbone, через нее соединяются остальные области.
- `neighbor adjacency` — соседство OSPF. В норме состояние `FULL`.
- `network` — способ объявить интерфейсы в OSPF (Cisco) или сети (FRR/MikroTik).
- `passive-interface` — объявлять сеть, но не устанавливать соседства на интерфейсе.

## Предварительные проверки (до настройки)
Где: **на маршрутизаторах**
- IP‑адреса и интерфейсы подняты (`UP`).
- Есть L3‑связность между соседями (ping по IP интерфейса).
- Firewall не блокирует OSPF (IP protocol 89).
- Нет дублирующихся `router-id`.

# FRR (Linux)

## Установка и включение демона
Где: **на маршрутизаторе Linux**
- `apt install frr -y` — установить FRR
- `sed -n '1,200p' /etc/frr/daemons` — проверить, включен ли `ospfd`
- `systemctl enable --now frr` — включить и запустить FRR

## Мини‑конфигурация (vtysh)
Где: **на маршрутизаторе Linux**
```
vtysh
conf t
router ospf
 ospf router-id 10.10.10.1
 network 10.10.10.0/30 area 0
 network 10.10.20.0/24 area 0
 passive-interface default
 no passive-interface eth0
exit
write
```
Пояснение:
- `router ospf` — включает процесс OSPF
- `ospf router-id` — задает router-id
- `network ... area 0` — включает интерфейсы, попадающие в сеть
- `passive-interface default` — по умолчанию не формировать соседства
- `no passive-interface eth0` — разрешить соседство только на нужном интерфейсе
- `write` — сохранить конфиг в `/etc/frr/frr.conf`

## Проверка (FRR)
Где: **на маршрутизаторе Linux**
- `vtysh -c "show ip ospf neighbor"` — соседи OSPF
- `vtysh -c "show ip ospf interface"` — OSPF на интерфейсах
- `vtysh -c "show ip route ospf"` — маршруты, полученные по OSPF
- `vtysh -c "show ip ospf database"` — LSDB

## Удаление/откат (FRR)
Где: **на маршрутизаторе Linux**
- `vtysh -c "conf t" -c "no router ospf" -c "write"` — удалить процесс OSPF
- отключить демон в `/etc/frr/daemons` (ospfd=no) и `systemctl restart frr`

# Cisco IOS / IOS‑XE

## Мини‑конфигурация
Где: **на Cisco**
```
conf t
router ospf 1
 router-id 10.10.10.1
 network 10.10.10.0 0.0.0.3 area 0
 network 10.10.20.0 0.0.0.255 area 0
 passive-interface default
 no passive-interface GigabitEthernet0/0
end
write memory
```
Пояснение:
- `router ospf 1` — процесс OSPF с ID 1
- `network ... 0.0.0.255` — wildcard маска (инвертированная маска)
- `passive-interface` — не поднимать соседства там, где не нужно

## Проверка (Cisco)
Где: **на Cisco**
- `show ip ospf neighbor` — соседи OSPF
- `show ip ospf interface brief` — OSPF на интерфейсах
- `show ip route ospf` — маршруты OSPF
- `show ip protocols` — какие сети объявляются и таймеры

## Удаление/откат (Cisco)
Где: **на Cisco**
- `conf t` затем `no router ospf 1` — удалить процесс OSPF
- `clear ip ospf process` — перезапустить OSPF (если нужно перечитать конфиг)

# MikroTik RouterOS

## v7/v8 (новый синтаксис)
Где: **на MikroTik**
- `/routing ospf instance add name=ospf1 router-id=10.10.10.1` — создать instance
- `/routing ospf area add name=backbone instance=ospf1 area-id=0.0.0.0` — area 0
- `/routing ospf interface-template add area=backbone networks=10.10.10.0/30` — включить сеть
- `/routing ospf interface-template add area=backbone networks=10.10.20.0/24` — включить сеть

Проверка:
- `/routing ospf neighbor print` — соседи
- `/ip route print where protocol=ospf` — маршруты OSPF

Удаление/откат:
- `/routing ospf interface-template remove [find]`
- `/routing ospf area remove [find]`
- `/routing ospf instance remove [find]`

## v6 (старый синтаксис)
Где: **на MikroTik**
- `/routing ospf instance set [find default=yes] router-id=10.10.10.1` — router-id
- `/routing ospf network add network=10.10.10.0/30 area=backbone`
- `/routing ospf network add network=10.10.20.0/24 area=backbone`

# JunOS

## Мини‑конфигурация
Где: **на Juniper**
```
set routing-options router-id 10.10.10.1
set protocols ospf area 0 interface ge-0/0/0.0
set protocols ospf area 0 interface ge-0/0/1.0
commit
```
Пояснение:
- `routing-options router-id` — router-id
- `protocols ospf area 0 interface ...` — включить интерфейс в area 0

## Проверка (JunOS)
Где: **на Juniper**
- `show ospf neighbor` — соседи OSPF
- `show route protocol ospf` — маршруты OSPF
- `show ospf interface` — OSPF на интерфейсах

## Удаление/откат (JunOS)
Где: **на Juniper**
- `delete protocols ospf` затем `commit` — удалить OSPF

# Проверка, что OSPF работает
- Соседи в состоянии `FULL`.
- В таблице маршрутов есть OSPF‑маршруты.
- `traceroute`/`ping` проходят в удаленные подсети.

# Типовые проблемы и быстрые проверки
- Соседи не поднимаются: проверь `router-id`, `area`, `MTU`, `passive-interface`.
- Нет маршрутов: проверь, что нужные сети объявлены, и что есть соседство `FULL`.
- OSPF блокируется firewall: разреши IP protocol 89.
- Несовпадение масок/интерфейсов: проверь `network` (Cisco wildcard или сеть в FRR/MikroTik).
- Проверка с packet capture: `tcpdump -ni eth0 proto 89` (Linux).
