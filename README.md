# monitoring-tool

> Server hardware and validotor nodes monitoring tool with alert via telegram bot

## Includes:

#### Containers:
- [grafana sever](https://hub.docker.com/r/grafana/grafana)
- [node_exporter](https://hub.docker.com/r/prom/node-exporter)
- [prometheus](https://hub.docker.com/r/prom/prometheus)
- [alertmanager](https://hub.docker.com/r/prom/alertmanager)
- [alertmanager_bot (telegram)](https://hub.docker.com/r/metalmatze/alertmanager-bot)

#### Dashboards:
 - [Node Exporter Full dashboard](https://github.com/rfrail3/grafana-dashboards)
 - [Cyberomanov dashboard](https://github.com/cyberomanov/grafana)

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

3. Start containers
```
cd monitoring-tool
sudo docker-compose up -d
```

4. Open in browser https://<your_server_ip>:3000
default credentials: admin\admin

## Configure

Telegram bot notifications (in <b>docker-compose.yaml</b>)
```
TELEGRAM_ADMIN=1111111              # your telegram user id
TELEGRAM_TOKEN=11111111:AAG_XXXXXXX # your telegram bot token
```

Add other servers (in <b>prometheus/prometheus.yml</b>)
```
    - targets: ["172.0.0.0:1234"]
      labels:
        label: "server1"
        
    - targets: ["192.0.0.0:2222"]
      labels:
        label: "server2"
```
