---
title: WordPress
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# WordPress – web korporatiboa

## Aukerak eta erabakia

| CMS | Lizentzia / kostua | Alde onak | Alde txarrak |
|---|---|---|---|
| **WordPress** | GPL · 0 € | Munduko CMS erabiliena (webguneen % 40+); milaka txantiloi eta plugin; erabiltzaile-rolak; ikasteko erraza; MariaDB/MySQL | Plugin askorekin eguneratu gabe utziz gero, eraso-helburu ohikoa |
| Joomla | GPL · 0 € | Malgua, rol aurreratuak | Komunitate txikiagoa, ikasteko zailagoa |
| Drupal | GPL · 0 € | Oso segurua eta indartsua | Zaila; web txiki baterako gehiegizkoa |
| Wix / Squarespace (SaaS) | Ordainpekoa (~15–30 €/hilabete) | Instalaziorik gabe | Ez da instalatzen (erronkak instalazioa eskatzen du); datuak hirugarren batean |

**Erabakia: WordPress.** BioHealth-en webgunea informatiboa da (zerbitzuak, ordutegiak, kontaktua, telekontsultarako esteka), langile ez-teknikoek eguneratu behar dute (editore-rola) eta 0 €-ko kostua du. Segurtasuna: DMZn dago, datu-basea LANean (db01), eta eguneraketak 6. arauaren bidez.

## Webaren erabilera ↔ CMSaren funtzionalitatea

| BioHealth-en beharra | WordPress-en funtzionalitatea |
|---|---|
| Kontsulta-zerbitzuak eta espezialitateak erakutsi | Orriak (Pages) |
| Albisteak / osasun-aholkuak | Sarrerak (Posts) eta kategoriak |
| Harrerako langileek edukia eguneratu | **Editor** rola (argitaratu bai, konfiguratu ez) |
| Telekontsulta | Jitsi Meet-erako esteka (`meet.biohealth.local`) |
| Irudi korporatiboa | Txantiloia + CSS pertsonalizatua |

## Instalazio-parametroak

| Parametroa | Balioa |
|---|---|
| Zerbitzaria | `www` · Ubuntu Server 20.04 · DMZ · 192.168.20.10 |
| Web zerbitzaria | Apache 2.4.41 (`mpm_prefork`, `mod_rewrite`) |
| PHP | 7.4.3 (`php-mysql`, `curl`, `gd`, `mbstring`, `xml`, `zip`, `intl`) |
| VirtualHost | `/etc/apache2/sites-available/wordpress.conf` · `ServerName web.biohealth.local` · `ServerAlias` www.biohealth.local |
| DocumentRoot | `/var/www/wordpress` (jabea `www-data`) |
| Logak | `/var/log/apache2/wordpress_error.log` · `wordpress_access.log` |
| Datu-basea | `wordpress` @ db01 (192.168.10.3:3306) · erabiltzailea `wp_user` · aurrizkia `wp_` |
| ufw (www) | 22, 80/tcp, 443/tcp |
| HTTPS | ⏳ |

Instalazio-scripta: [`scripts/www-wordpress-instalazioa.sh`](https://github.com/prietosuhar/biohealth-erronka1/blob/main/scripts/www-wordpress-instalazioa.sh) — www-k GitHub-etik deskargatu eta exekutatu zuen (`wget` + `bash`).

![Instalazioa](../../irudiak/WAE/wp-instalazioa-script.png)
*Irudia: scriptaren amaiera: ufw-n 80 eta 443 irekita, `wordpress` gunea gaituta eta `000-default` desgaituta, `mod_rewrite` gaituta, Apache 2.4.41 eta PHP 7.4.3. `curl http://localhost` → **HTTP/1.1 302 Found** (WordPress-ek instalatzailera birbideratzen du). ✅*

### Arazoak

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| Komando-blokea SSH-n itsatsi ondoren lehen lerroa (apt) bakarrik exekutatu zen; `wordpress.conf` ez zegoen | `apt`-ek instalazioan zehar sarrera estandarra irakurri zuen eta itsatsitako gainerako lerroak «jan» zituen | Komandoak script batean jarri, GitHub-era igo eta www-n `wget` + `bash` bidez exekutatu |
| Txatetik kopiatutako `ServerAlias` lerroa Markdown esteka bihurtu zen (`[...](https://...)`) | Txat-aplikazioak domeinu-izenak esteka gisa kopiatzen ditu | Scripta GitHub-etik zuzenean deskargatuta, testua ez da aldatzen |

## Web-instalatzailea ⏳

## Erabiltzaileak eta pribilegioak ⏳ (gutxienez bi)

| Erabiltzailea | Rola | Zer egin dezake |
|---|---|---|
| | Administrator | |
| | Editor | |

## Txantiloiak ⏳
- [ ] Hainbat txantiloi probatu (argazkiak)
- [ ] Aukeratutakoaren justifikazioa

## Diseinua eta CSS aldaketak ⏳
*(Gehigarrizko CSSa · aldatutako kodea · zergatik)*
