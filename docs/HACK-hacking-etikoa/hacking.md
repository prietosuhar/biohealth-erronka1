# BioHealth Pentesting eta Segurtasun Analisiaren Dokumentazio Osoa

Dokumentu honek BioHealth enpresako azpiegituraren pentesting faseak, identifikatutako ahuleziak eta proba-laborategiko (**Metasploitable 2** eta **Kali Linux**) zerbitzu zein prozesuen azterketa tekniko eta praktikoa biltzen ditu.

---

## 1. Pentesting Bateko Faseak (BioHealth Erakundearen Adibidea)

Fase hauek BioHealth enpresaren azpiegitura mediko eta hodeiko ingurunea oinarri hartuta gauzatu dira:

### 1. Plangintza eta Informazio-Bilaketa (Reconnaissance / OSINT)
- **Deskribapena:** BioHealth-en aurkako eraso erreal bat simulatu aurretik, informazioa modu pasibo eta aktiboan biltzen da, osasun-sistemak edo zerbitzuak kaltetuko dituzten alertak piztu gabe.
- **BioHealth-eko Adibidea:**
  - **OSINT:** Azterketa publikoen bidez, ikerketa-taldeko kideen kredentzialak eta osasun-datuak kudeatzeko erabiltzen diren APIen dokumentazioa lortu da.
  - **Domeinuak/Azpidomeinuak:** `biohealth.eus`, `pacientes.biohealth.eus`, `telemedicina.biohealth.eus` eta `lab-portal.biohealth.eus` bezalako azpidomeinuak kokatzea.
- **Egiaztapena:** Publikoki azaldutako atarien eta langileen posta-helbideen mapa osatzean lortzen da.

### 2. Ahulguneen Azterketa eta Eskaneatzea (Scanning & Vulnerability Assessment)
- **Deskribapena:** Analisi automatizatu eta manualak erabiliz, sareko portu irekiak, osasun-software zaharkituak eta konfigurazio okerrak detektatzen dira.
- **BioHealth-eko Adibidea:**
  - **Sare eta Zerbitzuen Azterketa:** Telemedikuntza eta laborategiko informazioa kudeatzeko sistemen (LIMS) zerbitzarien ataka irekiak aztertzea (`nmap` bidez).
  - **Web/API Eskaneatzea:** Pazienteen atarian eta historia klinikoak ikusteko APIan autentifikazio eta baimen-kontrolen azterketa.
- **Egiaztapena:** Software zaharkituen eta segurtasun-falten zerrenda teknikoa osatzean.

### 3. Ustiapena (Exploitation)
- **Deskribapena:** Detektatutako ahuleziak erabiliz, pacienteen datu klinikoetara baimenik gabe sartzea edo sistemen logika manipulatzeko saiakera egiaztatzea.
- **BioHealth-eko Adibidea:**
  - **Baimen Kontrolen Gabezia (IDOR):** Paziente baten identifikagailua aldatzean (`/api/paciente/101` -> `/api/paciente/102`), beste paziente baten historia klinikoa ikusteko gaitasuna egiaztatzea.
  - **SQL Injection (SQLi):** Laborategiko emaitzen bilaketa-formularioan datu-baseko taulak atzitzeko bidea aurkitzea.
- **Egiaztapena:** Baimenik gabe datu-baseko erregistro babestuetara iristea lortzen denean.

### 4. Ustiapen Osteko Fasea eta Mugimendu Laterala (Post-Exploitation & Lateral Movement)
- **Deskribapena:** Lortutako sarbideari eustea eta barne-sarean zehar laborategiko zein gailu medikoen sarera mugitzea.
- **BioHealth-eko Adibidea:**
  - Web zerbitzaritik abiatuta, ikerketa-datu babestuak gordetzen dituen barne-zerbitzarira jauzi egitea (*pivoting*).
  - Active Directory bidez kudeatzen diren laborategiko ordenagailuen kontrola aztertzea.
- **Egiaztapena:** Barne-sareko administratzaile-pribilegioak lortzea edo datu medikoen biltegi nagusira iristea.

### 5. Txostenketa eta Konponbide-Gomendioak (Reporting & Remediation)
- **Deskribapena:** Aurkikuntza guztiak dokumentatzea, osasun-sektoreko araudiak (HIPAA, GDPR) kontuan hartuz arriskua sailkatzea eta konponbideak ematea.
- **BioHealth-eko Adibidea:** Talde teknikoari eta zuzendaritzari bideratutako txostenak prestatzea, osasun-datuen konfidentzialtasuna bermatzeko neurriekin.
- **Egiaztapena:** Babes-plana eta zuzenketak (enkripzioa, baimen-egiaztapen sendoak) ezartzean.

---

## 2. BioHealth Enpresaren Ahuleziak eta Jaso Ditzakeen Erasoak

| Ahulezia Arloa | Ahulezia Zehatza BioHealth-en | Jaso Dezakeen Erasoa / Inpaktua | CVSS Zorrotasuna |
| :--- | :--- | :--- | :--- |
| **1. API eta Web Atariak** | Pazienteen atarian Baimen Kudeaketa Okerra (BPOA/IDOR). | **Baimenik gabeko datu-atzipena:** Beste bezero edo paziente batzuen analitika eta historia klinikoak ikustea edo deskargatzea. | **KRITIKOA (9.1)** |
| **2. Datu-Baseak** | Sarrerako datuen sanizazio falta analitiken bilatzailean. | **SQL Injection (SQLi):** Erasotzaile batek ikerketa medikoen datu-base osoa erauzteko edo ezabatzeko arriskua. | **ALTUA (8.8)** |
| **3. Telemedikuntza eta Komunikazioak** | Telemedikuntza eta IoT gailuen arteko kanalen enkripzio ahula. | **Man-in-the-Middle (MitM):** Bideodeietako datuak edo gailu medikoen neurketak bidean interzeptatzea edo manipulatzea. | **TARTEKOA (7.4)** |
| **4. Giza Faktorea** | Laborategiko eta ikerketako langileen phishing prebentzio baxua. | **Spear Phishing:** Ikerlari baten kredentzialak lortuz barne-sareko jabego intelektuala eta patenteak lapurtzea. | **ALTUA (8.1)** |

---

## 3. Proba-Ingurunearen Azpiegitura (Laborategia)

Laborategiko egiaztapen praktikoan, bi makina erabili dira VirtualBox ingurune isolatu baten barruan, elkarren artean konektatuta (`ping` bidez egiaztatuta):

* **Kali Linux (Erasotzaile / Proba Makina):** `192.168.10.3`
* **Metasploitable 2 (Biktima Zerbitzaria):** `192.168.10.2`

```text
+-----------------------------------------------------------------------+
| VirtualBox Laborategi Isolatua (Sare-segmentua: 192.168.10.0/24)      |
|                                                                       |
|   +-----------------------+           +---------------------------+   |
|   |   Kali Linux          | <-------> |   Metasploitable 2        |   |
|   |   IP: 192.168.10.3    |   PING    |   IP: 192.168.10.2        |   |
|   +-----------------------+           +---------------------------+   |
+-----------------------------------------------------------------------+
```

### Konektibitate Egiaztapena (`ping`):
Metasploitable-tik Kali Linux-era konektibitatea egiaztatu zen:

```bash
msfadmin@metasploitable:~$ ping -c 4 192.168.10.3
```
<img width="1295" height="450" alt="image1" src="https://github.com/user-attachments/assets/41b9954b-fd42-4703-8d93-625923d29a5a" />

- **Emaitza:** 4 pakete bidalita, 4 jasoa, %0 packet loss.

## 4. Metasploitable 2: Zerbitzuen eta Ahulezien Analisi Praktikoa

### 4.1. Zerbitzuen eta Portuen Eskaneatzea (Nmap Result)
Kali Linux-etik (`192.168.10.3`) Metasploitable makinaren (`192.168.10.2`) portu eta zerbitzu guztiak aztertu dira komando honen bidez:

```bash
sudo nmap -p- 192.168.10.2
```

#### Nmap bidez detektatutako zerbitzuen taula xehatua:

| Ataka (PORT) | Egoera (STATE) | Zerbitzua (SERVICE) | Bertsioa / Xehetasuna (VERSION) |
| :--- | :--- | :--- | :--- |
| **21/tcp** | open | ftp | **vsftpd 2.3.4** |
| **22/tcp** | open | ssh | OpenSSH 4.7p1 Debian 8ubuntu1 |
| **23/tcp** | open | telnet | Linux telnetd |
| **25/tcp** | open | smtp | Postfix smtpd |
| **53/tcp** | open | domain | ISC BIND 9.4.2 |
| **80/tcp** | open | http | Apache httpd 2.2.8 ((Ubuntu) DAV/2) |
| **111/tcp** | open | rpcbind | 2 (RPC #100000) |
| **139/tcp** | open | netbios-ssn | Samba smbd 3.X - 4.X |
| **445/tcp** | open | netbios-ssn | Samba smbd 3.X - 4.X |
| **512/tcp** | open | exec | netkit-rsh rexecd |
| **513/tcp** | open | login | Netkit rshd |
| **514/tcp** | open | shell | Netkit rshd |
| **1099/tcp** | open | java-rmi | GNU Classpath grmiregistry |
| **1524/tcp** | open | bindshell | **Metasploitable root shell** |
| **2049/tcp** | open | nfs | 2-4 (RPC #100003) |
| **2121/tcp** | open | ftp | ProFTPD 1.3.1 |
| **3306/tcp** | open | mysql | MySQL 5.0.51a-3ubuntu5 |
| **3632/tcp** | open | distccd | distccd v1 (GNU 4.2.4) |
| **5432/tcp** | open | postgresql | PostgreSQL DB 8.3.0 - 8.3.7 |
| **5900/tcp** | open | vnc | VNC (protocol 3.3) |
| **6000/tcp** | open | X11 | (access denied) |
| **6667/tcp** | open | irc | **UnrealIRCd** |
| **6697/tcp** | open | irc | **UnrealIRCd** |
| **8009/tcp** | open | ajp13 | Apache Jserv (Protocol v1.3) |
| **8180/tcp** | open | http | Apache Tomcat/Coyote JSP engine 1.1 |
| **8787/tcp** | open | drb | Ruby DRB RMI (Ruby 1.8) |
| **41026/tcp** | open | java-rmi | GNU Classpath grmiregistry |
| **55025/tcp** | open | nlockmgr | 1-4 (RPC #100021)|
| **56382/tcp** | open | status | 1 (RPC #100024) |
| **60044/tcp** | open | mountd | 1-3 (RPC #100005)|

<img width="728" height="823" alt="image2" src="https://github.com/user-attachments/assets/b68f6edb-8b23-4325-b44d-6c42acf03027" />


- **MAC Helbidea:** `08:00:27:DF:92:82` (Oracle VirtualBox virtual NIC).

---

### 4.2. Detektatutako Zerbitzuen Ahulezi Nagusien Analisi Teknikoa

Eskaneoaren emaitzak oinarri hartuta, ataka bakoitzean aurkitutako ahulezia kritikoen azterketa:

1. **vsftpd 2.3.4 (21/tcp ataka):**
   - **Ahultasuna:** Bertsio zehatz honek txertatutako atze-atea (*backdoor*) dauka (2011n iturburu-kodea konprometitu zenean sartua). User-ean `:)` karaktereak idaztean, zerbitzuak root shell bat irekitzen du 6200 atakan.
   - **Metasploit modulua:** `exploit/unix/ftp/vsftpd_234_backdoor`.

2. **UnrealIRCd (6667, 6697 atakak):**
   - **Ahultasuna:** Garai hartan banatutako bertsioek atze-ate bat zuten `Downlink.c` fitxategian. IRC atakan kate berezi bat bidalita, komando arbitrarioak urrunetik exekutatzea ahalbidetzen du.

3. **distccd (3632 ataka):**
   - **Ahultasuna:** Gaizki konfiguratutako `distcc` zerbitzua (sarbide-murrizketarik gabe). Urrunetik eta autentifikaziorik gabe komandoak exekutatzea ahalbidetzen du; makina honetako eraso-bektore errazenetako bat da.

4. **Samba 3.X (139 / 445 atakak):**
   - **Ahultasuna:** Garai hartako 3.x bertsioak urrunetik kodea exekutatzeko ahulak dira (`username map script` RCE ahulezia adibidez).

5. **rexec / rlogin / rsh (512, 513, 514 atakak):**
   - **Ahultasuna:** "R-commands" motako zerbitzu zaharkituak eta zifratu gabeak. System host-aren konfiantzazko autentifikazioa (`.rhosts`) onartzen dute, kredentzialak testu lauan atzematea erraztuz.

6. **bindshell (1524/tcp ataka):**
   - **Ahultasuna:** Aurretik irekita dagoen root shell zuzena (autentifikaziorik gabea). Ataka honetara konektatzean root sarbidea lortzen da zuzenean.

7. **NFS 2-4 (2049/tcp) eta rpcbind (111/tcp):**
   - **Ahultasuna:** Autentifikazio egokirik gabe konfiguratutako NFS esportazioak, sistema osoko fitxategi-sistemak baimenik gabe muntatzea ahalbidetzen dutenak.

8. **Java RMI / GNU Classpath grmiregistry (1099, 41026 atakak):**
   - **Ahultasuna:** Agerian dagoen RMI erregistroak deserializazio bidezko RCE erasoak ahalbidetzen ditu klase gaiztoak injektatuz.

9. **Apache Tomcat / Coyote JSP (8180 ataka):**
   - **Ahultasuna:** Kredentzial lehenetsi ahulekin datorren manager kudeatzailea. WAR fitxategi gaiztoak igotzea eta RCE lortzea ahalbidetzen du.

10. **ProFTPD 1.3.1 (2121 ataka) eta Apache 2.2.8 WebDAV-ekin (80 ataka):**
    - **Ahultasuna:** Ahultasun ezagunak dituzten bertsioak; DAV gaituta duen Apache 2.2.8 bertsioa CVE askoren aurrean ahula da (`mod_ssl` arazoak barne).

11. **MySQL 5.0 (3306) eta PostgreSQL 8.3 (5432):**
    - **Ahultasuna:** Bertsio zaharkituak autentifikazioa saihesteko eta baimenik gabe datu-baseak atzitzeko ahuleziekin.

12. **Ruby DRb (8787 ataka):**
    - **Ahultasuna:** Autentifikaziorik gabeko DRb zerbitzua, urruneko metodo-deien bidez kodea exekutatzea ahalbidetzen duena.

13. **OpenSSH 4.7p1 (22/tcp ataka):**
    - **Ahultasuna:** Bertsio honek garai hartako Debian OpenSSL bug ezaguna du gakoen sorkuntzan.
