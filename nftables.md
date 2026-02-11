# nftables

## Ссылки (с описанием)
- https://habr.com/ru/companies/ruvds/articles/580648/ — nftables в примерах
- https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes — быстрый справочник (EN)

## Команды (шпаргалка: команда — что делает)
- `nft list ruleset` — показать все правила
- `nft add table inet filter` — создать таблицу filter
- `nft add chain inet filter input { type filter hook input priority 0 \; policy drop \; }` — цепочка input с policy drop
- `nft add rule inet filter input ct state established,related accept` — разрешить established/related
- `nft add rule inet filter input tcp dport 22 accept` — разрешить SSH
- `nft add rule inet filter input udp dport 51820 accept` — разрешить WireGuard
 - `nft add table ip nat` — создать таблицу nat
 - `nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }` — цепочка postrouting
 - `nft add rule ip nat postrouting oif "ens3" ip saddr 10.200.0.0/24 masquerade` — NAT для VPN подсети
 - `echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward` — включить маршрутизацию (ip_forward) сразу
 - `echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf` — сделать ip_forward постоянным
 - `ss -ltn | grep :22` — проверить, что SSH слушает
 - `ss -lun | grep 51820` — проверить, что WireGuard слушает UDP 51820

Пояснения к параметрам:
`inet` — семейство адресов IPv4+IPv6; `ip` — только IPv4.
`filter` — таблица для фильтрации трафика.
`input` — цепочка для входящих пакетов.
`type filter` — тип цепочки (фильтрация).
`hook input` — привязка цепочки к входящему трафику.
`priority 0` — порядок обработки (меньше = раньше).
`policy drop` — политика по умолчанию: всё неразрешённое отбрасывать.
`ct state established,related` — разрешить уже установленные и связанные соединения.
`tcp dport 22` — правило для TCP порта 22 (SSH).
`udp dport 51820` — правило для UDP порта 51820 (WireGuard).
`accept` — разрешить пакет.
`policy drop` — всё входящее, что не попало под правила, будет отброшено.
`oif "ens3"` — исходящий интерфейс (в нашей схеме LAN-A на mgmt).
`masquerade` — заменяет исходный IP на IP интерфейса (для NAT).
`/proc/sys/net/ipv4/ip_forward` — runtime‑флаг маршрутизации IPv4 (1 = включено).

## NAT (пример)
- `nft add table ip nat` — создать таблицу nat
- `nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }` — цепочка postrouting
- `nft add rule ip nat postrouting oif "eth0" ip saddr 10.200.0.0/24 masquerade` — NAT для VPN подсети

Пояснения к параметрам NAT:
`ip nat` — таблица NAT для IPv4.
`postrouting` — цепочка для трансформаций после маршрутизации.
`type nat` — тип цепочки NAT.
`hook postrouting` — привязка к моменту после выбора маршрута.
`priority 100` — порядок обработки (обычно 100 для NAT).
`oif "eth0"` — выходной интерфейс (куда уходит трафик).
`ip saddr 10.200.0.0/24` — источник из VPN‑подсети.
`masquerade` — скрывает адрес источника, подменяя его адресом интерфейса.

## Особенности из нашей практики (PNETLab, Debian 10)
- Если `nft` не найден: `sudo apt update` и `sudo apt install nftables`.
- Интерфейс для NAT у нас был `ens3` (LAN-A), поэтому правило использовали с `oif "ens3"`.
- Включение ip_forward делали без `sysctl -w` (busybox):
  - `echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward` — включить сразу
  - `echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf` — чтобы было постоянно

## Примерный порядок настройки (чеклист)
1. Установить nftables.
2. (Опционально) Включить `ip_forward`, если нужен NAT.
3. Создать таблицу и цепочку `filter` с `policy drop`.
4. Разрешить `established,related`.
5. Разрешить нужные порты (SSH, WireGuard).
6. Создать таблицу/цепочку NAT и правило `masquerade`.
7. Проверить `nft list ruleset`.

## Проверки (что смотреть)
- `nft list ruleset` — видно таблицы `inet filter` и `ip nat`, цепочки и правила.
- `cat /proc/sys/net/ipv4/ip_forward` — должно быть `1`, если нужен NAT.

## Что пошло не так (и как исправили)
- `nft: command not found` — установили `nftables` через `apt`.
- Для firewall нужна таблица `inet filter` (не `ip nat`), и цепочка `input` с `policy drop`.
- Проверяли доступность сервисов через `ss -ltn | grep :22` и `ss -lun | grep 51820`.

## Сохранение правил после ребута (важно)
По умолчанию правила `nft` не сохраняются после перезагрузки. Чтобы сохранить:
```
sudo nft list ruleset | sudo tee /etc/nftables.conf
sudo systemctl enable nftables
sudo systemctl restart nftables
```
После ребута проверить:
```
sudo nft list ruleset
```
