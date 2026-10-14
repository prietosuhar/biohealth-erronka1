---
title: GLPI
parent: "WAE – Web aplikazioak"
nav_order: 2
---

[← Hasiera](../../index.md) · [Modulua](index.md)


# GLPI Helpdesk - Instalazioa, Konfigurazioa, Active Directory Integrazioa eta Trazabilitatea

Dokumentu honek **BioHealth** enpresaren azpiegituran **Servidor 1** (`192.168.10.4`) nodoan GLPI ticket-kudeaketa eta inbentario sistema instalatzeko, Apache/PHP ingurunea konfiguratzeko, Active Directory (`192.168.10.1` - `biohealth.local`) bidezko LDAP autentifikazioa ezartzeko eta "Erronka" ebaluaziorako beharrezkoak diren inbentario zein ticketen trazabilitatea frogatzeko urrats guztiak biltzen ditu.

> **Oharra – bi bertsio eta IPak.** Orri honetako 1.–6. atalak GLPIren **lehen instalazioa** dira (instalazio natiboa, Alexen laborategian, `192.168.10.4`, DB lokala `glpidb`). Azken arkitekturan zerbitzariak DMZra eraman ziren eta GLPI **kontenedore batera** migratu da (errubrikako SB irizpidea):
>
> | Lehen instalazioan | Azken arkitekturan |
> |---|---|
> | Servidor 1 · `192.168.10.4` (LAN) | **www** · `192.168.20.10` (DMZ) |
> | Servidor 2 (Jitsi) · `192.168.10.5` | **meet** · `192.168.20.11` (DMZ) |
> | GLPI natiboa Apache-n, `glpidb` lokala | **GLPI 10 Docker kontenedorean**, `glpi` DB **db01**-en (`192.168.10.3`) → ikus [7. atala](#7-kontenedorera-migrazioa-azken-arkitektura) eta [SB](../SB-sistema-banatuak/birtualizazioa.md) |
>
> LDAP integrazioa, rolak, inbentarioa eta tiketak bi bertsioetan berdin konfiguratzen dira (GLPIren web-interfazetik).

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
CREATE USER 'glpi_user'@'localhost' IDENTIFIED BY '********';   -- pasahitza ez da biltegian gordetzen
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


### 6.3. Rolak (errubrika: ≥ 2 rol)

| Rola (GLPI profila) | Erabiltzaileak | Zer egin dezake | Zergatik |
|---|---|---|---|
| **Self-Service** | `harrera1`, `mediku1`… (AD-tik inportatuak) | Tiketak sortu eta bere tiketen egoera ikusi | Langile gehienek intzidentziak jakinarazi besterik ez dute behar (pribilegio minimoa) |
| **Technician** *(hirugarren rola, gehitzeko)* | `informatika1`, `informatika2` | Esleitutako tiketak kudeatu, inbentarioa ikusi | Informatika saileko teknikariek ez dute Super-Admin izan behar |
| **Super-Admin** | `Administrador` | Dena (konfigurazioa, LDAP, profilak) | Administrazio-kontu bakarra |

> Hobekuntza: profila MariaDB-n `INSERT` bidez esleitu beharrean, *Administración → Usuarios → (erabiltzailea) → Autorizaciones* fitxatik egin daiteke; GLPIk egiten duena berdina da, baina interfazetik egiteak ez du DBaren egitura jakitea eskatzen eta erregistroan geratzen da.

## 7. Kontenedorera migrazioa (azken arkitektura)

| Datua | Balioa |
|---|---|
| Ostalaria | **www** · `192.168.20.10` (DMZ) · Ubuntu Server 20.04 |
| Kontenedorea | `glpi/glpi:10.0.x` (Docker), izena `glpi`, `--restart unless-stopped` |
| Portua | `127.0.0.1:8080` → kontenedoreko 80 (kanpotik **ez** da irekitzen) |
| Argitalpena | Apache alderantzizko proxya, `https://glpi.biohealth.local` (443, ziurtagiri bera) |
| Datu-basea | `glpi` @ **db01** `192.168.10.3:3306`, erabiltzailea `glpi_user`@`192.168.20.10` (pfSense 1. araua) |
| Datu iraunkorrak | `glpi_data` bolumena (`/var/glpi`) — kontenedorea ezabatuta ere fitxategiak geratzen dira |
| Scripta | [`scripts/www-glpi-docker.sh`](../../scripts/www-glpi-docker.sh) |

**Zergatik GLPI 10 eta ez 11:** GLPI 11-k MariaDB ≥ 10.6 eskatzen du eta db01-ek 10.3 du (Ubuntu 20.04-ko biltegia).
**Zergatik 127.0.0.1:8080:** Docker-ek `-p 8080:80` jarrita iptables arauak zuzenean idazten ditu eta **ufw saihesten du**; localhost-era lotuta, sarrera bakarra Apache (443) da.

```bash
bash scripts/www-glpi-docker.sh 10.0.20
sudo docker ps                       # glpi  Up …  127.0.0.1:8080->80/tcp
sudo docker logs --tail 20 glpi
curl -skI https://glpi.biohealth.local --resolve glpi.biohealth.local:443:127.0.0.1
```

### Ebidentziak ⏳
- [ ] `docker ps` eta `docker volume ls` (www)
- [ ] `https://glpi.biohealth.local` BEZ-WIN01-etik (giltzarrapoa)
- [ ] Inbentarioa eguneratuta azken IPekin: pfsense, zerbitzariprintzipala (.10.1), db01 (.10.3), www (.20.10), meet (.20.11), BEZ-WIN01, bez-lnx01 — makina **fisikoak** (HW txostena) eta **birtualak** (IsardVDI) bereizita
