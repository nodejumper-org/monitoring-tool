# monitoring-tool

> A powerful and easy-to-use monitoring tool for server hardware and validator nodes with alerts via telegram bot and grafana dashboards

## Includes

### Containers
- [grafana sever](https://hub.docker.com/r/grafana/grafana)
- [node_exporter](https://hub.docker.com/r/prom/node-exporter)
- [prometheus](https://hub.docker.com/r/prom/prometheus)
- [alertmanager](https://hub.docker.com/r/prom/alertmanager)

### Dashboards
- [Node Exporter Full dashboard](https://github.com/rfrail3/grafana-dashboards)
- [Node Exporter for Prometheus Dashboard EN](https://github.com/starsliao/Prometheus/tree/master/node_exporter)
- Cosmos-based Chain Validator Dashboard (my own dashboard)

### Alerts
#### Server alerts
- Server down
- Out of memory (<10%)
- Out of disk space (<10%)
- Out of disk space within 24h
- High CPU load (>85%)

#### Cosmos-based validator node alerts
- Missing blocks
- Degraded syncing (sync less than 20 blocks in last 5 min)
- Low peers count (<3)

## How to run
### Automatic installation
```
bash <(curl -s https://raw.githubusercontent.com/nodejumper-org/monitoring-tool/main/utils/install.sh)
```

### Manual installation
1. Install docker
```
bash <(curl -s https://raw.githubusercontent.com/nodejumper-org/monitoring-tool/main/utils/install_docker.sh)
```

2. Clone the repo
```
cd ~
git clone https://github.com/nodejumper-org/monitoring-tool.git 
```

3. Create configuration files from examples
```
cd monitoring-tool
cp .env.example .env
cp prometheus/prometheus.yml.example prometheus/prometheus.yml
```

4. Edit `.env` and `prometheus/prometheus.yml` config files

5. Start containers
```
sudo docker compose up -d
```

6. Open in browser http://<your_server_ip>:3000 or http://<your_domain_name> <br>
default credentials: admin/admin

## How to configure
### Servers to monitor
Add your servers with installed [node_exporter](https://github.com/prometheus/node_exporter) or installed cosmos-based node with enabled prometheus port to file <b>prometheus/prometheus.yml</b>
```
  # example for servers with node_exporter installed
  - job_name: "my-servers"
    static_configs:
    - targets: ["172.0.0.1:9100"]
      labels:
        instance: "server1"
    - targets: ["172.0.0.2:9100"]
      labels:
        instance: "server2"
    
  # example for servers with node_exporter and cosmos-based node installed
  - job_name: "cosmos-validator-nodes"
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
### Telegram notifications
In order to enable telegram notifications, create your own bot and fill in the following fields in the file <b>alertmanager/config.yml</b>
```
chat_id=1111111                 # your telegram user id
bot_token=11111111:AAG_XXXXXXX  # your telegram bot token
```
## How to install node_exporter
Just run next command 
```
bash <(curl https://raw.githubusercontent.com/nodejumper-org/monitoring-tool/main/utils/install_node_exporter.sh)
```

## How to update
Just run next commands 
```
cd monitoring-tool
sudo docker-compose down
git pull
sudo docker compose pull
sudo docker compose up -d
```
