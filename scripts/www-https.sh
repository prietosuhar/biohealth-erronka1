#!/bin/bash
# BioHealth – www: HTTPS (ziurtagiri autosinatua) WordPress-erako
set -e
D=biohealth.local
# 1. Ziurtagiri autosinatua (365 egun, SAN: www, web, glpi)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/biohealth.key -out /etc/ssl/certs/biohealth.crt \
  -subj "/C=ES/ST=Gipuzkoa/O=BioHealth/CN=www.$D" \
  -addext "subjectAltName=DNS:www.$D,DNS:web.$D,DNS:glpi.$D"
sudo chmod 600 /etc/ssl/private/biohealth.key

# 2. HTTPS VirtualHost
sudo tee /etc/apache2/sites-available/wordpress-ssl.conf > /dev/null <<VHOST
<VirtualHost *:443>
    ServerName web.$D
    ServerAlias www.$D
    DocumentRoot /var/www/wordpress
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/biohealth.crt
    SSLCertificateKeyFile /etc/ssl/private/biohealth.key
    <Directory /var/www/wordpress>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/wordpress_ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/wordpress_ssl_access.log combined
</VirtualHost>
VHOST
sudo a2enmod ssl headers
sudo a2ensite wordpress-ssl
sudo apache2ctl configtest
sudo systemctl reload apache2

# 3. Egiaztapena
sudo ss -tlnp | grep -E ':80|:443'
openssl x509 -in /etc/ssl/certs/biohealth.crt -noout -subject -dates -ext subjectAltName
curl -skI https://localhost | head -1
