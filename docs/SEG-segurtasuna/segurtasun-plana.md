---
title: Segurtasun-plana
parent: "SEG – Segurtasuna"
nav_order: 3
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# BioHealth - Segurtasun Plana eta Kontingentzia Plana

**Sistema:** BioHealth IT Azpiegitura  
**Domeinuak:** `biohealth.local` / `biohealth.eus` 
**Sare Logikoa:** `192.168.10.0/24`
**Bertsioa:** 2.0 (2026ko Urria)

---

## 1. Enpresaren Deskribapena eta AmScope-a

BioHealth osasun-sektoreko enpresa teknologikoa da. Dokumentu honen helburu nagusia negozioaren jarraitutasuna bermatzea da zibereraso, hardware matxura edo bestelako ezbehar baten aurrean, datu klinikoen babesa (DBEO / LOPD) eta zerbitzuen erabilgarritasuna ziurtatuz.

Plan honek BioHealth enpresako nodo eta zerbitzu kritiko guztiak estaltzen ditu:

* **Servidor Principal (Windows Server 2025 - `192.168.10.1` / `192.168.10.2`):** Active Directory (AD DS), DNS, DHCP, GPO eta Enpresa Erroko Zertifikazio Agintaritza (CA: `biohealth-ZERBITZARIPRINT-CA`).
* **Servidor 1 (Ubuntu Server + Apache - `192.168.10.4`):** WordPress webgunea (`web.biohealth.local`), GLPI Helpdesk ataria eta CUPS inprimatze-zerbitzaria.
* **Servidor 2 (Ubuntu Server + Nginx - `192.168.10.5`):** Jitsi Meet bideodeialak (`jitsi.biohealth.eus`) eta Prosody XMPP zerbitzaria.
* **Proxmox VE (pve01):** Birtualizazio-ostalaritza nagusia.
* **Synology NAS (DS225+):** Kopia fisikoak 3-2-1 estrategiarekin.

---

## 2. Segurtasun Politika Oinarrizkoak (Segurtasun Plana)

### 2.1. Pasahitzen eta Sarbideen Politika
* **Konplexutasuna:** Gutxienez 10 karaktere, hizki larriak, xeheak, zenbakiak eta karaktere bereziak (`!@#$%^&*`).
* **Irajungipena eta Blokeoa:** Pasahitzak 6 hilabetean behin aldatuko dira. 6 saiakera oker eginez gero kontua automatikoki blokeatuko da.
* **Debekuak:** Erabat debekatua dago pasahitzak paperean idaztea edo beste pertsona batzuei jakinaraztea.
* **Zerbitzarien Kudeaketa:** Zerbitzari bakoitzak pasahitz propio eta berezitua du, eta administratzaileek sarbide eta irteera log guztiak erregistratzen dituzte.

### 2.2. Sarbide Fisikoen Segurtasuna
* Zerbitzarien gela (CPD) eta Informatika Tailerra eremu mugatuak dira (txartel/giltza bidezko sarbidea).
* Bisitari guztiek harreran izena eman behar dute eta identifikazio-txartela eraman.
* CPD gela bideozaintza-kamerekin babestuta dago.

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
   * **Servidor 1 (MySQL Dump):** Egunero 02:00etan WordPress eta GLPI datu-baseen erauzketa automatikoa:
     `mysqldump -u root -p --all-databases > /backup/db_biohealth_$(date +%F).sql`
   * **Servidor 2 (Konfigurazioak):** Hilero `/etc/nginx/`, `/etc/prosody/` eta `/etc/ssl/` karpeten konpresioa:
     `sudo tar -czvf /backup/jitsi_config_$(date +%F).tar.gz /etc/nginx/ /etc/prosody/ /etc/ssl/`
   * **Hodeiko Kopia:** NASetik hodeira bidalitako kopia zifratua.

---

### AZPIPLAN B: LARRIALDI-PLANA (Arintze-kontraneurriak)
*Mehatxua gauzatzen den unean bertan eragin kaltegarriak arintzeko eta azkar erantzuteko urratsak.*

#### B.1. Zerbitzuen RTO eta RPO Helburuak

| Zerbitzua / Nodoa | Eragina | RTO (Berreskuratze Denbora) | RPO (Datu-galera Onargarria) |
| :--- | :--- | :--- | :--- |
| **Active Directory / CA** | Ezin da saiorik hasi; SSL erroreak. | 2 ordu | 24 ordu |
| **WordPress / GLPI (Servidor 1)** | Barne webgunea eta ticketak behera. | 1 ordu | 4 ordu |
| **Jitsi Meet (Servidor 2)** | Bideodeialak eta bilerak eten. | 30 minutu | 0 ordu (Datu iraunkorrik ez) |

#### B.2. Berehalako Intzidentziak Kudeatzeko Ekintza-Planak (Incident Action Plans)

* **INTZIDENTZIA 1: Bezeroak "NET::ERR_CERT_AUTHORITY_INVALID" errorea ikusten du**
  * *Ekintza:* Bezeroak ez du Active Directory-ko CA erroko ziurtagiria. Exekutatu bezeroaren CMD-n:
    `certutil -config "192.168.10.1\biohealth-ZERBITZARIPRINT-CA" -ca.cert C:\CARoot.crt`
    `certutil -addstore -f "Root" C:\CARoot.crt`

* **INTZIDENTZIA 2: Servidor 1-en Bucle de redirección HTTP -> HTTPS edo IP bidezko blokeoa**
  * *Ekintza:* Sartu SSH bidez 192.168.10.4-ra. Editatu `/var/www/html/wp-config.php` eta behartu domeinua:
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
   * Servidor 1 erabat galdu ezkero, OS garbia instalatu ondoren, kargatu Apache/SSL fitxategiak eta lehengoratu datu-basea:
     `mysql -u root -p glpidb < /backup/db_biohealth_XX.sql`

3. **Mantentze-Checklista eta Zerbitzuen Egiaztapena:**
   Arriskurik ez dagoela bermatzeko eta sistemari berriz altua emateko, jarraitu kontrol-zerrenda hau:
   - [ ] **1. Ping orokorra:** Egiaztatu konektibitatea: `192.168.10.1` (DC), `192.168.10.4` (S1), `192.168.10.5` (S2).
   - [ ] **2. DNS Egiaztapena:** Bezeroan exekutatu `nslookup web.biohealth.local` eta `nslookup jitsi.biohealth.eus`.
   - [ ] **3. SSL/TLS Egoera:** Begiratu ziurtagiriak ez direla iraungi eta `biohealth-ZERBITZARIPRINT-CA` dela jaulkitzailea.
   - [ ] **4. Linux Zerbitzuak:** Egiaztatu egoerak:
     * Servidor 1: `sudo systemctl status apache2 cups`
     * Servidor 2: `sudo systemctl status nginx prosody jicofo jitsi-videobridge2`
