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

## NAT (пример)
- `nft add table ip nat` — создать таблицу nat
- `nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }` — цепочка postrouting
- `nft add rule ip nat postrouting oif "eth0" ip saddr 10.200.0.0/24 masquerade` — NAT для VPN подсети
