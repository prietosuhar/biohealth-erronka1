#!/bin/bash
# BioHealth – db01: CUPS inprimaketa-zerbitzaria + CUPS-PDF inprimagailu birtuala (LANean partekatua)
set -e
P=INPR-INFORMATIKA

# 1. Instalazioa: CUPS, PDF inprimagailu birtuala eta SMB bezeroa (Windows-eko inprimagailuetara inprimatzeko)
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq cups printer-driver-cups-pdf smbclient

# 2. Partekatzea: 631 ataka sarean entzun eta inprimagailuak LANean partekatu (@LOCAL = tokiko sarea)
sudo cupsctl --share-printers --remote-admin
sudo systemctl restart cups

# 3. Inprimagailua sortu (CUPS-PDF), partekatu eta gaitu
PPD=$(lpinfo -m | grep -i 'cups-pdf' | head -1 | awk '{print $1}')
sudo lpadmin -p "$P" -E -v cups-pdf:/ -m "$PPD" \
  -D "Informatika - PDF inprimagailua (CUPS)" -L "Informatika - CPD" \
  -o printer-is-shared=true
sudo cupsenable "$P"
sudo cupsaccept "$P"

# 4. Suebakia: 631 LANetik bakarrik
sudo ufw allow from 192.168.10.0/24 to any port 631 proto tcp comment 'LAN -> CUPS'

# 5. Egiaztapena
echo "=== Zerbitzua ==="; systemctl is-active cups
echo "=== Entzuten ==="; sudo ss -tlnp | grep 631
echo "=== Inprimagailuak ==="; lpstat -t
echo "=== ufw ==="; sudo ufw status | grep 631
echo "=== Proba tokikoa (db01-etik bertatik) ==="
echo "Proba - db01 - CUPS - $(date)" | lp -d "$P"
sleep 4
ls -l ~/PDF/ 2>/dev/null || sudo ls -l /var/spool/cups-pdf/*/
