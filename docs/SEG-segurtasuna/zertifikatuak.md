# SSL/TLS Inplementazio Dokumentazioa BioHealth Ingurunerako

- **Active Directory Domeinua:** `biohealth.local` / `biohealth.eus`[cite: 1]
- **Zertifikazio Agintaritza (CA):** Enpresa Erroko CA (`biohealth-ZERBITZARIPRINT-CA`)[cite: 1]
- **Helburua:** Barneko web zerbitzuak (WordPress/GLPI eta Jitsi) babestea AD CS bidez jaorritako gako pribatudun SAN ziurtagiri esportagarriekin, eta domeinuko bezero guztietan ikono berdea (konexio segurua) lortzea[cite: 1].

---

## 1. Zertifikazio Agintaritzaren (AD CS) Konfigurazioa Windows Server-en

### 1.1. AD CS Rola Instalatzea eta Konfiguratzea

1. Windows Server-en, ireki **Server Manager** (Zerbitzariaren Kudeatzailea)[cite: 1].
2. Joan **Manage > Add Roles and Features** aukerara[cite: 1].
3. Rolen zerrendan, markatu **Active Directory Certificate Services (AD CS)**[cite: 1].
4. Hautatu soilik **Certification Authority** (Zertifikazio Agintaritza) funtzioa eta osatu instalazioa[cite: 1].
5. Amaitzean, sakatu goiko lotura urdinean: *"Configure Active Directory Certificate Services on the destination server"*[cite: 1].
6. **Kredentzialak:** Morroian, sakatu **Change...** eta sartu domeinuko administratzailearen kontua sintaxi honekin[cite: 1]:
   ```plaintext
   biohealth\Administrador
   ```[cite: 1]
7. **Rol Zerbitzuak:** Markatu **Certification Authority**[cite: 1].
8. **CA Mota:** Hautatu **Enterprise CA** (Enpresa CA)[cite: 1].
9. **Erroko CA Mota:** Hautatu **Root CA** (Erroko CA)[cite: 1].
10. **Gako Pribatua:** Hautatu **Create a new private key** eta utzi aukera kriptografikoak lehenetsitako balioetan[cite: 1].
11. **Balio-aldia:** Utzi lehenetsitako balioa (5 urte)[cite: 1].
12. **Datu-basea:** Utzi lehenetsitako bide-izenak eta sakatu **Configure**[cite: 1].

> **Egiaztapena:** Ireki `certsrv.msc` kontsola (**Hasiera > Administrazio Tresnak > Certification Authority**). Zerbitzaria ikono berde batekin agertuko da[cite: 1].

---

### 1.2. Baimenak Gaitzea eta Ziurtagiri Txantiloia Esportagarri Egitea

Berez, `Servidor web` txantiloiak ez du uzten gako pribatua esportatzen ezta erabiltzaileek zuzenean izena ematen[cite: 2]. Txantiloi pertsonalizatu bat konfiguratu zen (`WebExportable`)[cite: 2]:

1. Ireki CA kontsola: `Win + R` > `certsrv.msc`[cite: 2].
2. Egin klik eskuineko botoiaz **Certificate Templates** (Ziurtagiri Txantiloiak) > **Manage** (Kudeatu)[cite: 2].
3. Bilatu **Servidor web** (Web Server) txantiloia, egin klik eskuineko botoiaz eta hautatu **Duplicate Template** (Bikoiztu Txantiloia)[cite: 2]:
   - **General:** Ezarri izena: `WebExportable`[cite: 2].
   - **Request Handling (Eskabidearen izapidetzea):** Markatu *Allow private key to be exported* (Ahalduren gako pribatua esportatzea)[cite: 2].
   - **Subject Name (Subjektuaren izena):** Hautatu *Supply in the request* (Eskabidean emana)[cite: 2].
   - **Security (Segurtasuna):** Hautatu `Authenticated Users` (Autentifikatutako Erabiltzaileak) taldea eta markatu *Enroll* (Izena eman) aukera *Permit* (Baimendu) zutabean[cite: 2].
4. Sakatu **Apply** eta **OK**[cite: 2].
5. Itzuli `certsrv.msc` kontsolara, egin klik eskuineko botoiaz **Certificate Templates > New > Certificate Template to Issue**[cite: 2].
6. Zerrendatik hautatu `WebExportable` (edo `Servidor web`) eta sakatu **OK**[cite: 2].

---

### 1.3. Domeinu Anitzeko SAN Ziurtagiria (.PFX) Eskatzea eta Esportatzea

1. Sakatu `Win + R`, idatzi `mmc` eta sakatu **Enter**[cite: 2].
2. Joan **File > Add/Remove Snap-in...**, hautatu **Certificates**, hautatu **Computer account > Local computer > Finish > OK**[cite: 2].
3. Zabaltzeko: **Certificates (Local Computer) > Personal > Certificates**[cite: 2].
4. Klik eskuineko botoiaz lan-eremuan > **All Tasks > Request New Certificate...**[cite: 2]
5. Aurrera egin morroian (*Active Directory Enrollment Policy*)[cite: 2].
6. Markatu gaitutako txantiloiari dagokion laukia (`WebExportable`) eta egin klik testu horian: *"More information is required to enroll for this certificate"*[cite: 2].
7. **Subject** fitxan[cite: 2]:
   - **Alternative name (SAN)** atalean, aldatu **Type** aukera **DNS** izenera[cite: 2].
   - **Value** atalean, gehitu banan-banan izen hauek **Add** sakatuz[cite: 2]:
     - `*.biohealth.local`[cite: 2]
     - `*.biohealth.eus`[cite: 2]
     - `jitsi.biohealth.eus`[cite: 2]
     - `web.biohealth.local`[cite: 2]
     - `biohealth.local`[cite: 2]
8. Sakatu **OK** eta ondoren **Enroll**[cite: 2].
9. **Personal > Certificates** karpetan, egin klik eskuineko botoiaz sortutako ziurtagirian > **All Tasks > Export...**[cite: 2]
10. Hautatu **Yes, export the private key**[cite: 2].
11. Mantendu **Personal Information Exchange (.PFX)** formatua, ezarri babes-pasahitza eta gorde fitxategia `certificado.pfx` izenarekin Mahaiganean (`C:\Users\Administrador\Desktop\certificado.pfx`)[cite: 2].

---

## 2. Configuración en Servidor 1: WordPress / GLPI / Apache (192.168.10.4)

### 2.1. Ziurtagiria Transferitzea eta Instalatzea

1. Transferitu `certificado.pfx` fitxategia Windows Server-etik SCP edo SSH bidez 1. Zerbitzariko `/tmp/` direktoriora[cite: 3].
2. Erauzi ziurtagiri publikoa eta gako pribatua OpenSSL erabiliz[cite: 3]:
   ```bash
   cd /tmp
   sudo openssl pkcs12 -in certificado.pfx -clcerts -nokeys -out /etc/ssl/certs/web.biohealth.local.crt -nodes
   sudo openssl pkcs12 -in certificado.pfx -nocerts -out /etc/ssl/private/web.biohealth.local.key -nodes
   ```[cite: 3]
3. Doitu irakurtzeko baimenak[cite: 3]:
   ```bash
   sudo chmod 600 /etc/ssl/private/web.biohealth.local.key
   sudo chmod 644 /etc/ssl/certs/web.biohealth.local.crt
   ```[cite: 3]

### 2.2. Apache eta WordPress Konfiguratzea

1. Gaitu SSL modulua eta gune seguru lehenetsia[cite: 3]:
   ```bash
   sudo a2enmod ssl
   sudo a2ensite default-ssl
   ```[cite: 3]
2. Editatu SSL VirtualHost fitxategia (`/etc/apache2/sites-available/default-ssl.conf`)[cite: 3]:
   ```apache
   SSLCertificateFile /etc/ssl/certs/web.biohealth.local.crt
   SSLCertificateKeyFile /etc/ssl/private/web.biohealth.local.key
   ```[cite: 3]
3. Editatu `/var/www/html/wp-config.php` nabigazioa eta irudiak HTTPS bidez kargatzera behartzeko eta IP helbiderako birbideratze-begiztak ekiditeko[cite: 3]:
   ```php
   define('WP_HOME', '[https://web.biohealth.local](https://web.biohealth.local)');
   define('WP_SITEURL', '[https://web.biohealth.local](https://web.biohealth.local)');
   ```[cite: 4]
4. Berrabiarazi Apache[cite: 4]:
   ```bash
   sudo apache2ctl configtest
   sudo systemctl restart apache2
   ```[cite: 4]

---

## 3. Configuración en Servidor 2: Jitsi Meet / Nginx (192.168.10.5)

### 3.1. Transferentzia eta SCP Baimenen Arazoa Konpontzea

SCP bidez root ez den `biohealth` erabiltzailearekin `/tmp/` direktorioan zuzenean idazteko baimen murrizketak zirela eta, transferentzia bi urratsetan egin zen[cite: 4]:

1. Windows Server-eko CMD-tik (`.pfx` fitxategia dagoen karpetan)[cite: 4]:
   ```cmd
   cd C:\Users\Administrador\Desktop
   scp certificado.pfx biohealth@192.168.10.5:/home/biohealth/
   ```[cite: 4]
2. 2. Zerbitzariko (Jitsi) terminalean, mugitu fitxategia `/tmp/` karpetara[cite: 4]:
   ```bash
   sudo mv /home/biohealth/certificado.pfx /tmp/
   ls -l /tmp/certificado.pfx
   ```[cite: 4]

### 3.2. Ziurtagiriak Erauztea eta Nginx / Prosody Konfiguratzea

1. Erauzi PKCS#12 edukiontziko fitxategiak sintaxian aukera egokiak erabiliz (`-clcerts` eta `-nocerts` marratxoarekin `-`)[cite: 4]:
   ```bash
   cd /tmp
   # Ziurtagiri publikoa erauzi (.crt)
   sudo openssl pkcs12 -in certificado.pfx -clcerts -nokeys -out /etc/ssl/certs/jitsi.biohealth.eus.crt -nodes

   # Gako pribatua erauzi (.key)
   sudo openssl pkcs12 -in certificado.pfx -nocerts -out /etc/ssl/private/jitsi.biohealth.eus.key -nodes
   ```[cite: 4, 5]
2. Esleitu Jitsi-ko Prosody zerbitzuak behar dituen jabetza eta baimenak[cite: 5]:
   ```bash
   sudo chmod 600 /etc/ssl/private/jitsi.biohealth.eus.key
   sudo chmod 644 /etc/ssl/certs/jitsi.biohealth.eus.crt
   sudo chown prosody:prosody /etc/ssl/certs/jitsi.biohealth.eus.crt /etc/ssl/private/jitsi.biohealth.eus.key
   ```[cite: 5]
3. Editatu Nginx gunearen konfigurazio fitxategia[cite: 5]:
   ```bash
   sudo nano /etc/nginx/sites-available/jitsi.biohealth.eus.conf
   ```[cite: 5]
4. Ziurtatu direktibak `.eus` domeinu-luzapen osoa duten bide-izenetara bideratuta daudela[cite: 5]:
   ```nginx
   ssl_certificate /etc/ssl/certs/jitsi.biohealth.eus.crt;
   ssl_certificate_key /etc/ssl/private/jitsi.biohealth.eus.key;
   ```[cite: 5]
5. Probatu Nginx sintaxia eta berrabiarazi zerbitzuak[cite: 5]:
   ```bash
   sudo nginx -t
   sudo systemctl restart nginx prosody jicofo
   ```[cite: 5]

> **Nginx Egiaztapena:** `sudo nginx -t` aginduak erantzun hau eman behar du[cite: 5]:  
> `nginx: configuration file /etc/nginx/nginx.conf test is successful.`[cite: 5]

---

## 4. Konfiantza Banatzea eta Bezeroetan Egiaztatzea

1. **Erroko CA Zabaltzea:** Active Directory-n integratutako Enterprise CA denez, `biohealth-ZERBITZARIPRINT-CA` erakundearen gako publikoa automatikoki zabaldu zen `biohealth.local` domeinura bildutako Windows ordenagailu guztien Konfiantzazko erroko zertifikazio-agintariak biltegira[cite: 6].
2. **Nabigatzailearen Kachea:** Ziurtagiria instalatu ondoren segurtasun abisua mantentzen zen ordenagailuetan, kachea freskatzera behartu zen `Ctrl + F5` bidez edo nabigatzailearen datuak ezabatuz (`Ctrl + Shift + Ezabatu`)[cite: 6].
3. **Azken Egiaztapena:** Domeinuko edozein nabigatzailetatik helbide hauetara sartzean[cite: 6]:
   - `https://web.biohealth.local`[cite: 6]
   - `https://jitsi.biohealth.eus`[cite: 6]

Bi zerbitzuek konexio seguruaren **ikono berdea** erakusten dute, amaieratik amaierako konfiantza-kate balioduna adieraziz eta pribatutasun abisurik gabe[cite: 6].
