# How to configure SSL

Add new repository
```
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository universe
sudo apt update
```

Install certbot and create certs for your domain
```
sudo apt install -y certbot
sudo certbot certonly --standalone
```

Copy certs to grafana `/opt/ssl` dir. Replace YOUR-DOMAIN-NAME with correct one
```
DOMAIN=YOUR-DOMAIN-NAME
mkdir -p /opt/ssl
sudo cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem /opt/ssl/
sudo cp /etc/letsencrypt/live/$DOMAIN/privkey.pem /opt/ssl/
sudo chown 472:0 /opt/ssl/*.pem
```

Uncomment this part of docker-compose grafana service
```
    environment:
      - GF_SERVER_PROTOCOL=https
      - GF_SERVER_CERT_FILE=/etc/grafana/ssl/fullchain.pem
      - GF_SERVER_CERT_KEY=/etc/grafana/ssl/privkey.pem
```

Replace ports for https
```
    ports:
      - 433:3000
```

Recreate grafana docker container with new config using next command
```
cd ~/monitoring-tool
sudo docker-compose up -d
```
