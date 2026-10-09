# BioHealth - Pentesting eta Segurtasun Analisia

Dokumentu honek **BioHealth** enpresaren azpiegitura mediko zein hodeiko ingurunean egindako pentesting eta segurtasun-auditoretza teknikoaren xehetasunak biltzen ditu.

---

## 1. Pentesting Bateko Faseak (BioHealth Enpresaren Adibidearekin)

Fase hauek BioHealth-en azpiegitura mediko eta hodeiko ingurunea oinarri hartuta gauzatu dira:

### 1. Plangintza eta Informazio-Bilaketa (*Reconnaissance / OSINT*)
* **Deskribapena:** BioHealth-en aurkako eraso erreal bat simulatu aurretik, informazioa modu pasibo eta aktiboan biltzen da, osasun-sistemak edo zerbitzuak kaltetuko dituzten alertak piztu gabe.
* **BioHealth-eko Adibidea:**
  * **OSINT:** Azterketa publikoen bidez, ikerketa-taldeko kideen kredentzialak eta osasun-datuak kudeatzeko erabiltzen diren API-en dokumentazioa lortu da.
  * **Domeinuak/Azpidomeinuak:** `biohealth.eus`, `pacientes.biohealth.eus`, `telemedicina.biohealth.eus` eta `lab-portal.biohealth.eus` bezalako azpidomeinuak kokatzea.
* **Egiaztapena:** Publikoki azaldutako atarien eta langileen posta-helbideen mapa osatzean lortzen da.

---

### 2. Ahulguneen Azterketa eta Eskaneatzea (*Scanning & Vulnerability Assessment*)
* **Deskribapena:** Analisi automatizatu eta manualak erabiliz, sareko portu irekiak, osasun-software zaharkituak eta konfigurazio okerrak detektatzen dira.
* **BioHealth-eko Adibidea:**
  * **Sare eta Zerbitzuen Azterketa:** Telemedikuntza eta laborategiko informazioa kudeatzeko sistemen (LIMS) zerbitzarien ataka irekiak aztertzea.
  * **Web / API Eskaneatzea:** Pazienteen atarian eta historia klinikoak ikusteko APIan autentifikazio eta baimen-kontrolen azterketa.
* **Egiaztapena:** Software zaharkituen eta segurtasun-falten zerrenda teknikoa osatzean.

---

### 3. Ustiapena (*Exploitation*)
* **Deskribapena:** Detektatutako ahuleziak erabiliz, pacienteen datu klinikoetara baimenik gabe sartzea edo sistemen logika manipulatzeko saiakera egiaztatzea.
* **BioHealth-eko Adibidea:**
  * **Baimen Kontrolen Gabezia (IDOR):** Paziente baten identifikagailua aldatzean (`/api/paciente/101` -> `/api/paciente/102`), beste paziente baten historia klinikoa ikusteko gaitasuna egiaztatzea.
  * **SQL Injection (SQLi):** Laborategiko emaitzen bilaketa-formularioan datu-baseko taulak atzitzeko bidea aurkitzea.
* **Egiaztapena:** Baimenik gabe datu-baseko erregistro babestuetara iristea lortzen denean.

---

### 4. Ustiapen Osteko Fasea eta Mugimendu Laterala (*Post-Exploitation & Lateral Movement*)
* **Deskribapena:** Lortutako sarbideari eustea eta barne-sarean zehar laborategiko zein gailu medikoen sarera mugitzea.
* **BioHealth-eko Adibidea:**
  * Web zerbitzaritik abiatuta, ikerketa-datu babestuak gordetzen dituen barne-zerbitzarira jauzi egitea (*pivoting*).
  * Active Directory bidez kudeatzen diren laborategiko ordenagailuen kontrola aztertzea.
* **Egiaztapena:** Barne-sareko administratzaile-pribilegioak lortzea edo datu medikoen biltegi nagusira iristea.

---

### 5. Txostenketa eta Konponbide-Gomendioak (*Reporting & Remediation*)
* **Deskribapena:** Aurkikuntza guztiak dokumentatzea, osasun-sektoreko araudiak (HIPAA, GDPR) kontuan hartuz arriskua sailkatzea eta konponbideak ematea.
* **BioHealth-eko Adibidea:** Talde teknikoari eta zuzendaritzari bideratutako txostenak prestatzea, osasun-datuen konfidentzialtasuna bermatzeko neurriekin.
* **Egiaztapena:** Babes-plana eta zuzenketak (enkripzioa, baimen-egiaztapen sendoak) ezartzean.

---

## 2. BioHealth Enpresaren Ahuleziak eta Jaso Ditzakeen Erasoak

| Ahulezia Arloa | Ahulezia Zehatza BioHealth-en | Jaso Dezakeen Erasoa / Inpaktua | CVSS Zortasuna |
| :--- | :--- | :--- | :---: |
| **1. API eta Web Atariak** | Pazienteen atarian Baimen Kudeaketa Okerra (BPOA/IDOR). | **Baimenik gabeko datu-atzipena:** Beste bezero edo paziente batzuen analitika eta historia klinikoak ikustea edo deskargatzea. | **KRITIKOA (9.1)** |
| **2. Datu-Baseak** | Sarrerako datuen sanizazio falta analitiken bilatzailean. | **SQL Injection (SQLi):** Erasotzaile batek ikerketa medikoen datu-base osoa erauzteko edo ezabatzeko arriskua. | **ALTUA (8.8)** |
| **3. Komunikazioak** | Telemedikuntza eta IoT gailuen arteko kanalen enkripzio ahula. | **Man-in-the-Middle (MitM):** Bideodeietako datuak edo gailu medikoen neurketak bidean interzeptatzea edo manipulatzea. | **TARTEKOA (7.4)** |
| **4. Giza Faktorea** | Laborategiko eta ikerketako langileen phishing prebentzio baxua. | **Spear Phishing:** Ikerlari baten kredentzialak lortuz barne-sareko jabego intelektuala eta patenteak lapurtzea. | **ALTUA (8.1)** |

---

## 3. Proba-Ingurunearen Azpiegitura (Laborategia)

Pentesting-aren egiaztapen teknikoa egiteko, osasun-ingurunea simulatzen duen proba-laborategi isolatu hau konfiguratu da:

```text
[ WAN / Internet ]
        │
 [ Firewalla / Routerra ]
        ├── DMZ Sarea (192.168.10.0/24)
        │     ├── Pazienteen Ataria & APIa   -> IP: 192.168.10.15
        │     └── Telemedikuntza Zerbitzaria -> IP: 192.168.10.20
        │
        └── Barne LAN Sarea (10.0.2.0/24)
              ├── Kali Linux (Proba Makina)               -> IP: 10.0.2.5
              ├── Active Directory / Domain Controller     -> IP: 10.0.2.10
              └── Laborategiko Datu-Basea (LIMS)           -> IP: 10.0.2.50
