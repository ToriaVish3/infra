# WireGuard

## Ссылки (с описанием)
- https://obu4alka.ru/vpn-wireguard-install-ubuntu-debian.html — установка и конфиг на Debian/Ubuntu
- https://stavis-dev.github.io/manuals/wireguard/ — практический гайд
- https://www.wireguard.com/quickstart/ — официальный quick start (EN)

## Команды (шпаргалка: команда — что делает)
- `apt install -y wireguard` — установить WireGuard
- `wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey` — создать ключи
- `chmod 600 /etc/wireguard/privatekey` — защитить приватный ключ
- `wg-quick up wg0` — поднять туннель wg0
- `wg-quick down wg0` — опустить туннель wg0
- `wg show` — показать текущие сессии

## Мини-конфиг сервера /etc/wireguard/wg0.conf
```ini
[Interface]
Address = 10.200.0.1/24
ListenPort = 51820
PrivateKey = <server_private_key>

[Peer]
PublicKey = <client_public_key>
AllowedIPs = 10.200.0.2/32
PersistentKeepalive = 10
```

## Дополнительные команды (шпаргалка: команда — что делает)
- `wg show wg0` — детали по интерфейсу wg0
- `wg showconf wg0` — текущая конфигурация
- `ip a show wg0` — адреса интерфейса
- `ip route | grep 10.200.0.0` — маршрут VPN сети
- `journalctl -u wg-quick@wg0 -f` — логи wg-quick
- `systemctl status wg-quick@wg0` — статус сервиса
