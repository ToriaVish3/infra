# iptables-legacy vs nftables

## Ссылки (с описанием)
- https://wiki.debian.org/iptables — Debian Wiki: переключение iptables-nft/iptables-legacy (EN)
- https://wiki.debian.org/nftables — Debian Wiki: nftables и legacy (EN)

## Команды (шпаргалка: команда — что делает)
- `update-alternatives --set iptables /usr/sbin/iptables-nft` — переключить на iptables-nft
- `update-alternatives --set iptables /usr/sbin/iptables-legacy` — переключить на iptables-legacy
- `iptables -L` — показать текущие правила iptables
- `nft list ruleset` — показать правила nftables
