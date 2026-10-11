#!/bin/bash
# BioHealth – www (DMZ, 192.168.20.10): Apache + PHP + WordPress
# Datu-basea db01-en dago (192.168.10.3, DB: wordpress, erabiltzailea: wp_user)
set -e

# 1. Paketeak
sudo apt update
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-curl php-gd \
  php-mbstring php-xml php-zip php-intl unzip

# 2. Suebakia (ufw): HTTP eta HTTPS ireki
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 3. WordPress deskargatu eta kopiatu
cd /tmp && wget -q https://wordpress.org/latest.tar.gz && tar xzf latest.tar.gz
sudo mkdir -p /var/www/wordpress
sudo cp -r /tmp/wordpress/. /var/www/wordpress/
sudo chown -R www-data:www-data /var/www/wordpress

# 4. Apache VirtualHost
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<'VHOST'
<VirtualHost *:80>
    ServerName web.biohealth.local
    ServerAlias www.biohealth.local
    DocumentRoot /var/www/wordpress
    <Directory /var/www/wordpress>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/wordpress_error.log
    CustomLog ${APACHE_LOG_DIR}/wordpress_access.log combined
</VirtualHost>
VHOST
sudo a2ensite wordpress
sudo a2dissite 000-default
sudo a2enmod rewrite
sudo systemctl reload apache2

# 5. Egiaztapena
apache2 -v
php -v | head -1
sudo ufw status
curl -sI http://localhost | head -1
