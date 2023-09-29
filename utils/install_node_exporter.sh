#!/bin/bash

# Check the architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$(uname -m)" == "armv7l" ]]; then
  ARCH="arm"
else
  echo "Unsupported architecture"
  exit 1
fi

# Determine the operating system
if [[ "$(uname -s)" == "Linux" ]]; then
  OS="linux"
elif [[ "$(uname -s)" == "Darwin" ]]; then
  OS="darwin"
else
  echo "Unsupported operating system"
  exit 1
fi

VERSION=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep tag_name | cut -d '"' -f 4)
URL="https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-$VERSION.$OS-$ARCH.tar.gz"

# Create a temporary directory for downloading and installation
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download and unpack node_exporter
curl -LO "$URL"
tar xzf "node_exporter-$VERSION.$OS-$ARCH.tar.gz"
sudo cp "node_exporter-$VERSION.$OS-$ARCH/node_exporter" /usr/local/bin/

# Create a systemd unit file
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=node_exporter
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/node_exporter
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start the service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Clean up the temporary directory
rm -rf "$TMP_DIR"

echo "Node Exporter version $VERSION successfully installed and started."
