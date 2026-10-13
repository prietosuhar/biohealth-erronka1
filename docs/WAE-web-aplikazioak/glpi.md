---
title: GLPI
---

[← Hasiera](../../index.md) · [Modulua](index.md)


# GLPI Helpdesk - Instalazioa, Konfigurazioa eta Active Directory Integrazioa

Dokumentu honek **BioHealth** enpresaren azpiegituran **Servidor 1** (`192.168.10.4`) nodoan GLPI ticket-kudeaketa eta inbentario sistema instalatzeko, Apache/PHP ingurunea konfiguratzeko eta Active Directory (`192.168.10.2`) bidezko autentifikazioa (LDAP/LDAPS) ezartzeko urrats guztiak biltzen ditu[cite: 5].

---

## 1. Ingurunearen Ezaugarriak

* **Zerbitzaria (Servidor 1):** Ubuntu Server (`192.168.10.4`)[cite: 5]
* **Web Zerbitzaria:** Apache2 (`web.biohealth.local` / `glpi.biohealth.local`)[cite: 5]
* **Datu-basea:** MariaDB / MySQL (`glpidb`)
* **Active Directory (DC / CA):** Windows Server (`192.168.10.2` - `biohealth.local`)[cite: 4]
* **Abonatu Zuzena (Base DN):** `DC=biohealth,DC=local`[cite: 4]

---

## 2. Mendekotasunak eta LAMP Stack Instalatzea

GLPI-k PHP hedapen zehatzak eta MariaDB datu-basea behar ditu. Servidor 1-en agindu hauek exekutatu ziren ingurunea prestatzeko:

sudo apt update && sudo apt upgrade -y
sudo apt install -y apache2 mariadb-server php php-curl php-gd php-cli php-mysqli php-xml php-mbstring php-intl php-ldap php-xmlrpc php-zip php-bz2 php-imap php-apcu

sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/8.x/apache2/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php/8.x/apache2/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 20M/' /etc/php/8.x/apache2/php.ini
sudo systemctl restart apache2

---

## 3. Datu-Basea Sortzea (MariaDB)

GLPI-rako datu-base espezifiko bat eta sarbide-erabiltzailea konfiguratu ziren MariaDB barruan:

sudo mariadb -u root -p

SQL kontsolaren barruan:

CREATE DATABASE glpidb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'glpi_user'@'localhost' IDENTIFIED BY 'BioHealth2026!';
GRANT ALL PRIVILEGES ON glpidb.* TO 'glpi_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

---

## 4. GLPI Deskargatzea, Instalatzea eta Baimenak Ezarri

1. **Softwarea Deskargatu eta Erauzi:**
   cd /tmp
   wget https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz
   tar -xvf glpi-10.0.10.tgz
   sudo mv glpi /var/www/html/glpi

2. **Jabetzak eta Baimenak Doitu:**
   sudo chown -R www-data:www-data /var/www/html/glpi
   sudo chmod -R 755 /var/www/html/glpi

3. **Apache VirtualHost Konfiguratu (`/etc/apache2/sites-available/glpi.conf`):**
   <VirtualHost *:80>
       ServerName glpi.biohealth.local
       DocumentRoot /var/www/html/glpi/public

       <Directory /var/www/html/glpi/public>
           AllowOverride All
           Require all granted
           RewriteEngine On
           RewriteCond %{REQUEST_FILENAME} !-f
           RewriteRule ^(.*)$ index.php [QSA,L]
       </Directory>

       ErrorLog ${APACHE_LOG_DIR}/glpi_error.log
       CustomLog ${APACHE_LOG_DIR}/glpi_access.log combined
   </VirtualHost>

4. **Gune Berria Gaitu eta Apache Berrabiarazi:**
   sudo a2enmod rewrite
   sudo a2ensite glpi.conf
   sudo systemctl restart apache2

---

## 5. Hasierako Instalazio Morroia Web Bidez

1. Nabigatzailean sartu: `https://web.biohealth.local/glpi` edo `https://glpi.biohealth.local`[cite: 5].
2. Hizkuntza hautatu (**Euskara**).
3. **Mendekotasunen egiaztapena:** Baldintza guztiak berdez agertuko dira (`php-ldap` barne).
4. **Datu-basearen konexioa:**
   * **Mota:** MySQL/MariaDB
   * **Zerbitzaria:** `localhost`
   * **Erabiltzailea:** `glpi_user`
   * **Pasahitza:** `BioHealth2026!`
   * **Datu-basea:** `glpidb` hautatu.
5. Instalazioa osatu ondoren, **segurtasun neurri garrantzitsua:**
   sudo rm /var/www/html/glpi/install/install.php

---

## 6. Active Directory (LDAP) Integrazioa Erabiltzaileak Sinkronizatzeko

Domeinuko erabiltzaileak (BioHealth-eko langileak eta teknikariak) AD bidez saioa has dezaten, GLPI eta Active Directory erlazionatu ziren LDAP protokoloaren bidez.

### 6.1. LDAP Zerbitzaria GLPI-n Konfiguratzea
1. Hasieratu saioa GLPI-n kudeatzaile kontuarekin (`glpi`/`glpi`).
2. Joan **Konfigurazioa > Autentifikazio Konfigurazioa > LDAP Direktorioak**.
3. Sakatu **`+` (Gehitu)** ikonoa eta bete eremu hauek:

* **Izena:** `BioHealth AD`
* **Lehenetsitako Zerbitzaria:** `Bai`
* **LDAP Zerbitzaria:** `192.168.10.2` *(Active Directory DC IPa)*[cite: 4]
* **Ataka:** `389` *(edo `636` LDAPS erabili nahi bada)*
* **Konexio Filtroa:** `(&(objectClass=user)(objectCategory=person)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))`
* **Base DN (Erroko Bide-izena):** `DC=biohealth,DC=local`[cite: 4]
* **Erabiltzailearen DN (Bind DN):** `CN=Administrador,CN=Users,DC=biohealth,DC=local` *(edo LDAP kontsultak egiteko sortutako zerbitzu kontua)*[cite: 13]
* **Pasahitza (Bind Password):** `[Administratzailearen Pasahitza]`
* **Saio Hasiera Eremua (Login field):** `samaccountname`

4. Sakatu **Gorde**.
5. Sakatu **Probatatu konexioa**: Erantzunak **"LDAP direktorioarekin konexioa lortu da"** izan behar du.

---

### 6.2. Atributuen Mapaketa (Field Mapping)
GLPI-k Active Directory-ko erabiltzaileen informazio pertsonala modu egokian irakur dezan, atributuen konfigurazioa honela geratu zen:

| GLPI Eremua | Active Directory Atributua |
| :--- | :--- |
| **Erabiltzaile izena (Login)** | `samaccountname` |
| **Abizena(k)** | `sn` |
| **Izena** | `givenname` |
| **E-posta** | `mail` |
| **Telefonoa** | `telephonenumber` |
| **Kokapena / Bulegoa** | `physicaldeliveryofficename` |

---

### 6.3. Erabiltzaileak Inportatzea eta Sinkronizatzea
1. Joan **Kudeaketa > Erabiltzaileak**.
2. Sakatu **LDAP direktorio batera estekatu** (edo *Inportatu erabiltzaile berriak*).
3. Hautatu **BioHealth AD** zerbitzaria eta sakatu **Bilatu**.
4. Active Directory-ko erabiltzaileen zerrenda agertuko da (`biohealth\Administrador`, etab.)[cite: 13].
5. Markatu inportatu nahi diren erabiltzaileak eta sakatu **Ekintza > Inportatu**.

> **Egiaztapena:** Erabiltzaileak inportatu ondoren, edozein langile bere Active Directory-ko domeinuko erabiltzaile eta pasahitzarekin sartu daiteke GLPI-ra, eta automatikoki bere profilaren araberako rola (Self-Service/Teknikaria) esleituko zaio.
