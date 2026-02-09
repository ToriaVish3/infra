# Proxmox VE

## Ссылки (с описанием)
- https://pve.proxmox.com/pve-docs/index.html — индекс документации Proxmox VE (EN, HTML/PDF)
- https://www.proxmox.com/en/downloads/proxmox-virtual-environment/documentation/proxmox-ve-admin-guide-for-9-x — Admin Guide 9.x PDF
- https://www.proxmox.com/en/downloads/proxmox-virtual-environment/documentation/proxmox-ve-admin-guide-for-8-x — Admin Guide 8.x PDF

## Команды (шпаргалка: команда — что делает)
- `pveversion -v` — версия Proxmox VE
- `pvesm status` — состояние хранилищ
- `qm list` — список ВМ (QEMU)
- `qm start <id>` — старт ВМ
- `qm stop <id>` — останов ВМ
- `pct list` — список контейнеров (LXC)
- `pct start <id>` — старт контейнера
- `pct stop <id>` — останов контейнера
- `pvecm status` — статус кластера

## Полезные разделы в админ‑гайде
- Сеть (bridges/VLAN)
- Storage
- Firewall
- Backup & Restore
