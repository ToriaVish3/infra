# OpenVPN

## Ссылки (с описанием)
- https://wiki.debian.org/OpenVPN — Debian Wiki: установка и конфигурация (EN, с командами)
- https://openvpn.net/community-docs/community-articles/openvpn-2-4-manual.html — официальный мануал OpenVPN 2.4 (EN)

## Команды (шпаргалка: команда — что делает)
- `apt install openvpn easy-rsa -y` — установка OpenVPN и Easy-RSA
- `./easyrsa init-pki` — инициализировать PKI
- `./easyrsa build-ca nopass` — создать CA
- `./easyrsa build-server-full server nopass` — сертификат сервера
- `./easyrsa build-client-full client1 nopass` — сертификат клиента
- `./easyrsa gen-dh` — DH параметры
- `openvpn --genkey secret /etc/openvpn/server/ta.key` — TLS-auth key
- `systemctl start openvpn-server@server` — запуск сервера (Debian)
- `systemctl enable openvpn-server@server` — автозапуск сервера

## Мини-конфиг /etc/openvpn/server/server.conf
```
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
server 10.8.0.0 255.255.255.0
keepalive 10 120
persist-key
persist-tun
user nobody
group nogroup
```
