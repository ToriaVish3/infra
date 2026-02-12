# BGP (динамическая маршрутизация)

## Ссылки (с описанием, преимущественно RU)
- https://habr.com/ru/articles/313220/ — основы BGP, термины и логика работы (RU)
- https://www.cisco.com/c/ru_ru/support/docs/ip/border-gateway-protocol-bgp/ — раздел документации Cisco по BGP (RU)
- https://wiki.mikrotik.com/wiki/Manual:Routing/BGP — BGP на MikroTik (EN, но официальный)
- https://docs.frrouting.org/en/stable-9.1/bgp.html — BGP в FRR (EN, официальный)

## Коротко о BGP
BGP — протокол междоменной маршрутизации (path‑vector). Работает по TCP/179. Обмен — префиксами и атрибутами (AS‑PATH, NEXT_HOP, LOCAL_PREF, MED и т.д.).

## Общие понятия
- `AS` — номер автономной системы. В eBGP — разные, в iBGP — одинаковые.
- `neighbor/peer` — сосед BGP (адрес и параметры сеанса).
- `router-id` — идентификатор BGP (IP‑подобное значение, уникальный).
- `NEXT_HOP` — куда посылать трафик для префикса.
- `LOCAL_PREF` — предпочтительность пути внутри AS (больше — лучше).
- `MED` — метрика для соседней AS (меньше — лучше).
- `AS‑PATH` — путь по AS, петли отсекаются автоматически.

## Предварительные проверки (до настройки)
Где: **на маршрутизаторах**
- L3‑связность между соседями (ping по IP интерфейса).
- Порты/ACL не блокируют TCP/179.
- Нет конфликтов `router-id`.
- Понимать: eBGP (между AS) или iBGP (внутри одной AS).

# FRR (Linux)

## Установка и включение демона
Где: **на маршрутизаторе Linux**
- `apt install frr -y` — установить FRR
- `sed -n '1,200p' /etc/frr/daemons` — проверить, включен ли `bgpd`
- `systemctl enable --now frr` — включить и запустить FRR

## Мини‑конфигурация (eBGP)
Где: **на маршрутизаторе Linux**
```
vtysh
conf t
router bgp 65001
 bgp router-id 10.10.10.1
 neighbor 10.10.10.2 remote-as 65002
 network 10.20.0.0/24
exit
write
```
Пояснение:
- `router bgp 65001` — локальная AS
- `bgp router-id` — router-id
- `neighbor ... remote-as` — сосед и его AS
- `network ...` — анонс префикса (должен быть в таблице маршрутов)
- `write` — сохранить конфиг в `/etc/frr/frr.conf`

## Проверка (FRR)
Где: **на маршрутизаторе Linux**
- `vtysh -c "show ip bgp summary"` — состояние соседей
- `vtysh -c "show ip bgp"` — таблица BGP
- `vtysh -c "show ip route bgp"` — маршруты, установленные из BGP

## Удаление/откат (FRR)
Где: **на маршрутизаторе Linux**
- `vtysh -c "conf t" -c "no router bgp 65001" -c "write"` — удалить процесс BGP
- отключить демон в `/etc/frr/daemons` (bgpd=no) и `systemctl restart frr`

# Cisco IOS / IOS‑XE

## Мини‑конфигурация (eBGP)
Где: **на Cisco**
```
conf t
router bgp 65001
 bgp router-id 10.10.10.1
 neighbor 10.10.10.2 remote-as 65002
 network 10.20.0.0 mask 255.255.255.0
end
write memory
```
Пояснение:
- `router bgp 65001` — локальная AS
- `neighbor ... remote-as` — сосед и его AS
- `network ... mask` — объявить префикс

## Проверка (Cisco)
Где: **на Cisco**
- `show ip bgp summary` — соседи
- `show ip bgp` — таблица BGP
- `show ip route bgp` — маршруты BGP

## Удаление/откат (Cisco)
Где: **на Cisco**
- `conf t` затем `no router bgp 65001` — удалить процесс
- `clear ip bgp *` — перезапустить сессии (если нужно перечитать конфиг)

# MikroTik RouterOS

## v7/v8 (новый синтаксис)
Где: **на MikroTik**
- `/routing bgp template add name=ebgp1 as=65001 router-id=10.10.10.1` — шаблон
- `/routing bgp connection add name=to-peer remote.address=10.10.10.2 remote.as=65002 template=ebgp1` — сосед
- `/routing bgp network add network=10.20.0.0/24` — анонс сети

Проверка:
- `/routing bgp session print` — сессии
- `/routing bgp advertisements print` — что анонсируется
- `/ip route print where protocol=bgp` — маршруты BGP

Удаление/откат:
- `/routing bgp connection remove [find]`
- `/routing bgp template remove [find]`
- `/routing bgp network remove [find]`

## v6 (старый синтаксис)
Где: **на MikroTik**
- `/routing bgp instance set [find default=yes] as=65001 router-id=10.10.10.1` — AS и router-id
- `/routing bgp peer add name=to-peer remote-address=10.10.10.2 remote-as=65002` — сосед
- `/routing bgp network add network=10.20.0.0/24` — анонс сети

# JunOS

## Мини‑конфигурация (eBGP)
Где: **на Juniper**
```
set routing-options autonomous-system 65001
set routing-options router-id 10.10.10.1
set protocols bgp group EBGP type external
set protocols bgp group EBGP neighbor 10.10.10.2 peer-as 65002
set policy-options policy-statement ANNOUNCE term 1 from route-filter 10.20.0.0/24 exact
set policy-options policy-statement ANNOUNCE term 1 then accept
set protocols bgp group EBGP export ANNOUNCE
commit
```
Пояснение:
- `autonomous-system` — локальная AS
- `group ... type external` — eBGP‑группа
- `export` — политика анонса маршрутов

## Проверка (JunOS)
Где: **на Juniper**
- `show bgp summary` — соседи
- `show route protocol bgp` — маршруты
- `show bgp neighbor` — детали сессии

## Удаление/откат (JunOS)
Где: **на Juniper**
- `delete protocols bgp` затем `commit` — удалить BGP

# Проверка, что BGP работает
- Сессия в состоянии `Established`.
- В таблице маршрутов есть BGP‑маршруты.
- `traceroute`/`ping` проходят в удаленные подсети.

# Типовые проблемы и быстрые проверки
- Сессия `Active/Idle`: проверь TCP/179, адрес соседа, AS, ACL.
- Нет анонса: сеть должна быть в RIB (маршруты должны существовать).
- Неверный `NEXT_HOP`: проверь reachability next‑hop и iBGP‑правила.
- Петли: смотри `AS‑PATH`, не отключай его фильтрацию.
- Проверка пакетами: `tcpdump -ni eth0 port 179` (Linux).

# iBGP (внутри одной AS) — ключевые моменты
- В iBGP соседи имеют одинаковый AS.
- Правило: маршруты, полученные по iBGP, не переанонсируются другим iBGP‑соседям (нужен полный mesh или Route‑Reflector).
- Часто требуется `next-hop-self` на пограничных/внутренних роутерах.
- Для стабильности задают `update-source` (например, loopback).

## iBGP пример: FRR (Loopback + update-source + next-hop-self)
Где: **на маршрутизаторе Linux**  
Предпосылка: есть Loopback `lo` с IP 10.255.255.1/32, сосед — 10.255.255.2/32.
```
vtysh
conf t
router bgp 65001
 bgp router-id 10.10.10.1
 neighbor 10.255.255.2 remote-as 65001
 neighbor 10.255.255.2 update-source lo
 neighbor 10.255.255.2 next-hop-self
exit
write
```
Пояснение:
- `update-source lo` — использовать loopback как source для TCP‑сессии
- `next-hop-self` — переписать next-hop на себя

## iBGP пример: Cisco IOS
Где: **на Cisco**  
Предпосылка: Loopback0 = 10.255.255.1/32, сосед — 10.255.255.2/32.
```
conf t
router bgp 65001
 neighbor 10.255.255.2 remote-as 65001
 neighbor 10.255.255.2 update-source Loopback0
 neighbor 10.255.255.2 next-hop-self
end
write memory
```

## iBGP пример: MikroTik v7/v8
Где: **на MikroTik**
- `/routing bgp template add name=ibgp1 as=65001 router-id=10.10.10.1`
- `/routing bgp connection add name=to-ibgp remote.address=10.255.255.2 remote.as=65001 template=ibgp1 local.role=ibgp`
- `/routing bgp connection set [find name=to-ibgp] update-source=loopback` — если есть loopback
- `/routing bgp connection set [find name=to-ibgp] nexthop-choice=force-self` — аналог next-hop-self

## iBGP пример: JunOS
Где: **на Juniper**
```
set protocols bgp group IBGP type internal
set protocols bgp group IBGP neighbor 10.255.255.2
set protocols bgp group IBGP local-address 10.255.255.1
set protocols bgp group IBGP export NEXT-HOP-SELF
set policy-options policy-statement NEXT-HOP-SELF then next-hop self
commit
```

# Route Reflector (iBGP, если нет полного mesh)
Смысл: RR получает маршруты от клиентов и переанонсирует их другим клиентам.

## FRR (RR пример)
Где: **на маршрутизаторе Linux**
```
vtysh
conf t
router bgp 65001
 neighbor 10.255.255.2 remote-as 65001
 neighbor 10.255.255.2 route-reflector-client
 neighbor 10.255.255.3 remote-as 65001
 neighbor 10.255.255.3 route-reflector-client
exit
write
```

## Cisco IOS (RR пример)
Где: **на Cisco**
```
conf t
router bgp 65001
 neighbor 10.255.255.2 remote-as 65001
 neighbor 10.255.255.2 route-reflector-client
 neighbor 10.255.255.3 remote-as 65001
 neighbor 10.255.255.3 route-reflector-client
end
write memory
```

# Фильтрация и политики (минимальные примеры)

## Cisco IOS: prefix-list + route-map (out)
Где: **на Cisco**
```
ip prefix-list OUT-ONLY seq 10 permit 10.20.0.0/24
route-map RM-OUT permit 10
 match ip address prefix-list OUT-ONLY
!
router bgp 65001
 neighbor 10.10.10.2 remote-as 65002
 neighbor 10.10.10.2 route-map RM-OUT out
end
write memory
```
Пояснение:
- `prefix-list` — какие префиксы можно анонсировать
- `route-map` — политика, куда привязать prefix-list

## FRR: prefix-list + route-map (out)
Где: **на маршрутизаторе Linux**
```
vtysh
conf t
ip prefix-list OUT-ONLY seq 10 permit 10.20.0.0/24
route-map RM-OUT permit 10
 match ip address prefix-list OUT-ONLY
router bgp 65001
 neighbor 10.10.10.2 remote-as 65002
 neighbor 10.10.10.2 route-map RM-OUT out
exit
write
```

## MikroTik v7/v8: фильтры (routing filter)
Где: **на MikroTik**
```
/routing filter rule add chain=bgp-out rule="if (dst in 10.20.0.0/24) { accept } else { reject }"
/routing bgp connection set [find name=to-peer] output.filter=bgp-out
```

## JunOS: policy-statement (export)
Где: **на Juniper**
```
set policy-options policy-statement ANNOUNCE term 1 from route-filter 10.20.0.0/24 exact
set policy-options policy-statement ANNOUNCE term 1 then accept
set protocols bgp group EBGP export ANNOUNCE
commit
```
