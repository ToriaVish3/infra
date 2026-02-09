# Пошаговые инструкции

Этот файл содержит только инструкции и варианты. Ссылки лежат в тематических файлах.


1) Контейнеризация (Docker/Compose) — варианты
Вариант A: один сервис через docker run
1. Установи Docker: apt update && apt install docker.io
2. Запусти контейнер: docker run -d --name web -p 8080:80 nginx:alpine
3. Проверка: curl http://<ip>:8080

Вариант B: docker-compose.yml (предпочтительно)
1. Создай /opt/app/docker-compose.yml:
   services:
     web:
       image: nginx:alpine
       ports:
         - "8080:80"
       volumes:
         - ./html:/usr/share/nginx/html:ro
2. Создай /opt/app/html/index.html
3. Запусти: docker compose up -d
4. Проверка: curl http://<ip>:8080

Вариант C: Dockerfile (своё содержимое)
1. Создай Dockerfile:
   FROM nginx:alpine
   COPY html/ /usr/share/nginx/html/
2. Собери и запусти:
   docker build -t myweb .
   docker run -d -p 8080:80 myweb

2) Reverse proxy (nginx) — варианты
Вариант A: HTTP proxy
1. /etc/nginx/sites-available/app:
   server {
     listen 80;
     location / { proxy_pass http://10.20.20.10:8080; }
   }
2. ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/
3. nginx -t && systemctl reload nginx

Вариант B: HTTPS + редирект
1. openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
   -keyout /etc/ssl/private/rp.key -out /etc/ssl/certs/rp.crt
2. Конфиг:
   server { listen 80; return 301 https://$host$request_uri; }
   server {
     listen 443 ssl;
     ssl_certificate /etc/ssl/certs/rp.crt;
     ssl_certificate_key /etc/ssl/private/rp.key;
     location / { proxy_pass http://10.20.20.10:8080; }
   }

3) WireGuard — варианты
Вариант A: wg-quick
1. wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey
2. /etc/wireguard/wg0.conf:
   [Interface]
   Address = 10.200.0.1/24
   ListenPort = 51820
   PrivateKey = <privatekey>
   [Peer]
   PublicKey = <client_pub>
   AllowedIPs = 10.200.0.2/32
3. wg-quick up wg0; systemctl enable wg-quick@wg0

Вариант B: ручной (wg set + ip)
1. ip link add wg0 type wireguard
2. ip address add 10.200.0.1/24 dev wg0
3. wg set wg0 listen-port 51820 private-key /etc/wireguard/privatekey
4. wg set wg0 peer <client_pub> allowed-ips 10.200.0.2/32
5. ip link set up dev wg0

4) NAT/Firewall — варианты
Вариант A: nftables (минимум)
1. sysctl -w net.ipv4.ip_forward=1
2. nft add table ip nat
3. nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }
4. nft add rule ip nat postrouting oif "<iface>" ip saddr 10.200.0.0/24 masquerade

Вариант B: nftables (filter + stateful)
1. nft add table inet filter
2. nft add chain inet filter input { type filter hook input priority 0 \; policy drop \; }
3. nft add rule inet filter input ct state established,related accept
4. nft add rule inet filter input tcp dport 22 accept
5. nft add rule inet filter input udp dport 51820 accept

5) Мониторинг (Prometheus + Grafana) — варианты
Вариант A: пакеты Debian
1. apt install prometheus prometheus-node-exporter grafana
2. /etc/prometheus/prometheus.yml:
   - job_name: "app"
     static_configs:
       - targets: ["10.20.20.10:9100"]
3. systemctl restart prometheus
4. Grafana: добавить datasource Prometheus (http://localhost:9090)

Вариант B: контейнеры
1. docker run -d --name prom -p 9090:9090 prom/prometheus
2. docker run -d --name graf -p 3000:3000 grafana/grafana
3. В prom добавь scrape_configs через конфиг/volume.

6) Логи и ротация — варианты
Вариант A: logrotate (nginx)
1. Проверь /etc/logrotate.d/nginx
2. logrotate -d /etc/logrotate.d/nginx
3. logrotate -f /etc/logrotate.d/nginx

Вариант B: ручная ротация
1. mv /var/log/nginx/access.log /var/log/nginx/access.log.1
2. systemctl reload nginx

7) Бэкап — варианты
Вариант A: rsync по SSH
1. На сервере‑получателе: mkdir -p /backup/app
2. На источнике: rsync -avz /etc/nginx /opt/app/docker-compose.yml user@host:/backup/app/
3. Расписание: crontab -e

Вариант B: tar + scp
1. tar -czf /tmp/app-backup.tgz /etc/nginx /opt/app/docker-compose.yml
2. scp /tmp/app-backup.tgz user@host:/backup/app/
