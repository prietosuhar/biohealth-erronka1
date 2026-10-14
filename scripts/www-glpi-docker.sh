#!/bin/bash
# BioHealth – www (DMZ, 192.168.20.10): GLPI 10 KONTENEDORE batean (Docker)
#  - Datu-basea: db01-eko MariaDB 10.3 (192.168.10.3), `glpi` DB eta `glpi_user`@192.168.20.10 (lehendik sortuta)
#  - GLPI 10.0 erabiltzen da: GLPI 11-k MariaDB >= 10.6 behar du eta db01-ek 10.3 du
#  - Kontenedorea 127.0.0.1:8080-n bakarrik → Apache-k HTTPS bidez argitaratzen du (glpi.biohealth.local)
# Erabilera:  bash www-glpi-docker.sh 10.0.20      (etiketa: hub.docker.com/r/glpi/glpi/tags → azken 10.0.x)
set -e
D=biohealth.local
TAG=${1:?"Erabilera: $0 <glpi/glpi etiketa, adib. 10.0.20>"}
read -r -s -p "glpi_user-en pasahitza (db01): " DBPASS; echo

# 1. Docker instalatu (Ubuntu 20.04 biltegitik)
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker.io
sudo systemctl enable --now docker

# 2. Aurretik: www → db01:3306 konexioa (pfSense 1. araua + db01-eko ufw)
mysql -h 192.168.10.3 -u glpi_user -p"$DBPASS" -e "SELECT VERSION(); SHOW DATABASES;"

# 3. GLPI kontenedorea (datuak glpi_data bolumenean; 8080 localhost-en bakarrik → ez da ufw/pfSense saihesten)
sudo docker volume create glpi_data
sudo docker rm -f glpi 2>/dev/null || true
sudo docker run -d --name glpi --restart unless-stopped \
  -p 127.0.0.1:8080:80 \
  -v glpi_data:/var/glpi \
  -e GLPI_DB_HOST=192.168.10.3 -e GLPI_DB_PORT=3306 -e GLPI_DB_NAME=glpi \
  -e GLPI_DB_USER=glpi_user -e GLPI_DB_PASSWORD="$DBPASS" \
  "glpi/glpi:$TAG"

# 4. Apache: alderantzizko proxya HTTPS-rekin (ziurtagiriak jada badu SAN glpi.biohealth.local)
sudo tee /etc/apache2/sites-available/glpi-ssl.conf > /dev/null <<VHOST
<VirtualHost *:443>
    ServerName glpi.$D
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/biohealth.crt
    SSLCertificateKeyFile /etc/ssl/private/biohealth.key
    ProxyPreserveHost On
    RequestHeader set X-Forwarded-Proto "https"
    ProxyPass        / http://127.0.0.1:8080/
    ProxyPassReverse / http://127.0.0.1:8080/
    ErrorLog \${APACHE_LOG_DIR}/glpi_ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/glpi_ssl_access.log combined
</VirtualHost>
<VirtualHost *:80>
    ServerName glpi.$D
    Redirect permanent / https://glpi.$D/
</VirtualHost>
VHOST
sudo a2enmod -q proxy proxy_http headers ssl
sudo a2ensite -q glpi-ssl
sudo apache2ctl configtest
sudo systemctl reload apache2

# 5. Egiaztapena (lehen abiaraztean GLPIk datu-basea instalatzen du: 1-3 min)
echo "=== Kontenedoreak ==="; sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
echo "=== Entzuten ==="; sudo ss -tlnp | grep -E ':80 |:443 |:8080 '
echo "=== GLPI logak (azkenak) ==="; sleep 20; sudo docker logs --tail 15 glpi
echo "=== HTTP probak ==="
curl -sI http://127.0.0.1:8080 | head -1
curl -skI --resolve glpi.$D:443:127.0.0.1 https://glpi.$D | head -1
echo "Nabigatzailetik (BEZ-WIN01): https://glpi.$D  →  glpi/glpi (ALDATU pasahitza berehala)"
