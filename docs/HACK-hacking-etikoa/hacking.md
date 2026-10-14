# BioHealth Pentesting eta Segurtasun Analisiaren Dokumentazio Osoa

Dokumentu honek BioHealth enpresako azpiegituraren pentesting faseak, identifikatutako ahuleziak eta proba-laborategiko (Metasploitable 2) zerbitzu zein prozesuen azterketa tekniko eta praktikoa biltzen ditu.

---

## 1. Pentesting Bateko Faseak (BioHealth Erakundearen Adibidea)

Fase hauek BioHealth enpresaren azpiegitura mediko eta hodeiko ingurunea oinarri hartuta gauzatu dira:

### 1. Plangintza eta Informazio-Bilaketa (Reconnaissance / OSINT)
- **Deskribapena:** BioHealth-en aurkako eraso erreal bat simulatu aurretik, informazioa modu pasibo eta aktiboan biltzen da, osasun-sistemak edo zerbitzuak kaltetuko dituzten alertak piztu gabe[cite: 11].
- **BioHealth-eko Adibidea:**
  - **OSINT:** Azterketa publikoen bidez, ikerketa-taldeko kideen kredentzialak eta osasun-datuak kudeatzeko erabiltzen diren APIen dokumentazioa lortu da[cite: 11].
  - **Domeinuak/Azpidomeinuak:** `biohealth.eus`, `pacientes.biohealth.eus`, `telemedicina.biohealth.eus` eta `lab-portal.biohealth.eus` bezalako azpidomeinuak kokatzea[cite: 11].
- **Egiaztapena:** Publikoki azaldutako atarien eta langileen posta-helbideen mapa osatzean lortzen da[cite: 11].

### 2. Ahulguneen Azterketa eta Eskaneatzea (Scanning & Vulnerability Assessment)
- **Deskribapena:** Analisi automatizatu eta manualak erabiliz, sareko portu irekiak, osasun-software zaharkituak eta konfigurazio okerrak detektatzen dira[cite: 11].
- **BioHealth-eko Adibidea:**
  - **Sare eta Zerbitzuen Azterketa:** Telemedikuntza eta laborategiko informazioa kudeatzeko sistemen (LIMS) zerbitzarien ataka irekiak aztertzea[cite: 11].
  - **Web/API Eskaneatzea:** Pazienteen atarian eta historia klinikoak ikusteko APIan autentifikazio eta baimen-kontrolen azterketa[cite: 11].
- **Egiaztapena:** Software zaharkituen eta segurtasun-falten zerrenda teknikoa osatzean[cite: 11].

### 3. Ustiapena (Exploitation)
- **Deskribapena:** Detektatutako ahuleziak erabiliz, pazienteen datu klinikoetara baimenik gabe sartzea edo sistemen logika manipulatzeko saiakera egiaztatzea[cite: 11].
- **BioHealth-eko Adibidea:**
  - **Baimen Kontrolen Gabezia (IDOR):** Paziente baten identifikagailua aldatzean (`/api/paciente/101` -> `/api/paciente/102`), beste paziente baten historia klinikoa ikusteko gaitasuna egiaztatzea[cite: 11].
  - **SQL Injection (SQLi):** Laborategiko emaitzen bilaketa-formularioan datu-baseko taulak atzitzeko bidea aurkitzea[cite: 11].
- **Egiaztapena:** Baimenik gabe datu-baseko erregistro babestuetara iristea lortzen denean[cite: 11].

### 4. Ustiapen Osteko Fasea eta Mugimendu Laterala (Post-Exploitation & Lateral Movement)
- **Deskribapena:** Lortutako sarbideari eustea eta barne-sarean zehar laborategiko zein gailu medikoen sarera mugitzea[cite: 12].
- **BioHealth-eko Adibidea:**
  - Web zerbitzaritik abiatuta, ikerketa-datu babestuak gordetzen dituen barne-zerbitzarira jauzi egitea (*pivoting*)[cite: 12].
  - Active Directory bidez kudeatzen diren laborategiko ordenagailuen kontrola aztertzea[cite: 12].
- **Egiaztapena:** Barne-sareko administratzaile-pribilegioak lortzea edo datu medikoen biltegi nagusira iristea[cite: 12].

### 5. Txostenketa eta Konponbide-Gomendioak (Reporting & Remediation)
- **Deskribapena:** Aurkikuntza guztiak dokumentatzea, osasun-sektoreko araudiak (HIPAA, GDPR) kontuan hartuz arriskua sailkatzea eta konponbideak ematea[cite: 12].
- **BioHealth-eko Adibidea:** Talde teknikoari eta zuzendaritzari bideratutako txostenak prestatzea, osasun-datuen konfidentzialtasuna bermatzeko neurriekin[cite: 12].
- **Egiaztapena:** Babes-plana eta zuzenketak (enkripzioa, baimen-egiaztapen sendoak) ezartzean[cite: 12].

---

## 2. BioHealth Enpresaren Ahuleziak eta Jaso Ditzakeen Erasoak

| Ahulezia Arloa | Ahulezia Zehatza BioHealth-en | Jaso Dezakeen Erasoa / Inpaktua | CVSS Zorrotasuna |
| :--- | :--- | :--- | :--- |
| **1. API eta Web Atariak**[cite: 12] | Pazienteen atarian Baimen Kudeaketa Okerra (BPOA/IDOR)[cite: 12]. | **Baimenik gabeko datu-atzipena:** Beste bezero edo paziente batzuen analitika eta historia klinikoak ikustea edo deskargatzea[cite: 12]. | **KRITIKOA (9.1)**[cite: 12] |
| **2. Datu-Baseak**[cite: 13] | Sarrerako datuen sanizazio falta analitiken bilatzailean[cite: 13]. | **SQL Injection (SQLi):** Erasotzaile batek ikerketa medikoen datu-base osoa erauzteko edo ezabatzeko arriskua[cite: 13]. | **ALTUA (8.8)**[cite: 13] |
| **3. Telemedikuntza eta Komunikazioak**[cite: 13] | Telemedikuntza eta IoT gailuen arteko kanalen enkripzio ahula[cite: 13]. | **Man-in-the-Middle (MitM):** Bideodeietako datuak edo gailu medikoen neurketak bidean interzeptatzea edo manipulatzea[cite: 13]. | **TARTEKOA (7.4)**[cite: 13] |
| **4. Giza Faktorea**[cite: 13] | Laborategiko eta ikerketako langileen phishing prebentzio baxua[cite: 13]. | **Spear Phishing:** Ikerlari baten kredentzialak lortuz barne-sareko jabego intelektuala eta patenteak lapurtzea[cite: 13]. | **ALTUA (8.1)**[cite: 13] |

---

## 3. Proba-Ingurunearen Azpiegitura (Laborategia)

Pentesting-aren egiaztapen teknikoa egiteko, osasun-ingurunea simulatzen duen proba-laborategi isolatu hau konfiguratu da[cite: 13]:

```text
[WAN / Internet]
       |
[Firewalla / Routerra]
       |
+-------------------------------------------------------+
| DMZ Sarea (192.168.10.0/24)                            |
|  - Pazienteen Ataria & APIa (IP: 192.168.10.15)       |
|  - Telemedikuntza Zerbitzaria (IP: 192.168.10.20)     |
+-------------------------------------------------------+
       |
+-------------------------------------------------------+
| Barne LAN Sarea (10.0.2.0/24)                          |
|  - Kali Linux (Proba Makina) (IP: 10.0.2.5)           |
|  - Active Directory / Domain Controller (IP: 10.0.2.10)|
|  - Laborategiko Datu-Basea (LIMS) (IP: 10.0.2.50)      |
+-------------------------------------------------------+
```
[cite: 13]

### Laborategiko Ahulgune Nagusiak:
- **Pazienteen APIa:** API gakoen kudeaketa okerra eta baimen-kontrol gabezia IDOR erasoak simulatzeko[cite: 14].
- **LIMS Datu-Basea:** Babes-neurririk gabeko SQL kontsultak sarrera formularioetan[cite: 14].
- **Komunikazio Kanala:** Enkripziorik gabeko protokoloak (HTTP/Plaintext) barne-zerbitzuen artean[cite: 14].

---

## 4. Metasploitable 2: Zerbitzuen, Prozesuen eta Ahulezien Analisi Praktikoa

### 4.1. Zerbitzuen Zerrenda Lortzea (Scanning)
Kali Linux-etik Metasploitable makinako (`192.168.1.20`) ataka eta zerbitzu irekiak detektatzeko:

```bash
sudo nmap -sV 192.168.1.20
```
[cite: 14]

- **`-sV`:** Ataka irekiak eskaneatzen ditu eta zerbitzu bakoitzaren bertsio zehatza detektatzen du (HTTP, FTP, SSH, SMB, etab.)[cite: 15].
- **`192.168.1.20`:** Zure Metasploitable makinaren IP helbidea[cite: 15].

#### Emaitza
Segundo batzuen buruan, `PORT`, `STATE`, `SERVICE` eta `VERSION` zutabeak dituen taula bat ikusiko duzu[cite: 15].
- **Egiaztapena:** Zerbitzu ahulen multzo bat ireki ikusi beharko zenuke (adibidez, `21/tcp ftp vsftpd 2.3.4`, `22/tcp ssh OpenSSH`, `80/tcp http Apache`, etab.)[cite: 15].

#### Alternatiba (Metasploitable Kontsoletik Zuzenean):
```bash
sudo netstat -tlpn
```
[cite: 15]
Entzuten ari diren ataka guztiak (`LISTEN`) eta bakoitzari esleitutako prozesu/zerbitzuaren izena erakusten ditu[cite: 15].

---

### 4.2. Prozesuen Zerrenda Ikustea (Process Listing)

Exekuzioan dauden prozesuen zerrenda ikusteko, bi makinetako zeinetan kontsultatu nahi dituzun araberakoa da[cite: 16]:

#### 1. Metasploitable 2-ko prozesuak ikustea (Gomendatua)
- **Erakuste xehatua eta estatikoa:**
  ```bash
  ps aux
  ```[cite: 16]
  *(Prozesu guztiak, exekutatzen dituen erabiltzailea, CPU/RAM kontsumoa eta komandoaren bidea erakusten ditu)*[cite: 16].

- **Denbora errealeko monitore dinamikoa:**
  ```bash
  top
  ```
  [cite: 17]
  *(Prozesuak unean bertan eguneratzen erakusten ditu. Sakatu `q` tekla irteteko)*[cite: 17].

- **Prozesu zehatz bat iragaztea (adibidea: Apache bilatzea):**
  ```bash
  ps aux | grep apache
  ```[cite: 17]

#### 2. Metasploitable-ko urruneko prozesuak Kali Linux-etik ikustea
```bash
sudo nmap -sS -sV --script=banner 192.168.1.20
```
[cite: 17]

> **Oharra:** Denbora errealean prozesuen zerrenda zehatza `ps aux` bezalako komandoekin ikusteko, lehenik makinan sarbidea lortu beharko zenuke exploit baten edo SSH/Telnet saio baten bidez[cite: 17].

---

### 4.3. Zerbitzuen Ahulezi Nagusiak eta Bertsioen Analisia

Bai, bertsio horietako gehienak oso ahulak izateagatik dira ezagunak. Metasploitable 2 nahita diseinatu da bertsio horiekin erasoak praktikatzeko[cite: 18].

Eskaneoaren arabera ahultasun kritikoenen analisia[cite: 18]:

1. **21/tcp - vsftpd 2.3.4 (Backdoor / Atze-atea)**[cite: 18]
   - **Ahultasuna:** CVE-2011-2523. Bertsio zehatz honek backdoor ospetsu bat du. Aurpegi alai `:)` batez amaitzen den erabiltzaile-izen bat bidaltzen baduzu (adibidez: `user:)`), aplikazioak root shell bat irekitzen du zuzenean 6200 atakan[cite: 18].
   - **Arriskua:** Kritikoa. Root sarbidea berehala ematea[cite: 18].

2. **139/tcp eta 445/tcp - Samba smbd 3.X - 4.X**[cite: 18]
   - **Ahultasuna:** CVE-2007-2447 (`usermap_script`). Urruneko komando-exekuzioa ahalbidetzen du, kontsolako karaktereak (*Shell Metacharacters*) dituzten erabiltzaile-izen gaiztoak bidaliz[cite: 18].
   - **Arriskua:** Kritikoa. Helburuko makinan administratzaile (`root`) sarbidea zuzenean lortzea ahalbidetzen du[cite: 18, 19].

3. **1524/tcp - Metasploitable root shell (Bindshell)**[cite: 19]
   - **Ahultasuna:** Ez da software-ahultasun bat berez, baizik eta fabrikatik irekita utzitako ataka bat, autentifikaziorik gabeko shell batekin[cite: 19].
   - **Arriskua:** Kritikoa. `nc 192.168.1.20 1524` bidez konektatuz, root gisa sarbide zuzena lortzen duzu pasahitzik sartu gabe[cite: 19].

4. **512/tcp, 513/tcp, 514/tcp - rservices (exec, login, shell)**[cite: 19]
   - **Ahultasuna:** rlogin/rsh zerbitzu zaharkituak, `.rhosts` fitxategiaren bidezko konfiantzan oinarritutako autentifikazioarekin konfiguratuta[cite: 19].
   - **Arriskua:** Altua. Urruneko komandoak zuzenean exekutatzea ahalbidetzen dute, `rlogin` edo `rsh-client` bezalako tresnekin, pasahitzik eskatu gabe[cite: 19].

5. **80/tcp - Apache httpd 2.2.8**[cite: 19]
   - **Ahultasuna:** WebDAV, Cross-Site Scripting (XSS) eta urruneko fitxategi-inklusioarekin (LFI/RFI) lotutako ahultasun ugari. Gainera, web-aplikazio ahul integratuak ostatatzen ditu (DVWA, Mutillidae, phpMyAdmin bezalakoak)[cite: 19].
   - **Arriskua:** Altua[cite: 19].

6. **23/tcp - Linux telnetd**[cite: 19]
   - **Ahultasuna:** Kredentzialak testu argian, zifratu gabe, transmititzea[cite: 19].
   - **Arriskua:** Ertaina/Altua. Pasahitzak lortzea ahalbidetzen du trafikoa interzeptatuz (*sniffing*) edo indar gordinezko erasoen bidez, lehenetsitako kredentzialak erabiliz (`msfadmin:msfadmin`)[cite: 19].

---

### 4.4. Kali Linux-en Exploits Bilatzeko Tresna

`searchsploit` erabil dezakezu zure Kali kontsolan bertsio bakoitzerako exploit modulu zehatzak aurkitzeko[cite: 19]. Adibidez[cite: 19]:

```bash
searchsploit vsftpd 2.3.4
```
[cite: 20]

```bash
searchsploit samba 3.0.20
```
[cite: 20]
