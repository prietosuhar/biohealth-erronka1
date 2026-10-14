---
title: Segurtasun-plana
parent: "SEG – Segurtasuna"
nav_order: 3
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# BioHealth - Segurtasun Plana eta Kontingentzia Plana

**Sistema:** BioHealth IT Azpiegitura  
**Domeinua:** `biohealth.local` (barnekoa) · `biohealth.eus` (publikoa, produkzioan)  
**Sareak:** LAN `192.168.10.0/24` · DMZ `192.168.20.0/24` (ikus [Sarearen diseinua](sarea.md))
**Bertsioa:** 2.0 (2026ko Urria)

---

## 1. Enpresaren Deskribapena eta AmScope-a

BioHealth osasun-sektoreko enpresa teknologikoa da. Dokumentu honen helburu nagusia negozioaren jarraitutasuna bermatzea da zibereraso, hardware matxura edo bestelako ezbehar baten aurrean, datu klinikoen babesa (DBEO / LOPD) eta zerbitzuen erabilgarritasuna ziurtatuz.

Plan honek BioHealth enpresako nodo eta zerbitzu kritiko guztiak estaltzen ditu:

| Nodoa | IP · zona | Zerbitzuak | Kritikotasuna |
|---|---|---|---|
| **pfsense** | WAN · `192.168.10.254` · `192.168.20.254` | Suebakia, NAT, IDS (Suricata), VPN (OpenVPN) | Altua (sare osoaren ertza) |
| **zerbitzariprintzipala** (Windows Server 2019) | `192.168.10.1` · LAN | AD DS, DNS, DHCP, GPO, inprimaketa, CA (`biohealth-ZERBITZARIPRINT-CA`) | Oso altua |
| **db01** (Ubuntu Server) | `192.168.10.3` · LAN | MariaDB (WordPress, GLPI), MongoDB, CUPS | Oso altua (datuak) |
| **www** (Ubuntu Server) | `192.168.20.10` · DMZ | Apache + WordPress, GLPI (Docker kontenedorea) | Ertaina |
| **meet** (Ubuntu Server 24.04) | `192.168.20.11` · DMZ | Jitsi Meet (Nginx, Prosody, Jicofo, JVB) | Ertaina (telekontsulta) |
| **pve01** *(proposatutako HW)* | — | Proxmox VE: makina birtualen ostalaria produkzioan | Oso altua |
| **NAS** *(proposatutako HW)* | — | Babeskopiak 3-2-1 | Altua |

> Laborategian makina guztiak IsardVDIn daude; pve01 eta NASa [HW txostenean](../HW-hardwarea/hardwarea.md) proposatutako ekipo fisikoak dira.

---

## 2. Segurtasun Politika Oinarrizkoak (Segurtasun Plana)

### 2.1. Pasahitzen eta Sarbideen Politika
Proposamenean adostutakoa (12 karaktere) aplikatzen da, domeinu osoan **Default Domain Policy** GPO bidez (*Configuración del equipo → Directivas → Configuración de Windows → Configuración de seguridad → Directivas de cuenta*):

| Ezarpena | Balioa | Zergatik |
|---|---|---|
| Gutxieneko luzera | **12** karaktere | Osasun-datuak; 12 karaktereko pasahitz konplexuak indar-gordineko erasoak ia ezinezko egiten ditu |
| Konplexutasuna | Gaituta (larriak, xeheak, zenbakiak, ikurrak) | Hiztegi-erasoak saihestu |
| Gehieneko iraupena | 180 egun | Filtratutako pasahitz batek denbora mugatua du |
| Historia | 5 pasahitz | Pasahitz bera berrerabiltzea saihestu |
| Kontu-blokeoa | 6 saiakera oker → 15 min | Indar-gordina geldiarazi, erabiltzailea betiko blokeatu gabe |
| Administrariak | Kontu pertsonala + administrazio-kontu bereizia | Pribilegio minimoa |

Egiaztapena (DCan, PowerShell): `Get-ADDefaultDomainPasswordPolicy` → argazkia ⏳

Zerbitzu-kontuak (MariaDB `wp_user`/`glpi_user`, pfSense `admin`, GLPI) ez dira biltegian gordetzen; produkzioan pasahitz-kudeatzaile batean (KeePassXC) gordeko lirateke.
* **Debekuak:** Erabat debekatua dago pasahitzak paperean idaztea edo beste pertsona batzuei jakinaraztea.
* **Zerbitzarien Kudeaketa:** Zerbitzari bakoitzak pasahitz propio eta berezitua du, eta administratzaileek sarbide eta irteera log guztiak erregistratzen dituzte.

### 2.2. Sarbide Fisikoen Segurtasuna
* Zerbitzarien gela (CPD) eta Informatika Tailerra eremu mugatuak dira (txartel/giltza bidezko sarbidea).
* Bisitari guztiek harreran izena eman behar dute eta identifikazio-txartela eraman.
* CPD gela bideozaintza-kamerekin babestuta dago.
* Kokapena eta eremuak: ikus [egoitzaren planoa](../HW-hardwarea/hardwarea.md#egoitzaren-planoa-eta-informatika-tailerra) (CPDa, informatika-tailerra, harrera eta kontsultak).

| Eremua | Nork sar daiteke | Neurria |
|---|---|---|
| Harrera / itxarongela | Edonor | Pantailak bisitarien ikuspegitik kanpo, pribatutasun-iragazkiak, pantaila-blokeoa 5 min (GPO-Harrera) |
| Kontsultak | Medikuntza eta erizaintza | Atea itxita kontsultan; mahai garbia; saioa itxi irtetean |
| Administrazioa | Administrazioa, zuzendaritza | Armairu itxiak paperezko dokumentuentzat |
| Informatika-tailerra | Informatika | Txartela; ekipo-sarrera/irteera erregistroa |
| CPD / rack-a | Informatika (2 pertsona) | Rack itxia giltzaz, sarbide-erregistroa, kamera, SAI, tenperatura-sentsorea, CO₂ itzalgailua |

---

## 2.3. Arriskuen analisia (MAGERIT metodologia · PILAR)

Kontingentzia-plana arriskuen analisi batetik abiatzen da. **MAGERIT** metodologia erabili dugu (Espainiako Administrazioaren metodo ofiziala), eta INCIBE/CCN-ren **PILAR** tresnak metodologia bera automatizatzen du.

### Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **MAGERIT + PILAR (CCN)** | Metodo ofiziala; aktiboak, mehatxuak eta babesak katalogo estandarrekin; txostena automatikoki | Tresna ikasi behar da; Java |
| ISO 27005 eskuz | Nazioartekoa | Katalogorik ez; dena eskuz |
| Arrisku-taula sinplea | Azkarra | Ez da metodo formala |

**Erabakia: MAGERIT** (taula hau) eta **PILAR**-en errepikatu (argazkiak ⏳). Eskala: balioa eta eragina 1–5 (C konfidentzialtasuna, I osotasuna, D erabilgarritasuna); probabilitatea 1–5; **arriskua = probabilitatea × eragina**.

### Aktiboak eta balorazioa

| Aktiboa (MAGERIT mota) | Adibidea BioHealth-en | C | I | D | Zergatik |
|---|---|---|---|---|---|
| [D] Datuak | Pazienteen datuak eta historia klinikoak (db01) | 5 | 5 | 4 | DBEO 9. art. kategoria berezia |
| [D] Datuak | Langileen kontuak (AD) | 4 | 5 | 4 | Sarbide guztien giltza |
| [S] Zerbitzuak | Telekontsulta (Jitsi) | 4 | 3 | 4 | Pazienteen arreta |
| [S] Zerbitzuak | Web korporatiboa, GLPI | 2 | 3 | 3 | Irudia eta laguntza-mahaia |
| [SW] Softwarea | AD DS, MariaDB, Apache, pfSense | 3 | 5 | 5 | Zerbitzu guztien oinarria |
| [HW] Hardwarea | pve01, NAS, switcha, PCak | 3 | 4 | 5 | Matxura batek dena geldi dezake |
| [COM] Komunikazioak | Internet konexioa, LAN | 2 | 3 | 4 | Telekontsulta eta eguneraketak |
| [L] Instalazioak | CPDa, kontsultak | 3 | 3 | 4 | Sarbide fisikoa |
| [P] Pertsonak | Harrera, medikuak, informatika | 4 | 3 | 3 | Phishing, akatsak |

### Mehatxuak, arriskua eta babesak

| # | Mehatxua (MAGERIT) | Aktiboa | Prob. | Eragina | **Arriskua** | Babesa (salvaguarda) | Hondar-arriskua |
|---|---|---|---|---|---|---|---|
| 1 | [A.24] Ransomwarea / malwarea | Datuak, zerbitzariak | 4 | 5 | **20 🔴** | Defender + ClamAV, GPOak (USB, CMD), 3-2-1 babeskopiak lineaz kanpo, segmentazioa (DMZ) | 8 |
| 2 | [A.11] Baimenik gabeko sarbidea (pasahitz ahulak) | AD, datuak | 3 | 5 | **15 🔴** | 12 karaktereko politika, blokeoa, VPN ziurtagiriarekin, pribilegio minimoa (DB rolak) | 6 |
| 3 | [A.5] Web zerbitzariaren erasoa (WordPress) | www | 3 | 4 | **12 🟠** | DMZ (DMZ→LAN ukatuta), HTTPS, `DISALLOW_FILE_EDIT`, eguneraketak, Suricata | 4 |
| 4 | [E.1/E.2] Erabiltzaileen akatsak / phishing | Pertsonak | 4 | 3 | **12 🟠** | Kontzientziazioa, Suricata alertak, GLPI bidezko jakinarazpena | 6 |
| 5 | [I.6] Argindar-etena | HW | 3 | 4 | **12 🟠** | SAIak (ordenatutako itzalaldia) | 4 |
| 6 | [I.5] Hardware-matxura (diskoa) | pve01, db01 | 2 | 5 | **10 🟠** | RAID1, babeskopiak, RTO 2 h | 4 |
| 7 | [N.1] Sutea CPDn | Instalazioak | 1 | 5 | **5 🟢** | CO₂ itzalgailua, NASa beste gela batean, hodeiko kopia zifratua | 2 |
| 8 | [A.25] Ekipo-lapurreta | Eramangarriak | 2 | 4 | **8 🟡** | BitLocker (TPM 2.0), Kensington | 2 |

Arrisku altuenak (1 eta 2) dira kontingentzia-planaren lehentasuna (ikus 3. atala).

### PILAR-en ⏳
1. [PILAR deskargatu](https://pilar.ccn-cert.cni.es/) (doako bertsioa / *PILAR Basic*) eta proiektu berria sortu: «BioHealth».
2. Aktiboak goiko taulatik sartu eta [D]-[S]-[SW]-[HW] mendekotasunak lotu.
3. Balorazioa (C, I, D) eta mehatxuak katalogotik → babesak (*salvaguardas*) markatu.
4. Argazkiak: aktiboen zuhaitza, arrisku potentziala eta hondar-arriskua.

---

## 3. Kontingentzia Plana (Disaster Recovery & BCP)

Kontingentzia-plan hau hiru azpiplan nagusietan banatzen da:

---

### AZPIPLAN A: BABES-PLANA (Prebentzio-kontraneurriak)
*Mehatxu bat gauzatu aurretik hartu beharreko neurriak, mehatxua gertatu ez dadin.*

1. **Infrastruktura Fisikoa eta Elikatzea:**
   * **SAI / UPS:** APC Smart-UPS 1500 VA (CPD-rako) eta 750 VA (Tailerrerako), tentsio-gorabeherak AVR bidez zuzentzeko eta argi-mozketetan zerbitzariak ordenan itzaltzeko.
   * **Sute-babesa eta Kopiak:** NAS babes-gailua Informatika Tailerrean kokatuta dago eta ez CPD barruan, sute edo ur-isuri batek ekipo fisiko nagusia eta kopiak batera ez suntsitzeko.

2. **Zibersegurtasuna eta SSL/TLS Cifratzea:**
   * **Enpresa CA (AD CS):** Active Directory barruan jaokitako `WebExportable` txantiloi bidezko SSL wildcard ziurtagiriak (`*.biohealth.local`, `*.biohealth.eus`) inplementatuta daude web zerbitzari guztietan HTTPS candado berdea bermatzeko.
   * **GPO Bidezko Zabalkuntza:** CA Erroko ziurtagira automatikoki banatzen zaie domeinuko bezero guztiei.
   * **Host IDS/IPS:** Fail2ban zerbitzua martxan dago SSH, Apache eta Prosody-n indar-gordinaren bidezko erasoak IP bidez blokeatzeko.

3. **Segurtasun Kopien (Backup) Protokoloa (3-2-1 Araua):**
   * **Windows Server (System State):** System State kopiak eta `certificado.pfx` gakoen exportazioa astero egiten da kanpoko biltegi seguru batean.
   * **db01 (MariaDB dump):** Egunero 02:00etan WordPress eta GLPI datu-baseen erauzketa automatikoa (cron):
     `mysqldump -u root -p --all-databases > /backup/db_biohealth_$(date +%F).sql`
   * **meet (konfigurazioak):** Hilero `/etc/nginx/`, `/etc/prosody/` eta `/etc/ssl/` karpeten konpresioa:
     `sudo tar -czvf /backup/jitsi_config_$(date +%F).tar.gz /etc/nginx/ /etc/prosody/ /etc/ssl/`
   * **Hodeiko Kopia:** NASetik hodeira bidalitako kopia zifratua.

---

### AZPIPLAN B: LARRIALDI-PLANA (Arintze-kontraneurriak)
*Mehatxua gauzatzen den unean bertan eragin kaltegarriak arintzeko eta azkar erantzuteko urratsak.*

#### B.1. Zerbitzuen RTO eta RPO Helburuak

| Zerbitzua / Nodoa | Eragina | RTO (Berreskuratze Denbora) | RPO (Datu-galera Onargarria) |
| :--- | :--- | :--- | :--- |
| **Active Directory / CA** | Ezin da saiorik hasi; SSL erroreak. | 2 ordu | 24 ordu |
| **WordPress / GLPI (www + db01)** | Barne webgunea eta ticketak behera. | 1 ordu | 4 ordu |
| **Jitsi Meet (meet)** | Bideodeialak eta bilerak eten. | 30 minutu | 0 ordu (Datu iraunkorrik ez) |

#### B.2. Berehalako Intzidentziak Kudeatzeko Ekintza-Planak (Incident Action Plans)

* **INTZIDENTZIA 1: Bezeroak "NET::ERR_CERT_AUTHORITY_INVALID" errorea ikusten du**
  * *Ekintza:* Bezeroak ez du Active Directory-ko CA erroko ziurtagiria. Exekutatu bezeroaren CMD-n:
    `certutil -config "192.168.10.1\biohealth-ZERBITZARIPRINT-CA" -ca.cert C:\CARoot.crt`
    `certutil -addstore -f "Root" C:\CARoot.crt`

* **INTZIDENTZIA 2: www-n HTTP → HTTPS birbideratze-begizta edo IP bidezko blokeoa**
  * *Ekintza:* Sartu SSH bidez www-ra (192.168.20.10, LANetik). Editatu `/var/www/html/wp-config.php` eta behartu domeinua:
    `define('WP_HOME', 'https://web.biohealth.local');`
    `define('WP_SITEURL', 'https://web.biohealth.local');`
    Ondoren: `sudo systemctl restart apache2`

* **INTZIDENTZIA 3: Jitsi-n "Ha sido desconectado" edo Pantaila Beltza bileran sartzean**
  * *Ekintza:* Zuzendu Prosody-ko eta Jitsi-ko ortografia-akatsak (`biohealt` -> `biohealth`):
    `sudo sed -i 's/biohealt/biohealth/g' /etc/prosody/conf.d/*`
    `sudo sed -i 's/biohealt/biohealth/g' /etc/jitsi/meet/*`
    Kopiatu ziurtagiriak Prosody-ra:
    `sudo cp /etc/ssl/certs/jitsi.biohealth.eus.crt /etc/prosody/certs/jitsi.biohealth.eus.crt`
    `sudo cp /etc/ssl/private/jitsi.biohealth.eus.key /etc/prosody/certs/jitsi.biohealth.eus.key`
    `sudo chown -R prosody:prosody /etc/prosody/certs/`
    Berrabiarazi zerbitzuak: `sudo systemctl restart prosody jicofo jitsi-videobridge2 nginx`

* **INTZIDENTZIA 4: Inprimagailua ez dago erabilgarri sarean (`192.168.10.130`)**
  * *Ekintza:* Lortu gailuaren MAC helbidea (`getmac`). Windows Server-eko DHCP-n (`dhcpmgmt.msc`), sortu IP erreserba berria `192.168.10.130` helbidearentzat eta berreraiki Standard TCP/IP Puerto-a Windows Print Server-en.

---

### AZPIPLAN C: BERRESKURATZE-PLANA (Lehengoratze-neurriak)
*Mehatxua kontrolatu ondoren egoera lehengoratzeko eta zerbitzuak berriz martxan jartzeko prozedurak.*

1. **Hardware / Birtualizazio Ordezpena:**
   * Proxmox VE zerbitzari fisikoa (`pve01`) eroriz gero, berrezarri zerbitzari garbia eta inportatu makina birtualen azken snapshot/backup-ak Synology DS225+ NASetik (Active Backup for Business erabiliz).

2. **Datu-baseak eta Web Zerbitzuak Lehengoratzea:**
   * www edo db01 erabat galdu ezkero, OS garbia instalatu ondoren, kargatu Apache/SSL fitxategiak eta lehengoratu datu-basea db01-en:
     `mysql -u root -p glpidb < /backup/db_biohealth_XX.sql`

3. **Mantentze-Checklista eta Zerbitzuen Egiaztapena:**
   Arriskurik ez dagoela bermatzeko eta sistemari berriz altua emateko, jarraitu kontrol-zerrenda hau:
   - [ ] **1. Ping orokorra:** Egiaztatu konektibitatea: `192.168.10.1` (DC), `192.168.10.3` (db01), `192.168.20.10` (www), `192.168.20.11` (meet).
   - [ ] **2. DNS Egiaztapena:** Bezeroan exekutatu `nslookup www.biohealth.local` eta `nslookup meet.biohealth.local`.
   - [ ] **3. SSL/TLS Egoera:** Begiratu ziurtagiriak ez direla iraungi eta `biohealth-ZERBITZARIPRINT-CA` dela jaulkitzailea.
   - [ ] **4. Linux Zerbitzuak:** Egiaztatu egoerak:
     * www: `sudo systemctl status apache2 docker` · `sudo docker ps`
     * db01: `sudo systemctl status mariadb mongod cups`
     * meet: `sudo systemctl status nginx prosody jicofo jitsi-videobridge2`
