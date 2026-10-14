---
title: "SSL/TLS ziurtagiriak"
parent: "SEG – Segurtasuna"
nav_order: 4
---
# SSL/TLS Inplementazio Dokumentazioa BioHealth Ingurunerako

- **Active Directory Domeinua:** `biohealth.local` / `biohealth.eus`
- **Zertifikazio Agintaritza (CA):** Enpresa Erroko CA (`biohealth-ZERBITZARIPRINT-CA`)
- **Helburua:** Barneko web zerbitzuak (WordPress/GLPI eta Jitsi) babestea AD CS bidez jaorritako gako pribatudun SAN ziurtagiri esportagarriekin, eta domeinuko bezero guztietan ikono berdea (konexio segurua) lortzea.

> **Oharra – izenak eta IPak.** Orri hau lehen probetako laborategian egin zen (Alex). Bertan erabilitako izenak eta azken arkitekturakoak:
>
> | Laborategi honetan | Azken arkitekturan ([Sarearen diseinua](sarea.md)) |
> |---|---|
> | Servidor 1 · `192.168.10.4` · `web.biohealth.local` | **www** · `192.168.20.10` (DMZ) · `www.biohealth.local` / `glpi.biohealth.local` |
> | Servidor 2 · `192.168.10.5` · `jitsi.biohealth.eus` | **meet** · `192.168.20.11` (DMZ) · `meet.biohealth.local` |
>
> Prozedura berdina da; SAN zerrendan azken izenak jarri behar dira (`www`, `glpi`, `meet` `.biohealth.local`). `.eus` domeinua erregistratutako domeinu publiko bat izango litzateke (produkzioan), laborategian ez da erabiltzen.
>
> ⚠️ DMZtik LANera trafikoa ukatuta dago ([pfSense 3. araua](pfsense.md#arauak)); beraz `.pfx` fitxategia ez da `scp` bidez DCtik zuzenean DMZra pasatzen: administratzaileak BEZ-WIN01-etik (LAN) `scp` egiten du DMZko zerbitzarira (SSH 22, LAN→DMZ baimenduta), edo IsardVDIko kontsolatik.

---

## 1. Zertifikazio Agintaritzaren (AD CS) Konfigurazioa Windows Server-en

### 1.1. AD CS Rola Instalatzea eta Konfiguratzea

1. Windows Server-en, ireki **Server Manager** (Zerbitzariaren Kudeatzailea).
2. Joan **Manage > Add Roles and Features** aukerara.
3. Rolen zerrendan, markatu **Active Directory Certificate Services (AD CS)**.
4. Hautatu soilik **Certification Authority** (Zertifikazio Agintaritza) funtzioa eta osatu instalazioa.
5. Amaitzean, sakatu goiko lotura urdinean: *"Configure Active Directory Certificate Services on the destination server"*.
6. **Kredentzialak:** Morroian, sakatu **Change...** eta sartu domeinuko administratzailearen kontua sintaxi honekin:
   ```plaintext
   biohealth\Administrador
   ```
7. **Rol Zerbitzuak:** Markatu **Certification Authority**.
8. **CA Mota:** Hautatu **Enterprise CA** (Enpresa CA).
9. **Erroko CA Mota:** Hautatu **Root CA** (Erroko CA).
10. **Gako Pribatua:** Hautatu **Create a new private key** eta utzi aukera kriptografikoak lehenetsitako balioetan.
11. **Balio-aldia:** Utzi lehenetsitako balioa (5 urte).
12. **Datu-basea:** Utzi lehenetsitako bide-izenak eta sakatu **Configure**.

> **Egiaztapena:** Ireki `certsrv.msc` kontsola (**Hasiera > Administrazio Tresnak > Certification Authority**). Zerbitzaria ikono berde batekin agertuko da.

---

### 1.2. Baimenak Gaitzea eta Ziurtagiri Txantiloia Esportagarri Egitea

Berez, `Servidor web` txantiloiak ez du uzten gako pribatua esportatzen ezta erabiltzaileek zuzenean izena ematen. Txantiloi pertsonalizatu bat konfiguratu zen (`WebExportable`):

1. Ireki CA kontsola: `Win + R` > `certsrv.msc`.
2. Egin klik eskuineko botoiaz **Certificate Templates** (Ziurtagiri Txantiloiak) > **Manage** (Kudeatu).
3. Bilatu **Servidor web** (Web Server) txantiloia, egin klik eskuineko botoiaz eta hautatu **Duplicate Template** (Bikoiztu Txantiloia):
   - **General:** Ezarri izena: `WebExportable`.
   - **Request Handling (Eskabidearen izapidetzea):** Markatu *Allow private key to be exported* (Ahalduren gako pribatua esportatzea).
   - **Subject Name (Subjektuaren izena):** Hautatu *Supply in the request* (Eskabidean emana).
   - **Security (Segurtasuna):** Hautatu `Authenticated Users` (Autentifikatutako Erabiltzaileak) taldea eta markatu *Enroll* (Izena eman) aukera *Permit* (Baimendu) zutabean.
4. Sakatu **Apply** eta **OK**.
5. Itzuli `certsrv.msc` kontsolara, egin klik eskuineko botoiaz **Certificate Templates > New > Certificate Template to Issue**.
6. Zerrendatik hautatu `WebExportable` (edo `Servidor web`) eta sakatu **OK**.

---

### 1.3. Domeinu Anitzeko SAN Ziurtagiria (.PFX) Eskatzea eta Esportatzea

1. Sakatu `Win + R`, idatzi `mmc` eta sakatu **Enter**.
2. Joan **File > Add/Remove Snap-in...**, hautatu **Certificates**, hautatu **Computer account > Local computer > Finish > OK**.
3. Zabaltzeko: **Certificates (Local Computer) > Personal > Certificates**.
4. Klik eskuineko botoiaz lan-eremuan > **All Tasks > Request New Certificate...**
5. Aurrera egin morroian (*Active Directory Enrollment Policy*).
6. Markatu gaitutako txantiloiari dagokion laukia (`WebExportable`) eta egin klik testu horian: *"More information is required to enroll for this certificate"*.
7. **Subject** fitxan:
   - **Alternative name (SAN)** atalean, aldatu **Type** aukera **DNS** izenera.
   - **Value** atalean, gehitu banan-banan izen hauek **Add** sakatuz:
     - `*.biohealth.local`
     - `*.biohealth.eus`
     - `jitsi.biohealth.eus`
     - `web.biohealth.local`
     - `biohealth.local`
8. Sakatu **OK** eta ondoren **Enroll**.
9. **Personal > Certificates** karpetan, egin klik eskuineko botoiaz sortutako ziurtagirian > **All Tasks > Export...**
10. Hautatu **Yes, export the private key**.
11. Mantendu **Personal Information Exchange (.PFX)** formatua, ezarri babes-pasahitza eta gorde fitxategia `certificado.pfx` izenarekin Mahaiganean (`C:\Users\Administrador\Desktop\certificado.pfx`).

---

## 2. Configuración en Servidor 1: WordPress / GLPI / Apache (192.168.10.4)

### 2.1. Ziurtagiria Transferitzea eta Instalatzea

1. Transferitu `certificado.pfx` fitxategia Windows Server-etik SCP edo SSH bidez 1. Zerbitzariko `/tmp/` direktoriora.
2. Erauzi ziurtagiri publikoa eta gako pribatua OpenSSL erabiliz:
   ```bash
   cd /tmp
   sudo openssl pkcs12 -in certificado.pfx -clcerts -nokeys -out /etc/ssl/certs/web.biohealth.local.crt -nodes
   sudo openssl pkcs12 -in certificado.pfx -nocerts -out /etc/ssl/private/web.biohealth.local.key -nodes
   ```
3. Doitu irakurtzeko baimenak:
   ```bash
   sudo chmod 600 /etc/ssl/private/web.biohealth.local.key
   sudo chmod 644 /etc/ssl/certs/web.biohealth.local.crt
   ```

### 2.2. Apache eta WordPress Konfiguratzea

1. Gaitu SSL modulua eta gune seguru lehenetsia:
   ```bash
   sudo a2enmod ssl
   sudo a2ensite default-ssl
   ```
2. Editatu SSL VirtualHost fitxategia (`/etc/apache2/sites-available/default-ssl.conf`):
   ```apache
   SSLCertificateFile /etc/ssl/certs/web.biohealth.local.crt
   SSLCertificateKeyFile /etc/ssl/private/web.biohealth.local.key
   ```
3. Editatu `/var/www/html/wp-config.php` nabigazioa eta irudiak HTTPS bidez kargatzera behartzeko eta IP helbiderako birbideratze-begiztak ekiditeko:
   ```php
   define('WP_HOME', 'https://web.biohealth.local');
   define('WP_SITEURL', 'https://web.biohealth.local');
   ```
4. Berrabiarazi Apache:
   ```bash
   sudo apache2ctl configtest
   sudo systemctl restart apache2
   ```

---

## 3. Configuración en Servidor 2: Jitsi Meet / Nginx (192.168.10.5)

### 3.1. Transferentzia eta SCP Baimenen Arazoa Konpontzea

SCP bidez root ez den `biohealth` erabiltzailearekin `/tmp/` direktorioan zuzenean idazteko baimen murrizketak zirela eta, transferentzia bi urratsetan egin zen:

1. Windows Server-eko CMD-tik (`.pfx` fitxategia dagoen karpetan):
   ```cmd
   cd C:\Users\Administrador\Desktop
   scp certificado.pfx biohealth@192.168.10.5:/home/biohealth/
   ```
2. 2. Zerbitzariko (Jitsi) terminalean, mugitu fitxategia `/tmp/` karpetara:
   ```bash
   sudo mv /home/biohealth/certificado.pfx /tmp/
   ls -l /tmp/certificado.pfx
   ```

### 3.2. Ziurtagiriak Erauztea eta Nginx / Prosody Konfiguratzea

1. Erauzi PKCS#12 edukiontziko fitxategiak sintaxian aukera egokiak erabiliz (`-clcerts` eta `-nocerts` marratxoarekin `-`):
   ```bash
   cd /tmp
   # Ziurtagiri publikoa erauzi (.crt)
   sudo openssl pkcs12 -in certificado.pfx -clcerts -nokeys -out /etc/ssl/certs/jitsi.biohealth.eus.crt -nodes

   # Gako pribatua erauzi (.key)
   sudo openssl pkcs12 -in certificado.pfx -nocerts -out /etc/ssl/private/jitsi.biohealth.eus.key -nodes
   ```
2. Esleitu Jitsi-ko Prosody zerbitzuak behar dituen jabetza eta baimenak:
   ```bash
   sudo chmod 600 /etc/ssl/private/jitsi.biohealth.eus.key
   sudo chmod 644 /etc/ssl/certs/jitsi.biohealth.eus.crt
   sudo chown prosody:prosody /etc/ssl/certs/jitsi.biohealth.eus.crt /etc/ssl/private/jitsi.biohealth.eus.key
   ```
3. Editatu Nginx gunearen konfigurazio fitxategia:
   ```bash
   sudo nano /etc/nginx/sites-available/jitsi.biohealth.eus.conf
   ```
4. Ziurtatu direktibak `.eus` domeinu-luzapen osoa duten bide-izenetara bideratuta daudela:
   ```nginx
   ssl_certificate /etc/ssl/certs/jitsi.biohealth.eus.crt;
   ssl_certificate_key /etc/ssl/private/jitsi.biohealth.eus.key;
   ```
5. Probatu Nginx sintaxia eta berrabiarazi zerbitzuak:
   ```bash
   sudo nginx -t
   sudo systemctl restart nginx prosody jicofo
   ```

> **Nginx Egiaztapena:** `sudo nginx -t` aginduak erantzun hau eman behar du:  
> `nginx: configuration file /etc/nginx/nginx.conf test is successful.`

---

## 4. Konfiantza Banatzea eta Bezeroetan Egiaztatzea

1. **Erroko CA Zabaltzea:** Active Directory-n integratutako Enterprise CA denez, `biohealth-ZERBITZARIPRINT-CA` erakundearen gako publikoa automatikoki zabaldu zen `biohealth.local` domeinura bildutako Windows ordenagailu guztien Konfiantzazko erroko zertifikazio-agintariak biltegira.
2. **Nabigatzailearen Kachea:** Ziurtagiria instalatu ondoren segurtasun abisua mantentzen zen ordenagailuetan, kachea freskatzera behartu zen `Ctrl + F5` bidez edo nabigatzailearen datuak ezabatuz (`Ctrl + Shift + Ezabatu`).
3. **Azken Egiaztapena:** Domeinuko edozein nabigatzailetatik helbide hauetara sartzean:
   - `https://web.biohealth.local`
   - `https://jitsi.biohealth.eus`

<img width="1190" height="897" alt="image" src="https://github.com/user-attachments/assets/a33210bf-c4c3-4930-8595-52ea4fc3b898" />

