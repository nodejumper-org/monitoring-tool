#!/bin/bash

NC="\033[0m"    # no color
BLUE="\33[34m"  # blue

function print {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}==============================${NC}"
}

bash <(curl -s https://raw.githubusercontent.com/vbloher/bash-tools/main/logo2.sh)

# check dependencies and install docker
DOCKER_PKG="docker-ce"
DOCKER_OK=$(dpkg-query -W --showformat='${Status}\n' $DOCKER_PKG|grep "install ok installed")
COMPOSE_PKG="docker-compose-plugin"
COMPOSE_OK=$(dpkg-query -W --showformat='${Status}\n' $COMPOSE_PKG|grep "install ok installed")
if [ "" = "$DOCKER_OK" ] || [ "" = "$COMPOSE_OK" ]; then
  print "Installing docker with compose"
  bash <(curl -s https://raw.githubusercontent.com/vbloher/monitoring-tool/main/utils/install_docker.sh)
fi

print "Installing monitoring-tool"

# clone the repo
cd "$HOME" || return
git clone https://github.com/vbloher/monitoring-tool.git

# create config files
cd monitoring-tool || return
cp docker-compose.yml.example docker-compose.yml
cp prometheus/prometheus.yml.example prometheus/prometheus.yml
cp alertmanager/config.yml.example alertmanager/config.yml

print "Starting monitoring-tool"
sudo docker compose up -d

print "Success! Open in your browser http://$(wget -qO- eth0.me)"
