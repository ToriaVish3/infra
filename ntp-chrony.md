# NTP / Chrony

## Ссылки (с описанием)
- https://support.kaspersky.ru/kuma/3.2/255123 — установка chrony и базовые команды (RU)
- https://platformv.sbertech.ru/docs/public/SLO/9.0-fstec/common/documents/pfstec/administration-guide/chrony.conf.html — примеры директив chrony.conf (RU)
- https://manpages.debian.org/chrony.conf — chrony.conf(5) (EN, полный список директив)
- https://manpages.debian.org/chronyd — chronyd(8) (EN, параметры демона)

## Команды (шпаргалка: команда — что делает)
- `apt install chrony` — установить chrony
- `systemctl enable --now chronyd` — включить и запустить сервис
- `systemctl status chronyd` — статус сервиса
- `chronyc tracking` — проверить синхронизацию
- `chronyc sources -v` — источники времени
- `timedatectl | grep 'System clock synchronized'` — проверить состояние синхронизации

## Мини‑пример /etc/chrony/chrony.conf
```
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst
server 3.pool.ntp.org iburst
allow 10.0.0.0/8
logdir /var/log/chrony
makestep 1 3
```
