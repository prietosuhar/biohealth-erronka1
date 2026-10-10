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

## Instalazioa ⏳

## Ustiapen-ezaugarriak ⏳

| Parametroa | Balioa |
|---|---|
| Portua | 3306/TCP |
| Konfigurazio-fitxategia | `/etc/mysql/mariadb.conf.d/50-server.cnf` |
| `bind-address` | |
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

## Logak eta erroreak ⏳
