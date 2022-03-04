# monitoring-tool

> Server hardware and validotor nodes monitoring tool with alerts via telegram bot

## Includes

#### Containers
- [grafana sever](https://hub.docker.com/r/grafana/grafana)
- [node_exporter](https://hub.docker.com/r/prom/node-exporter)
- [prometheus](https://hub.docker.com/r/prom/prometheus)
- [alertmanager](https://hub.docker.com/r/prom/alertmanager)
- [alertmanager_bot (telegram)](https://hub.docker.com/r/metalmatze/alertmanager-bot)

#### Dashboards
- [Node Exporter Full dashboard](https://github.com/rfrail3/grafana-dashboards)
- [Node Exporter for Prometheus Dashboard EN 20201010](https://github.com/starsliao/Prometheus/tree/master/node_exporter)
- Cosmos-based Chain Validator Dashboard (my own dashboard)

#### Alerts
> Server
- Server down
- Out of memory (<10%)
- Out of disk space (<10%)
- Out of disk space within 24h
- High CPU load (>85%)

> Cosmos-based validator
- Missing blocks
- Degraded syncing
- Low peers count (<5)

## How to run

1. Install docker
```
curl -s https://raw.githubusercontent.com/vbloher/monitoring-tool/main/utils/install_docker.sh | bash
```

2. Clone the repo
```
cd ~
git clone https://github.com/vbloher/monitoring-tool.git 
```

3. Create configuration file from example
```
cd monitoring-tool
cp prometheus/prometheus.yml.example prometheus/prometheus.yml
```

4. Start containers
```
sudo docker-compose up -d
```

4. Open in browser https://<your_server_ip>:3000 <br>
default credentials: admin\admin

## Configure

Telegram bot notifications (in <b>docker-compose.yaml</b>)
```
TELEGRAM_ADMIN=1111111              # your telegram user id
TELEGRAM_TOKEN=11111111:AAG_XXXXXXX # your telegram bot token
```

Add other servers (in <b>prometheus/prometheus.yml</b>)
```
  # for node_exporter
  - job_name: "servers"
    static_configs:
    - targets: ["172.0.0.1:9100"]
      labels:
        instance: "server1"
    - targets: ["172.0.0.2:9100"]
      labels:
        instance: "server2"
    
  # for cosmos-based validator node with node_exporter installed and prometheus enabled
  - job_name: "cosmos-validator"
    static_configs:
    - targets: ["192.0.0.1:9100","192.0.0.1:26660"]
      labels:
        instance: "sentry1"
    - targets: ["192.0.0.2:9100","192.0.0.2:26660"]
      labels:
        instance: "sentry2"
    - targets: ["192.0.0.3:9100","192.0.0.3:26660"]
      labels:
        instance: "validator"
```
