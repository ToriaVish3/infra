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
