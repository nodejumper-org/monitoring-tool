#!/bin/bash

function print {
  echo -e "\033[34m==============================\033[0m"
  echo -e "\033[34m$1\033[0m"
  echo -e "\033[34m==============================\033[0m"
}

function printError {
  echo -e "\033[34m==============================\033[0m"
  echo -e "\033[31m$1\033[0m"
  echo -e "\033[34m==============================\033[0m"
}

function printLogo {
  bash <(curl -s https://raw.githubusercontent.com/nodejumper-org/cosmos-utils/main/utils/logo.sh)
}

function installDependencies {
  local pkgs=("docker-ce" "docker-ce-cli" "containerd.io" "docker-compose-plugin")

  for pkg in "${pkgs[@]}"; do
    # shellcheck disable=SC2155
    local pkg_installed=$(dpkg-query -W --showformat='${Status}\n' $pkg 2>/dev/null|grep "install ok installed")
    if [ "" = "$pkg_installed" ]; then
      print "Installing docker with compose"
      bash <(curl -s https://raw.githubusercontent.com/nodejumper-org/monitoring-tool/main/utils/install_docker.sh)
      break
    fi
  done

  git_installed=$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")
  if [ "" = "$git_installed" ]; then
    print "Installing git"
    sudo apt install -y git
  fi
}

printLogo

installDependencies

if [ -d "$HOME/monitoring-tool" ]; then
  printError "Directory ${HOME}/monitoring-tool already exist. Exiting..."
  exit 1
fi

print "Installing monitoring-tool"

# clone the repo
cd "$HOME" || return
git clone https://github.com/nodejumper-org/monitoring-tool.git

# create config files
cd monitoring-tool || return
cp prometheus/prometheus.yml.example prometheus/prometheus.yml
cp alertmanager/config.yml.example alertmanager/config.yml

print "Starting monitoring-tool"
sudo docker compose up -d

print "Success! Open in your browser http://$(curl -s eth0.me); default credentials: admin\admin"
