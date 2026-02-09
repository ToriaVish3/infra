# Keepalived (VRRP)

## Ссылки (с описанием)
- https://keepalived.org/ — официальный сайт
- https://www.keepalived.org/manpage.html — man page с параметрами

## Команды (шпаргалка: команда — что делает)
- `apt install keepalived -y` — установить keepalived
- `systemctl enable --now keepalived` — запустить и включить автозапуск
- `systemctl status keepalived` — статус сервиса
- `journalctl -u keepalived -f` — логи

## Мини‑пример keepalived.conf
```
vrrp_instance VI_1 {
  state MASTER
  interface eth0
  virtual_router_id 51
  priority 100
  advert_int 1
  authentication {
    auth_type PASS
    auth_pass 42
  }
  virtual_ipaddress {
    192.168.10.254/24
  }
}
```
