---
title: GLPI
---

[← Hasiera](../../index.md) · [Modulua](index.md)


# GLPI Helpdesk - Instalazioa, Konfigurazioa, Active Directory Integrazioa eta Trazabilitatea

Dokumentu honek **BioHealth** enpresaren azpiegituran **Servidor 1** (`192.168.10.4`) nodoan GLPI ticket-kudeaketa eta inbentario sistema instalatzeko, Apache/PHP ingurunea konfiguratzeko, Active Directory (`192.168.10.1` - `biohealth.local`) bidezko LDAP autentifikazioa ezartzeko eta "Erronka" ebaluaziorako beharrezkoak diren inbentario zein ticketen trazabilitatea frogatzeko urrats guztiak biltzen ditu.

---

## 1. Ingurunearen Ezaugarriak

* **Zerbitzaria (Servidor 1):** Ubuntu Server (`192.168.10.4`)
* **Web Zerbitzaria:** Apache2 (`web.biohealth.local` / `glpi.biohealth.local`)
* **Datu-basea:** MariaDB / MySQL (`glpidb`)
* **Active Directory (DC / CA):** Windows Server (`192.168.10.1` - `biohealth.local`)
* **Abonatu Zuzena (Base DN):** `DC=biohealth,DC=local`

---

## 2. Mendekotasunak eta LAMP Stack Instalatzea

GLPI-k PHP hedapen zehatzak eta MariaDB datu-basea behar ditu. Servidor 1-en agindu hauek exekutatu ziren ingurunea prestatzeko:
```
sudo apt update && sudo apt upgrade -y
sudo apt install -y apache2 mariadb-server php php-curl php-gd php-cli php-mysqli php-xml php-mbstring php-intl php-ldap php-xmlrpc php-zip php-bz2 php-imap php-apcu

sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/8.x/apache2/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php/8.x/apache2/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 20M/' /etc/php/8.x/apache2/php.ini
sudo systemctl restart apache2
```

---

## 3. Datu-Basea Sortzea (MariaDB)

GLPI-rako datu-base espezifiko bat eta sarbide-erabiltzailea konfiguratu ziren MariaDB barruan:

```
sudo mariadb -u root -p

SQL kontsolaren barruan:

CREATE DATABASE glpidb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'glpi_user'@'localhost' IDENTIFIED BY 'BioHealth2026!';
GRANT ALL PRIVILEGES ON glpidb.* TO 'glpi_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

---
```

## 4. GLPI Deskargatzea, Instalatzea eta VirtualHost Konfigurazioa

1. **Softwarea Deskargatu eta Erauzi:**
```
   cd /tmp
   wget https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz
   tar -xvf glpi-10.0.10.tgz
   sudo mv glpi /var/www/html/glpi
```

3. **Jabetzak eta Baimenak Doitu:**
   ```
   sudo chown -R www-data:www-data /var/www/html/glpi
   sudo chmod -R 755 /var/www/html/glpi
   ```

5. **Apache VirtualHost Konfiguratu (`/etc/apache2/sites-available/glpi.conf`):**
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

6. **Gune Berria Gaitu eta Apache Berrabiarazi:**
   ```
   sudo a2enmod rewrite
   sudo a2ensite glpi.conf
   sudo systemctl restart apache2
   ```

8. **Instalazio fitxategia ezabatu segurtasuna bermatzeko:**
   ```
   sudo rm /var/www/html/glpi/install/install.php
   ```

---

## 5. Active Directory (LDAP) Integrazioa eta Erabiltzaileen Sinkronizazioa

Domeinuko erabiltzaileak Active Directory bidez integratu ziren GLPI-n autentifikatu ahal izateko.

### 5.1. LDAP Zerbitzariaren Konfigurazioa
* **Izena:** `Active Directory`
* **Zerbitzaria:** `192.168.10.2` (edo `192.168.10.1` interfazearen arabera)
* **Ataka:** `389`
* **Base DN:** `DC=biohealth,DC=local`
* **Saio Hasiera Eremua:** `samaccountname`
<img width="1178" height="880" alt="image4" src="https://github.com/user-attachments/assets/6a6542b4-b01b-40b7-b183-6280a96b861c" />



### 5.2. Erabiltzaileen Inportazioa eta Rol Gehikuntza (MariaDB Bidez)
Active Directory-tik erabiltzaileak inportatu ziren (`Administrador`, `informatika1`, `mediku1`, `harrera1`, etab.). Hasieran erabiltzaileek `Self-Service` rola soilik bazuten ere, MariaDB bidez `Administrador` erabiltzaileari (`id = 21`) eta teknikariei `Super-Admin` rola (`profiles_id = 4`) esleitu zitzaien:

```sql
-- Erabiltzaileak eta beren IDak egiaztatu
SELECT id, name, realname, firstname FROM glpi_users;

-- Super-Admin profila esleitu (users_id = 21, profiles_id = 4)
INSERT INTO glpi_profiles_users (users_id, profiles_id, entities_id, is_recursive) VALUES (21, 4, 0, 1);

```
<img width="946" height="582" alt="image1" src="https://github.com/user-attachments/assets/fe5372f2-5e96-4397-af15-9e0051b12c2c" />

<img width="1176" height="881" alt="image9" src="https://github.com/user-attachments/assets/34bdaad9-ab52-46b3-82c5-ac05abf6c5f7" />



## 6. Erronkaren Egiaztapena: Inbentarioa eta Ticketen Trazabilitatea

### 6.1. Enpresako Ekipoen Erregistroa (Activos / Inbentarioa)
Enpresako 3 nodo nagusiak erregistratu ziren GLPI inbentarioan:

| Ekipoaren Izena | Mota / Sistema Eragilea | Ezaugarriak / Deskribapena |
| :--- | :--- | :--- |
| **Servidor_Web_GLPI** | Servidor (Ubuntu Server 22.04 LTS) | IP: 192.168.10.4 - Web zerbitzaria eta GLPI 
| **Servidor_Jitsi** | Servidor (Ubuntu Server 22.04 LTS) | IP: 192.168.10.5 - Jitsi Meet Bideodeialak 
| **WindowsBezero** | Ordenador (Windows 11) | Domeinuko bezero ekipoa (`PC-Mediku`)

<img width="1180" height="872" alt="image8" src="https://github.com/user-attachments/assets/4342dfdb-d037-4b9d-80e4-3fd52311551a" />


### 6.2. Ticketen Kudeaketa eta Trazabilitatea (Soporte / Peticiones)
Sistema egoki dabilela kudeatzeko, 2 ticket ezberdin erregistratu ziren, bakoitza bere rol, erabiltzaile, ekipo eta egoera desberdinarekin:

1. **1. Ticket-a:** `Ezin da sareko inprimagailua aurkitzen`
   * **Eskatzailea:** `harrera1` (Self-Service)
   * **Esleitutako Teknikaria:** `Administrador` (Super-Admin)
   * **Egoera:** **Resuelto** (Ebatzita)

2. **2. Ticket-a:** `Jitsi bideodeialak ez du mikrofonoa detektatzen`
   * **Eskatzailea:** `informatika1`
   * **Esleitutako Teknikaria:** `Administrador`
   * **Egoera:** **En curso (asignada)** (Bidean)

     <img width="962" height="737" alt="image2" src="https://github.com/user-attachments/assets/f092feeb-2f07-4488-b7a6-ef1d41ffd9b0" />

