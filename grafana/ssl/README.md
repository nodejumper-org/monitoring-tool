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

Copy certs to grafana ssl dir. Replace YOUR-DOMAIN-NAME with correct one
```
sudo cp /etc/letsencrypt/live/YOUR-DOMAIN-NAME/fullchain.pem ~/monitoring-tool/grafana/ssl/
sudo cp /etc/letsencrypt/live/YOUR-DOMAIN-NAME/privkey.pem ~/monitoring-tool/grafana/ssl/
sudo chown 472:0 ~/monitoring-tool/grafana/ssl/*.pem
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

Recreate grafana service using next command
```
cd ~/monitoring-tool
sudo docker-compose up -d
```
