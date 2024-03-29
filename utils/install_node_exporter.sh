#!/bin/bash

# Install the necessary packages
sudo apt -q update
sudo apt -qy install curl wget

# Define the latest version of node_exporter
VERSION=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Determine the operating system
if [[ "$(uname -s)" == "Linux" ]]; then
  OS="linux"
elif [[ "$(uname -s)" == "Darwin" ]]; then
  OS="darwin"
else
  echo "Unsupported operating system"
  exit 1
fi

# Determine the architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  ARCH="arm64"
else
  echo "Unsupported architecture"
  exit 1
fi

# Download and install node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/${VERSION}/node_exporter-${VERSION}.${OS}-${ARCH}.tar.gz
tar xvf node_exporter-${VERSION}.${OS}-${ARCH}.tar.gz
rm node_exporter-${VERSION}.${OS}-${ARCH}.tar.gz
sudo mv node_exporter-${VERSION}.${OS}-${ARCH} node_exporter
chmod +x $HOME/node_exporter/node_exporter
sudo mv $HOME/node_exporter/node_exporter /usr/bin
rm -Rvf $HOME/node_exporter/

# Create a systemd service for node_exporter
sudo tee /etc/systemd/system/exporterd.service > /dev/null <<EOF
[Unit]
Description=node_exporter
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/node_exporter
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

# Enable and start the node_exporter service
sudo systemctl daemon-reload
sudo systemctl enable exporterd
sudo systemctl start exporterd
