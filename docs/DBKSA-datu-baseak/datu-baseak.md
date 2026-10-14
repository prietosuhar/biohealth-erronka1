---
title: Datu-baseak
parent: "DBKSA – Datu-baseak"
nav_order: 1
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Datu-baseak (MariaDB)

## Aukerak

| DBKS | Lizentzia / kostua | HW gutxieneko eskakizunak | Alde onak | Alde txarrak |
|---|---|---|---|---|
| **MariaDB** | GPL · 0 € | 1 vCPU · 512 MB RAM · ~200 MB diskoa | MySQL-rekin bateragarria; WordPress-ek eta GLPIk ofizialki onartzen dute; Ubuntu-ko biltegietan; komunitate handia | Funtzio aurreratu gutxiago PostgreSQL baino |
| MySQL (Community) | GPL · 0 € (Oracle) | Antzekoak | WordPress/GLPI-rekin bateragarria | Oracle-ren menpe; funtzio batzuk Enterprise bertsioan bakarrik |
| PostgreSQL | PostgreSQL License · 0 € | 1 vCPU · 1 GB RAM | Oso osatua eta estandarra | WordPress-ek ez du ofizialki onartzen |
| SQL Server Express | Doakoa (10 GB muga) | 2 vCPU · 2 GB RAM, Windows | Windows/AD integrazioa | Ez du WordPress/GLPI onartzen; muga; Windows lizentzia |
| MongoDB | SSPL · 0 € | 2 GB RAM gomendatua | NoSQL, dokumentuak (JSON) | WordPress eta GLPIk ez dute erabiltzen (SQL behar dute) |

**Erabakia: MariaDB**, `db01` zerbitzarian (Ubuntu Server 20.04, LAN, 192.168.10.3).
- WordPress-ek eta GLPIk biek behar dute MySQL/MariaDB → DBKS bakarra bi aplikazioentzat.
- Kostua 0 € eta HW eskakizun txikiak.
- **LANean** dago, ez DMZn: pazienteen datuak dituenez, web zerbitzaria erasotzen badute ere datuak suebakiaren atzean geratzen dira; www-k bakarrik sar daiteke, 3306 portutik (suebakiaren 1. araua).

## Zerbitzaria

| Datua | Balioa |
|---|---|
| Izena | db01.biohealth.local |
| Sistema | Ubuntu Server 20.04 LTS (IsardVDI txantiloia) |
| Sarea | Pertsonala1 (LAN) · 192.168.10.3/24 · atebidea 192.168.10.254 · DNS 192.168.10.1 |
| Baliabideak | 2 vCPU · 2 GB RAM |

### Sare-konfigurazioa

`/etc/netplan/00-installer-config.yaml` (www-ren berdina, LANeko IPekin):

```yaml
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: false
      addresses:
        - 192.168.10.3/24
      gateway4: 192.168.10.254
      nameservers:
        addresses: [192.168.10.1]
        search: [biohealth.local]
```

![db01 netplan](../../irudiak/DBKSA/db01-netplan.png)
*Irudia: db01-en netplan fitxategia (koska zuzenekin).*

![db01 sarea](../../irudiak/DBKSA/db01-sarea.png)
*Irudia: `enp1s0` UP 192.168.10.3/24, lehenetsitako bidea pfSense-ra (192.168.10.254) eta DCra ping-a OK (0% packet loss). ✅*

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| `gateway4: 192.168.10.3/24` idatzi zen | Atebidean makinaren IP propioa eta maskara | Atebidea = pfSense (`192.168.10.254`), maskararik gabe |
| `netplan apply` → *Invalid YAML: inconsistent indentation* (6. lerroa) | `addresses:`-ek `dhcp4:`-ek baino zuriune gehiago zituen | Maila bereko lerroak (dhcp4, addresses, gateway4, nameservers) 6 zuriunetan lerrokatu (`nano -l` lerro-zenbakiekin) |

## Instalazioa 🔄

```bash
sudo apt update
sudo apt install -y mariadb-server
systemctl status mariadb --no-pager
mysql --version
sudo ss -tlnp | grep 3306
```

![MariaDB instalatuta](../../irudiak/DBKSA/mariadb-instalatuta.png)
*Irudia: **MariaDB 10.3.39** instalatuta eta `active (running)`, abiaraztean automatikoki gaituta (`enabled`). Hasieran `127.0.0.1:3306`-en bakarrik entzuten du (lokalean), segurtasunagatik lehenetsita. ✅*

### Instalazioa segurtatu (`mysql_secure_installation`)

| Galdera | Erantzuna | Zergatik |
|---|---|---|
| Set root password? | **n** | Ubuntu-n MariaDBko `root`-ek *unix_socket* autentifikazioa erabiltzen du: sistemako `sudo` behar da, ez pasahitz bat → ezin da sare bidez asmatu |
| Remove anonymous users? | Y | Erabiltzailerik gabe inor ez sartzeko |
| Disallow root login remotely? | Y | `root` makina beretik bakarrik |
| Remove test database? | Y | Edonork atzi zezakeen proba-datu-basea |
| Reload privilege tables? | Y | Aldaketak berehala aplikatu |

![mysql_secure_installation](../../irudiak/DBKSA/mariadb-secure-installation.png)
*Irudia: `mysql_secure_installation` osatuta: erabiltzaile anonimoak eta `test` datu-basea ezabatuta, root urrunetik debekatuta. ✅*

![SHOW DATABASES](../../irudiak/DBKSA/mariadb-show-databases.png)
*Irudia: `sudo mysql` (unix_socket) bidez root gisa sartuta: sistemaren datu-baseak bakarrik (`information_schema`, `mysql`, `performance_schema`); `test` jada ez dago. ✅*

### Sarera ireki (`bind-address`)

Lehenetsita MariaDBk `127.0.0.1`-en bakarrik entzuten du; www-k konektatu ahal izateko LANeko IPan entzun behar du:

```bash
sudo sed -i 's/^bind-address.*/bind-address            = 192.168.10.3/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb
sudo ss -tlnp | grep 3306
```

**Zergatik `192.168.10.3` eta ez `0.0.0.0`:** LANeko txartelean bakarrik entzuteko. Gainera, suebakiak (1. araua) www-ri bakarrik uzten dio 3306 portura iristen, eta MariaDBko erabiltzaileak `@'192.168.20.10'` bezala sortzen dira → hiru babes-geruza.

![bind-address](../../irudiak/DBKSA/mariadb-bind-address.png)
*Irudia: MariaDB orain `192.168.10.3:3306`-en entzuten. ✅*

> Oharra: IsardVDIko kontsola nabigatzailean dago; nano-n `Ctrl+W` (bilatu) sakatzean nabigatzaileak fitxa ixten du. Horregatik `sed` erabili da (edo nano-n `F6`).

## Ustiapen-ezaugarriak

| Parametroa | Balioa | Nola egiaztatu |
|---|---|---|
| Zerbitzua (systemd) | `mariadb` (aliasa `mysql`) | `systemctl status mariadb` |
| Portua / protokoloa | **3306/TCP** (MySQL protokoloa) | `sudo ss -tlnp \| grep 3306` |
| Konfigurazio nagusia | `/etc/mysql/mariadb.conf.d/50-server.cnf` | `grep -E 'bind-address\|max_connections' …` |
| `bind-address` | `192.168.10.3` (LAN, ez 0.0.0.0) | ↑ |
| Datu-fitxategiak | `/var/lib/mysql/` (datu-base bakoitza karpeta bat) | `sudo ls /var/lib/mysql` |
| Logak | `/var/log/mysql/error.log` · `journalctl -u mariadb` | `sudo tail /var/log/mysql/error.log` |
| Konexio-mugak | `max_connections = 100` (orokorra) · `MAX_USER_CONNECTIONS` erabiltzaileka | `SHOW VARIABLES LIKE 'max_connections';` |
| Motorra / karaktere-jokoa | InnoDB · `utf8mb4` | `SHOW ENGINES;` · `SHOW VARIABLES LIKE 'character_set_server';` |
| Konexio-parametroak (aplikazioak) | host `192.168.10.3` · port `3306` · DB `wordpress`/`glpi` · erabiltzailea `wp_user`/`glpi_user` | `wp-config.php` (`DB_HOST`) · GLPI kontenedorearen `GLPI_DB_*` |

### Abiarazi, gelditu eta berrabiarazi

```bash
sudo systemctl stop mariadb      && systemctl is-active mariadb   # inactive
mysql -h 192.168.10.3 -u wp_user -p   # www-tik → ERROR 2002 (111) Connection refused
sudo systemctl start mariadb     && systemctl is-active mariadb   # active
sudo systemctl restart mariadb
sudo systemctl is-enabled mariadb      # enabled → makina piztean abiarazten da
```

> Errore-kodeen bereizketa (ikus behean): MariaDB **geldituta** → `(111) Connection refused`; **suebakiak** blokeatuta → `(115)` *timeout*. Proba honek bi kasuak bereizten ditu.

### Hardware-baliabideak

| Baliabidea | Esleitua (db01) | Kontsumo erreala | Komandoa |
|---|---|---|---|
| CPU | 2 vCPU | ⏳ | `top -p $(pidof mariadbd)` |
| RAM | 2 GB | ⏳ (InnoDB buffer pool 128 MB lehenetsia) | `free -h` · `ps -o rss,cmd -C mariadbd` |
| Diskoa | ⏳ | ⏳ | `sudo du -sh /var/lib/mysql/*` · `df -h /` |

**Ebidentziak ⏳:** `systemctl stop/start/status` · `ss -tlnp` · `error.log` · baliabideen taula betetzeko komandoak.

## Datu-baseak eta erabiltzaileak ✅

| Datu-basea | Erabiltzailea | Nondik | Baimenak | Zergatik |
|---|---|---|---|---|
| `wordpress` | `wp_user` | `192.168.20.10` (www) | `wordpress.*`-n ALL | Gutxieneko pribilegioa: bere datu-basea bakarrik, eta www-tik bakarrik |
| `glpi` | `glpi_user` | `192.168.20.10` (www) | `glpi.*`-n ALL | Berdin |

```sql
CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE glpi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp_user'@'192.168.20.10' IDENTIFIED BY '********';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'192.168.20.10';
CREATE USER 'glpi_user'@'192.168.20.10' IDENTIFIED BY '********';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi_user'@'192.168.20.10';
FLUSH PRIVILEGES;
```

- **Gutxieneko pribilegioa:** aplikazio bakoitzak bere erabiltzailea eta bere datu-basea; WordPress erasotzen badute ezin dute GLPIren daturik irakurri.
- **`@'192.168.20.10'`:** erabiltzaileak www-tik bakarrik konekta daitezke; beste edozein IPtatik MariaDBk ukatzen du, pasahitza jakin arren.
- **`utf8mb4`:** karaktere guztiak (azentuak, ñ, emojiak) gordetzeko.
- Pasahitzak ez dira biltegian gordetzen. Laborategian pasahitz bera erabili da hainbat zerbitzutan (domeinua, pfSense, MariaDB) ez ahazteko; **enpresa erreal batean** zerbitzu bakoitzak berea izango luke, pasahitz-kudeatzaile batean (adib. KeePass) gordeta.

![Datu-baseak eta erabiltzaileak](../../irudiak/DBKSA/mariadb-dbak-erabiltzaileak.png)
*Irudia: `wordpress` eta `glpi` datu-baseak sortuta; erabiltzaileak: `glpi_user@192.168.20.10`, `wp_user@192.168.20.10` eta `root@localhost` (anonimorik ez). ✅*

![wp_user baimenak](../../irudiak/DBKSA/mariadb-grants-wp-user.png)
*Irudia: `SHOW GRANTS FOR 'wp_user'@'192.168.20.10'`: `USAGE` (konektatzeko baimena bakarrik, ezer gehiago ez) eta `ALL PRIVILEGES` `wordpress` datu-basean soilik. Pasahitzaren hash-a ezkutatuta. ✅*

### Diagnostikoa: 2002 errorea pausoz pauso

| # | Proba | Emaitza | Ondorioa |
|---|---|---|---|
| 1 | db01: `ss -tlnp \| grep 3306` | `192.168.10.3:3306` LISTEN | MariaDB ondo ✅ |
| 2 | db01: `ip r` | default via 192.168.10.254; VPN txartela 10.x-rako bakarrik | Itzulerako bidea ondo ✅ |
| 3 | www: `curl http://es.archive.ubuntu.com` | `HTTP/1.1 200 OK` | pfSense-k DMZ bideratzen du ✅ |
| 4 | www: `nc -zv -w 5 192.168.10.3 3306` | `timed out` | 3306 bakarrik blokeatuta ❌ |
| 5 | db01: `sudo ufw status` | `active`, 22 bakarrik | **Kausa aurkituta** |

![2002 errorea](../../irudiak/DBKSA/proba-www-errorea-2002.png)
*Irudia: www-tik konektatzean `ERROR 2002 … (115)`.*

![ss](../../irudiak/DBKSA/diag-db01-ss.png)
*Irudia: MariaDB 192.168.10.3:3306-en entzuten.*

![ip r](../../irudiak/DBKSA/diag-db01-ip-r.png)
*Irudia: db01-en bideak: lehenetsitakoa pfSense-ra.*

![curl eta nc](../../irudiak/DBKSA/diag-www-curl-nc.png)
*Irudia: www-k Internetera irteten du, baina 3306 portuak timeout ematen du.*

![ufw](../../irudiak/DBKSA/diag-db01-ufw.png)
*Irudia: db01-en ufw aktibo, 22 portua bakarrik.*

![ufw 3306](../../irudiak/DBKSA/db01-ufw-3306.png)
*Irudia: konponbidea: 3306/tcp baimendua **192.168.20.10-etik bakarrik**. ✅*

**Defentsa sakonean** — datu-basera iristeko 4 geruza: (1) pfSense 1. araua, (2) db01-en ufw, (3) `bind-address`, (4) MariaDBko erabiltzailea `@'192.168.20.10'`.

## Probak (www-tik) ✅

| Proba | Espero dena | Emaitza |
|---|---|---|
| `nc -zv -w 5 192.168.10.3 3306` | ✅ portua irekita | ✅ `succeeded` |
| `mysql -h 192.168.10.3 -u wp_user -p -e "SHOW DATABASES;"` | ✅ `wordpress` bakarrik | ✅ `information_schema` + `wordpress` (ez glpi, ez mysql) |
| `mysql -h 192.168.10.3 -u wp_user -p -e "USE glpi;"` | ❌ ukatuta | ✅ `ERROR 1044 (42000): Access denied for user 'wp_user'@'192.168.20.10' to database 'glpi'` |

![www-tik probak](../../irudiak/DBKSA/proba-www-wp-user.png)
*Irudia: www-tik (DMZ) db01-era (LAN) konexioa: pfSense-ren 1. araua eta db01-en ufw-a gainditzen ditu; `wp_user`-ek bere datu-basea bakarrik ikusten du eta `glpi`-ra sartzean 1044 errorea → gutxieneko pribilegioa funtzionatzen du. ✅*

## Logak eta erroreak 🔄

### Errore-mezuen interpretazioa

| Errorea | Esanahia | Kausa | Konponbidea |
|---|---|---|---|
| (errorerik gabe) erabiltzaileen pasahitza gidako adibidea zen (`TU_CONTRASEÑA`) | Komandoa adibidearen testua aldatu gabe kopiatu zen; `SHOW GRANTS`-eko hash-a egiaztatuz aurkitu zen | `ALTER USER '...'@'192.168.20.10' IDENTIFIED BY '********';` bi erabiltzaileentzat. Bash-en `!` duten pasahitzak `"..."` barruan *event not found* ematen du → `sudo mysql` barruan exekutatu |
| `ERROR 1044 (42000): Access denied for user 'wp_user'@'192.168.20.10' to database 'glpi'` | Baimen-errorea: erabiltzailea autentifikatuta dago, baina ez du datu-base horretarako baimenik | Nahita egindako proba: `wp_user`-ek `wordpress.*`-n bakarrik ditu baimenak | — (espero zen portaera) |
| `ERROR 2002 (HY000): Can't connect to MySQL server on '192.168.10.3' (115)` (www-tik) | TCP konexioa ezin izan da ezarri; **(115)** = itxaroten geratu da erantzunik gabe (*timeout*). Ez da pasahitza (hori 1045 izango litzateke) ezta MariaDB itzalita ere (hori (111) *refused* izango litzateke) | db01-k **ufw** suebakia aktibo zuen (IsardVDI txantiloitik), 22 portua bakarrik baimenduta | `sudo ufw allow from 192.168.20.10 to any port 3306 proto tcp comment 'www -> MariaDB'` |
| `ERROR 1064 (42000) ... near ':' at line 1` | SQL sintaxi-errorea; MariaDBk zehazten du non: `':'` ikurraren ondoan | `SHOW DATABASES:` — aginduaren amaieran `;` ordez `:` idatzi zen | `SHOW DATABASES;` → ondo (ikus goiko irudia) |

![1064 errorea](../../irudiak/DBKSA/mariadb-errorea-1064.png)
*Irudia: `SELECT VERSION()` ondo exekutatu da (10.3.39-MariaDB-0ubuntu0.20.04.2), baina bigarren aginduak 1064 errorea eman du sintaxi-akats batengatik. Mezuak errore-kodea, SQLSTATE (42000) eta kokapena (`near ':'`) ematen ditu.*

## MongoDB (ez-erlazionala)

### Zergatik bigarren DBKS bat

WordPress-ek eta GLPIk SQL behar dute (MariaDB). **MongoDB** egitura finkorik gabeko datuetarako da: sistemaren logak, JSON txosten klinikoak eta denbora-serieak (neurketak). Proposamenean adostutako datu-eredua: `biohealth_nosql` → `logs_sistema`, `txosten_klinikoak`, `neurketak`.

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **MongoDB Community** | Doakoa (SSPL); JSON dokumentuak; rolak eta autentifikazioa; time series bildumak | RAM gehiago; 5.0+ bertsioek **AVX** duen CPUa behar dute |
| Redis | Oso azkarra | Memorian; ez da dokumentuetarako |
| Cassandra | Big data, eskalagarria | Gehiegizkoa; 4 GB+ RAM nodo bakoitzeko |

**Erabakia: MongoDB**, db01-en (datuak LANean, MariaDB-ren ondoan).

| Parametroa | Balioa |
|---|---|
| Bertsioa | 7.0 (apt, CPUak AVX badu) · bestela 4.4 Docker kontenedorean |
| Zerbitzua | `mongod` (systemd) |
| Portua | **27017/TCP** |
| Konfigurazioa | `/etc/mongod.conf` → `net.bindIp: 127.0.0.1`, `storage.dbPath: /var/lib/mongodb`, `systemLog.path: /var/log/mongodb/mongod.log` |
| Sarbidea | `bindIp 127.0.0.1`: oraingoz sareko aplikaziorik ez → ez da sarera irekitzen (pribilegio minimoa) |
| Scripta | [`scripts/db01-mongodb.sh`](../../scripts/db01-mongodb.sh) (AVX detektatu, instalatu, proba-dokumentua txertatu) |

```bash
bash scripts/db01-mongodb.sh
systemctl status mongod          # active (running)
sudo ss -tlnp | grep 27017       # 127.0.0.1:27017
mongosh --eval 'db.adminCommand({ping:1})'
sudo systemctl stop mongod && sudo systemctl start mongod
sudo tail /var/log/mongodb/mongod.log
```

### Instalazioaren ebidentziak

<img width="1599" height="303" alt="image1" src="https://github.com/user-attachments/assets/e155ab43-278a-4fcc-beca-e70392374abe" />
<img width="1598" height="302" alt="image3" src="https://github.com/user-attachments/assets/2b94d0b8-9055-436d-9c31-ad1187f669b7" />
<img width="1170" height="143" alt="image2" src="https://github.com/user-attachments/assets/be692bb9-e327-4fe0-ac6e-f9738e4060a2" />

*Irudiak: MongoDB instalazioa eta egiaztapena db01-en.*

### Erabiltzaileak eta baimenak ⏳

Autentifikazioa gaitu (`security.authorization: enabled`) eta rolak proposamenaren arabera: `admin_mongo` (userAdminAnyDatabase), `app_nosql` (readWrite), `emisor_logs` (`logs_sistema`-n **insert** bakarrik), `backup_nosql` (read). Proba: `emisor_logs`-ek `find()` egitean → `not authorized` ❌.
