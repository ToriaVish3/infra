# Monitoring (Prometheus + Grafana)

## Ссылки (с описанием)
- https://prometheus.io/docs/prometheus/latest/getting_started/ — старт Prometheus
- https://prometheus.io/docs/guides/node-exporter/ — node_exporter
- https://grafana.com/docs/grafana/latest/datasources/prometheus/configure-prometheus-data-source/ — data source

## Команды (шпаргалка: команда — что делает)
- `apt install prometheus` — установить Prometheus
- `apt install prometheus-node-exporter` — установить node_exporter
- `systemctl restart prometheus` — перезапустить Prometheus
- `systemctl status prometheus-node-exporter` — проверить node_exporter

## Мини-конфиг prometheus.yml
```yaml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: "app"
    static_configs:
      - targets: ["10.20.20.10:9100"]
```

## Grafana
- `systemctl enable --now grafana-server` — включить Grafana
- Web UI: добавить Prometheus data source (http://<prometheus_ip>:9090)

## Дополнительные команды (шпаргалка: команда — что делает)
- `curl http://localhost:9090/-/healthy` — health‑check Prometheus
- `curl http://localhost:9090/api/v1/targets` — проверить targets через API
- `systemctl status grafana-server` — статус Grafana
- `journalctl -u grafana-server -f` — логи Grafana
