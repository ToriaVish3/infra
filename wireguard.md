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

## Debian 10 (buster) и семейство Debian: как ставили в этой лабе

### Что пришлось добавить, чтобы `apt` нашёл WireGuard (Debian 10)
Для Debian 10 пакет может быть в backports, поэтому добавляли файл:
```
echo "deb http://archive.debian.org/debian buster-backports main contrib non-free" | sudo tee /etc/apt/sources.list.d/buster-backports.list
```
Затем:
```
sudo apt update
sudo apt install debian-archive-keyring
sudo apt -t buster-backports install wireguard
```

### Если `wg-quick up wg0` пишет `Operation not supported`
Это значит, что в ядре нет модуля WireGuard. В этой ситуации ставили заголовки и DKMS:
```
sudo apt update
sudo apt install linux-headers-amd64 wireguard-dkms
sudo modprobe wireguard
```
Если модуль всё равно не находится, значит система всё ещё загружена со старым ядром.
В этом случае:
```
sudo apt install linux-image-amd64
sudo reboot
```
После перезагрузки проверить:
```
uname -r
```
Должна быть более новая версия (не `4.19.0-6-amd64`).

### Дописать в конфиг для NAT (отдельно)
В файл `/etc/wireguard/wg0.conf` добавляли строки `PostUp` и `PostDown`:
```
PostUp = nft add table ip nat; nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }; nft add rule ip nat postrouting oif "<iface_to_LAN_A>" ip saddr 10.200.0.0/24 masquerade
PostDown = nft delete table ip nat
```
`<iface_to_LAN_A>` — это интерфейс, который смотрит в LAN-A (например, `ens3`).
Если при поднятии пишет `nft: command not found`, установить:
```
sudo apt install nftables
```

### Полная последовательность шагов (Debian и Debian-based)
1. Обновить списки пакетов:
   `sudo apt update`
2. Установить WireGuard:
   `sudo apt install -y wireguard`
3. Сгенерировать ключи:
   `wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey`
4. Защитить приватный ключ:
   `chmod 600 /etc/wireguard/privatekey`
5. Создать конфиг `/etc/wireguard/wg0.conf`:
   ```
   [Interface]
   Address = 10.200.0.1/24
   ListenPort = 51820
   PrivateKey = <server_private_key>
   PostUp = nft add table ip nat; nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }; nft add rule ip nat postrouting oif "<iface_to_LAN_A>" ip saddr 10.200.0.0/24 masquerade
   PostDown = nft delete table ip nat

   [Peer]
   PublicKey = <client_public_key>
   AllowedIPs = 10.200.0.2/32
   PersistentKeepalive = 10
   ```
6. Включить маршрутизацию:
   `sudo sysctl -w net.ipv4.ip_forward=1`
7. Сделать `ip_forward` постоянным:
   `echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf`
8. Поднять туннель:
   `sudo wg-quick up wg0`
9. Включить автозапуск:
   `sudo systemctl enable wg-quick@wg0`

### Типовые ошибки конфигурации (что исправляли)
- Строки `PublicKey` и `AllowedIPs` должны быть в секции `[Peer]`.
- Параметр называется `AllowedIPs`, не `AllowIPs`.
