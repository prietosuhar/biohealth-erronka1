#!/bin/bash
# BioHealth – www: HTTP → HTTPS birbideratzea (WordPress-en URLak https-ra aldatu ONDOREN exekutatu)
set -e
D=biohealth.local
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<VHOST
<VirtualHost *:80>
    ServerName web.$D
    ServerAlias www.$D
    Redirect permanent / https://www.$D/
</VirtualHost>
VHOST
sudo apache2ctl configtest
sudo systemctl reload apache2
curl -sI http://localhost | head -3
