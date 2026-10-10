---
title: Datu-baseak
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

## Ustiapen-ezaugarriak ⏳

| Parametroa | Balioa |
|---|---|
| Portua | 3306/TCP |
| Konfigurazio-fitxategia | `/etc/mysql/mariadb.conf.d/50-server.cnf` |
| `bind-address` | `192.168.10.3` |
| Pizte / itzaltzea / egoera | `systemctl start / stop / restart / status mariadb` |
| Konexio-parametroak | `max_connections`, `MAX_USER_CONNECTIONS` |
| Logak | `/var/log/mysql/error.log` · `journalctl -u mariadb` |
| Baliabideak (RAM, diskoa) | |

## Datu-baseak eta erabiltzaileak ⏳

| Datu-basea | Erabiltzailea | Nondik | Baimenak | Zergatik |
|---|---|---|---|---|
| `wordpress` | `wp_user` | `192.168.20.10` (www) | `wordpress.*`-n ALL | Gutxieneko pribilegioa: bere datu-basea bakarrik, eta www-tik bakarrik |
| `glpi` | `glpi_user` | `192.168.20.10` (www) | `glpi.*`-n ALL | Berdin |

## Probak ⏳

## Logak eta erroreak 🔄

### Errore-mezuen interpretazioa

| Errorea | Esanahia | Kausa | Konponbidea |
|---|---|---|---|
| `ERROR 1064 (42000) ... near ':' at line 1` | SQL sintaxi-errorea; MariaDBk zehazten du non: `':'` ikurraren ondoan | `SHOW DATABASES:` — aginduaren amaieran `;` ordez `:` idatzi zen | `SHOW DATABASES;` → ondo (ikus goiko irudia) |

![1064 errorea](../../irudiak/DBKSA/mariadb-errorea-1064.png)
*Irudia: `SELECT VERSION()` ondo exekutatu da (10.3.39-MariaDB-0ubuntu0.20.04.2), baina bigarren aginduak 1064 errorea eman du sintaxi-akats batengatik. Mezuak errore-kodea, SQLSTATE (42000) eta kokapena (`near ':'`) ematen ditu.*
