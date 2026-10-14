---
title: Hardwarea eta lizentziak
parent: "HW – Hardwarea"
nav_order: 1
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# BioHealth — Ekipoen txostena (HW/SW) eta egoitzaren planoa

2026-10-13 · BioHealth taldea (SISA2, 1. Erronka)

## Laburpena

BioHealth-en informatika osoak **32.623,37 € kostatzen du BEZ gabe (39.474,28 € BEZ barne)**: 20 langilerentzat 15 mini PC eta 4 eramangarri, zerbitzari fisiko bat (Proxmox, makina birtualekin), babeskopietarako NAS bat, suebakia, sarea, inprimagailuak eta lizentziak. Erabaki nagusia: **markako ekipo estandarizatuak**, piezaka muntatu beharrean. Horrela, Windows 11 Pro, TPM 2.0 eta 3 urteko bermea ekipo bakoitzarekin datoz.

| Zer                 | Zenbat        | Modeloa                                           |
|---------------------|---------------|---------------------------------------------------|
| Lanpostuak          | 14 + 1 (db01) | Lenovo ThinkCentre M70q Gen 5                     |
| Eramangarriak       | 4             | Lenovo ThinkPad T14 Gen 6                         |
| Pantailak           | 23            | Dell Pro 24 Plus P2426H / Dell Pro 27 Plus P2725D |
| Zerbitzaria (pve01) | 1             | Dell PowerEdge T360                               |
| Babeskopiak         | 1 + 2 disko   | Synology DS225+ + 2 × HAT3300 4 TB                |
| Suebakia            | 1             | Protectli Vault VP2410 + pfSense CE               |
| Sarea               | 1 + 2         | TP-Link Omada SG3452XP + 2 × EAP650               |
| SAI                 | 2             | APC Smart-UPS 1500 VA eta 750 VA                  |
| Inprimaketa         | 4             | Brother MFC-L5710DW (2), HL-L5210DW, QL-820NWBc   |

Prezioak 2026-10-13koak dira, enpresentzako dendetakoak (gehienak Bechtle España). Bi lerro estimazioak dira (1.800 € BEZ gabe): bigarren SSDa eta kableatzea.

## Nola erabaki dugu

Ekipo mota bakoitza proposamenaren bost irizpideekin baloratu dugu, hardwarera egokituta. Markako ekipo estandarizatuak irabazi dute, in situ bermearekin: osasun-datuekin (DBEO 9. art.) gaizki muntatutako edo geldirik dagoen PC bat arriskua da, ez aurrezpena.

1. **IEak betetzen ditu** (Hardwarea): inbentarioa, osagaiak azalduta, kostua eta lizentziak.

2. **Kostu osoa**: erosketa + lizentzia + muntatzeko orduak + kontsumoa, ez piezaren prezioa bakarrik.

3. **Osasun-datuen segurtasuna**: TPM 2.0 BitLockerrerako, urruneko kudeaketa, in situ bermea.

4. **Iraunkortasuna**: kontsumo txikia, energia-etiketa, 5 urteko bizitza, konpongarria.

5. **Mantentze erraza**: modelo bat mota bakoitzeko, Windows irudi bera guztientzat, inbentario automatikoa GLPIn.

### Lanpostuak: bost aukera

| Aukera                                     | Abantailak                                                                                                         | Desabantailak                                                                                                 | Erabakia                                        |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| A. Piezaka muntatu (taldearen zirriborroa) | Osagai bakoitza ikusten da; malgua                                                                                 | Windows 11 Pro lizentzia aparte ekipo bakoitzean; bermea piezaz pieza; muntatzeko orduak; DDR4/DDR5 nahasketa | Baztertua                                       |
| B. Markako dorrea                          | Oso handigarria; Windows 11 Pro OEM barne                                                                          | Lekua hartzen du kontsulta txikietan; gehiago kontsumitzen du                                                 | Baztertua                                       |
| **C. Markako mini PCa**                    | Monitorearen atzean doa (VESA); kontsumo txikia; Windows 11 Pro OEM, TPM 2.0 eta bermea; irudi bakarra guztientzat | Gutxi handitzen da (2 RAM zirrikitu, M.2 gutxi)                                                               | **Aukeratua** (db01 ere bai, 1 TB-ko bertsioan) |
| D. All-in-one                              | Garbia eta txikia                                                                                                  | Pantaila hondatuz gero PC osoa galtzen da; konpontzea garestia                                                | Baztertua                                       |
| E. Bezero arina + VDI                      | Datuak zerbitzarian bakarrik                                                                                       | Zerbitzari askoz indartsuagoa eta RDS lizentziak; zerbitzaria eroriz gero inork ez du lan egiten              | Baztertua                                       |

### Zerbitzaria: lau aukera

| Aukera                           | Abantailak                                                                                 | Desabantailak                                                                              | Erabakia                                           |
|----------------------------------|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|----------------------------------------------------|
| **A. Markako dorre-zerbitzaria** | RAM ECC, urruneko kudeaketa (iDRAC), RAID kontroladorea, 3 urteko in situ zerbitzua; isila | PC bat baino garestiagoa                                                                   | **Aukeratua**                                      |
| B. Rack zerbitzaria              | Armairuan txukun                                                                           | Lurreko armairu sakona behar du (≥ 800 mm) eta zaratatsuagoa da                            | Baztertua 20 laneko klinika baterako               |
| C. PC indartsua zerbitzari gisa  | Merkea                                                                                     | ECCrik eta urruneko kudeaketarik ez: RAM akats batek datuak hondatzen ditu ohartarazi gabe | Baztertua                                          |
| D. Hodeia (Azure, AWS)           | Hardwarerik ez                                                                             | Hileko kuota betirako; Internet eroriz gero kontsultarik ez; datu klinikoak kanpoan        | Baztertua; hodeia kanpoko kopia zifraturako soilik |

## Lanpostuak sailka

Sail guztiek mini PC bera dute; aldatzen dena pantaila eta periferikoak dira. Erizaintzan eta Medikuntzan txandaka lan egiten dute, eta AD domeinuari esker edozein langile sar daiteke edozein PCtan bere kontuarekin. Horregatik ez dago PC bat pertsona bakoitzeko.

| Saila          | Langileak | Ekipoak                                        | Pantailak                 | Periferikoak                                           | Zergatik                                                                                                   |
|----------------|-----------|------------------------------------------------|---------------------------|--------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| Harrera        | 3         | 3 × M70q                                       | 3 × 24" FHD               | MFC-L5710DW, QL-820NWBc (eskumuturrekoak eta etiketak) | Lan arina baina egun osoan; abiarazte azkarra eta mostradorean leku gutxi                                  |
| Medikuntza     | 5         | 3 × M70q (kontsultak) + 2 × ThinkPad T14       | 3 × 27" QHD               | 3 webcam + 3 entzungailu                               | Historia klinikoa eta probak aldi berean; QHDk irudi gehiago erakusten du; eramangarriak telekontsultarako |
| Erizaintza     | 6         | 3 × M70q                                       | 3 × 24" FHD               | HL-L5210DW                                             | Kontsulta txikiak: PCa monitorearen atzean, mahaia libre eta garbitzeko erraza                             |
| Administrariak | 4         | 4 × M70q                                       | 8 × 24" FHD (bi pantaila) | MFC-L5710DW (eskanerra)                                | Kalkulu-orriak eta fakturak bi dokumentu ondoan ikusita                                                    |
| Informatika    | 2         | 2 × ThinkPad T14 (32 GB) + 1 × M70q (tailerra) | 6 × 27" QHD               | 2 webcam + 2 entzungailu                               | Makina birtualak eta urruneko laguntza; tailerreko PCa irudiak sortzeko eta probetarako                    |
| CPD            | —         | 1 × M70q 1 TB (db01)                           | — (RDP bidez)             | —                                                      | MariaDB eta MongoDB, taldeak erabaki bezala Windows 11 Pro ekipo batean                                    |

### Mini PCaren osagaiak: Lenovo ThinkCentre M70q Gen 5 (12TD000GSP)

| Osagaia       | Zehaztapena                                             | Zergatik nahikoa den                                                            |
|---------------|---------------------------------------------------------|---------------------------------------------------------------------------------|
| PUZ           | Intel Core i5-14400T, 10 nukleo / 16 hari, 35 W         | Ofimatika, historia klinikoa eta bideokonferentzia batera, kontsumo txikiarekin |
| RAM           | 16 GB DDR5-4800 SO-DIMM (1/2 zirrikitu, gehienez 64 GB) | Zirrikitu bat libre: 32 GB-ra handitu daiteke ekipoa aldatu gabe                |
| Biltegiratzea | 512 GB SSD M.2 NVMe PCIe 4.0, Opal (db01: 1 TB)         | Hardware bidezko zifratzea BitLockerrekin; bigarren M.2 zirrikitua libre        |
| Grafikoak     | Intel UHD 730, integratua                               | 2 pantaila (HDMI + DP) txartel gehigarririk gabe                                |
| Sarea         | Gigabit Ethernet + Wi-Fi 6E + Bluetooth                 | Kable bidez beti; Wi-Fi ordezko gisa                                            |
| Segurtasuna   | TPM 2.0, Kensington zirrikitua, vPro                    | BitLocker, urruneko kudeaketa eta lapurreta saihestea                           |
| Elikatzea     | 90 W-ko kanpoko egokigailua                             | Barruan iturririk ez: bero eta zarata gutxiago                                  |
| SE            | Windows 11 Pro OEM                                      | Domeinura batzeko eta GPOetarako beharrezkoa (Home-k ez du balio)               |
| Barne         | Teklatua eta sagua USB, 3 urteko bermea                 | Ez dago periferiko hori aparte erosi beharrik                                   |

Oharra: Bechtleren fitxak i5-14500T dio, baina 12TD000GSP fabrikatzailearen zenbakiaren datu-orriak (Icecat) i5-14400T eta UHD 730. Datu-orrian oinarritu gara.

### Lanpostuen prezioak

| Elementua                                                      | Kop. | Unitatea BEZ gabe | Unitatea BEZ barne | Guztira BEZ gabe |
|----------------------------------------------------------------|------|-------------------|--------------------|------------------|
| ThinkCentre M70q Gen 5 i5 / 16 GB / 512 GB                     | 14   | 689,99 €          | 834,89 €           | 9.659,86 €       |
| ThinkCentre M70q Gen 5 i5 / 16 GB / 1 TB (db01)                | 1    | 714,99 €          | 865,14 €           | 714,99 €         |
| Kopia pribatuagatiko kanona (PC bakoitzeko)                    | 15   | 5,33 €            | 6,45 €             | 79,95 €          |
| Dell Pro 24 Plus P2426H (24", FHD, IPS, 100 Hz)                | 14   | 139,99 €          | 169,39 €           | 1.959,86 €       |
| Dell Pro 27 Plus P2725D (27", QHD, IPS)                        | 9    | 217,99 €          | 263,77 €           | 1.961,91 €       |
| Logitech Brio 100 webcam (1080p, estalkiarekin)                | 5    | 37,00 €           | 44,77 €            | 185,00 €         |
| Jabra Evolve2 30 SE entzungailuak                              | 5    | 84,29 €           | 101,99 €           | 421,45 €         |
| ThinkPad T14 Gen 6 Core Ultra 5 / 16 GB / 512 GB (Medikuntza)  | 2    | 1.255,00 €        | 1.518,55 €         | 2.510,00 €       |
| ThinkPad T14 Gen 6 Core Ultra 5 / 32 GB / 512 GB (Informatika) | 2    | 1.424,00 €        | 1.723,04 €         | 2.848,00 €       |

Lanpostu arrunt batek (M70q + 24"-ko pantaila) **829,98 € BEZ gabe** kostatzen du. Taldearen zirriborroak 720–775 € zituen, baina Windows lizentziarik, iturririk eta kaxarik gabe. ThinkPad-en prezioak Bechtle Alemaniakoak dira; Espainian antzekoak izatea espero dugu.

## Zerbitzaria eta CPDa

Zerbitzari fisiko bakarra dago (**pve01**, Dell PowerEdge T360), eta Proxmox VE erabiltzen du makina birtualak exekutatzeko: Windows Server-a (biohealth.local domeinua, DNS, DHCP) eta Ubuntu Server-a (Jitsi, CUPS, Samba, GLPI). Lab-ean IsardVDI-n egiten duguna bera da, baina hardware errealean.

### pve01: Dell PowerEdge T360

| Osagaia            | Zehaztapena                                     | Zergatik                                                                                              |
|--------------------|-------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| PUZ                | Intel Xeon 6325P, 4 nukleo, 3,5 GHz             | Zerbitzarietarako PUZa: ECC memoria onartzen du; 20 erabiltzaile eta 4–5 makina birtualentzat nahikoa |
| RAM                | 32 GB DDR5 ECC (1/4 zirrikitu, gehienez 128 GB) | ECCk memoria-akatsak zuzentzen ditu datuak hondatu aurretik; 3 zirrikitu libre                        |
| Biltegiratzea      | 480 GB SSD SATA + bigarren SSD bat (RAID 1)     | Disko bat hondatuz gero bestea jarraitzen du; datuak ez dira galtzen                                  |
| RAID kontroladorea | Dell PERC H755                                  | RAID hardware bidez, cachearekin; sistema eragileak ez du lanik egiten                                |
| Sarea              | 2 × 1 GbE (Broadcom 5720) + kudeaketa-ataka     | Bi kable switchera (agregazioa edo LAN/DMZ banatuta)                                                  |
| Kudeaketa          | iDRAC 9                                         | Zerbitzaria urrunetik piztu, itzali eta kontsola ikusi, sistema eragilea erori bada ere               |
| Elikatzea          | 700 W-ko iturri bat                             | SAIra konektatuta                                                                                     |
| Formatua           | Dorrea, 175 × 383 × 580 mm                      | Isila bulego batean; ez du 800 mm-ko rack armairurik behar                                            |
| Bermea             | 3 urte in situ                                  | Teknikaria hurrengo egunean etortzen da                                                               |

Oharra: 32 GB-rekin nahikoa da hasteko. Makina birtual gehiago behar badira, 32 GB gehiago gehitzea da hurrengo pausoa.

### Makina birtualak pve01-en

| VM                    | Sistema eragilea    | Zerbitzuak                            | IPa                       |
|-----------------------|---------------------|---------------------------------------|---------------------------|
| zerbitzariprintzipala | Windows Server 2025 | AD DS, DNS, DHCP, GPO, inprimagailuak | 192.168.10.1              |
| ubuntu-zerb           | Ubuntu Server 24.04 | Jitsi, CUPS, Samba, GLPI              | LAN-eko helbide finko bat |
| web (DMZ)             | Ubuntu Server 24.04 | WordPress (HTTPS)                     | pfSense-ren DMZ sarean    |

### CPDaren gainerako ekipoak

| Ekipoa                                    | Osagaiak                                           | Zertarako                                    | BEZ gabe              | BEZ barne  |
|-------------------------------------------|----------------------------------------------------|----------------------------------------------|-----------------------|------------|
| Dell PowerEdge T360 (pve01)               | Goiko taulan                                       | Makina birtualak                             | 3.476,00 €            | 4.205,96 € |
| Bigarren SSDa, 480 GB SATA (RAID 1)       | Dell Read Intensive, 3,5"-ko euskarria             | Diskoaren ispilua                            | 300,00 € (estimazioa) | 363,00 €   |
| Synology DS225+                           | Intel Celeron J4125, 2 GB RAM, 2 badia, 2,5 GbE    | Babeskopiak (Active Backup / Hyper Backup)   | 353,99 €              | 428,33 €   |
| 2 × Synology HAT3300 4 TB                 | 5.400 rpm, NAS-erako diskoak                       | RAID 1 NASean: 4 TB erabilgarri              | 355,30 €              | 429,92 €   |
| Protectli Vault VP2410                    | Celeron J4125, 4 × Intel 1 GbE, haizagailurik gabe | pfSense CE: WAN, LAN, DMZ, Wi-Fi gonbidatuak | 541,13 €              | 654,77 €   |
| APC Smart-UPS 1500 VA (SMT1500IC, dorrea) | 980 W, linea interaktiboa, sinu-uhin purua         | pve01, suebakia, switcha eta db01            | 806,99 €              | 976,46 €   |
| APC Smart-UPS 750 VA (SMT750IC)           | 500 W, linea interaktiboa                          | NASa, tailerrean                             | 431,99 €              | 522,71 €   |
| Lanberg horma-armairua 12U, 600 × 450     | Altzairua, beirazko atea giltzarekin               | Patch panela, switcha eta suebakia           | 110,66 €              | 133,90 €   |

**Zergatik dago NASa tailerrean eta ez CPDan?** CPDan sute edo ur-isuri bat gertatzen bada, zerbitzaria eta kopiak ez dira batera galtzen. 3-2-1 araua betetzeko, NASaren kopia zifratu bat hodeira ere igotzen da (hilabeteko kostua ez dago aurrekontuan).

**Zergatik dorre-SAIa eta ez rack-ekoa?** 1500 VA-ko rack SAIak 457 mm-ko sakonera du eta armairuak 450 mm; gainera, zerbitzaria dorrea da. Dorre-SAIa 293 € merkeagoa da.

## Sarea

Switch kudeagarri bakar batek konektatzen ditu ekipo guztiak, eta VLANekin banatzen ditu LANa, DMZa eta gonbidatuen Wi-Fia. Sarbide-puntuek kable beretik hartzen dute elektrizitatea (PoE), eta ez dute entxuferik behar.

| Ekipoa                   | Ezaugarriak                                             | Zergatik hau                                                                            | BEZ gabe                | BEZ barne  |
|--------------------------|---------------------------------------------------------|-----------------------------------------------------------------------------------------|-------------------------|------------|
| TP-Link Omada SG3452XP   | 48 × 1 GbE PoE+, 4 × 10G SFP+, L2+, 500 W PoE, 1U       | ~30 puntu + hazteko tartea; VLAN, ACL eta QoS; Omada kontroladorea doan                 | 579,03 €                | 700,63 €   |
| 2 × TP-Link Omada EAP650 | Wi-Fi 6 AX3000, PoE+, sabaian                           | Bata harreran/itxarongelan (gonbidatuak), bestea kontsulten korridorean (eramangarriak) | 243,90 €                | 295,12 €   |
| Cat6 kableatzea          | ~30 puntu, 24 portuko patch panela, apala, latiguilloak | Lanpostu bakoitzeko 1–2 puntu, inprimagailuak eta AP-ak                                 | 1.500,00 € (estimazioa) | 1.815,00 € |

| Sarea       | Helbideak                                          | Zer dago                                |
|-------------|----------------------------------------------------|-----------------------------------------|
| LAN         | 192.168.10.0/24, atebidea 192.168.10.254 (pfSense) | PCak, zerbitzariak, inprimagailuak      |
| DMZ         | pfSense-ren OPT1 interfazea                        | WordPress zerbitzaria                   |
| Gonbidatuak | VLAN bereizia, Internet bakarrik                   | Pazienteen Wi-Fia; LANera sarbiderik ez |

Switch merkeago bat (24 portukoa, PoE gabe) kontuan hartu dugu, baina 30 puntu betetzen ditu eta ez die AP-ei elektrizitaterik ematen. Diferentzia ~250 € da, eta ez du merezi.

## Inprimaketa eta periferikoak

Laser zuri-beltzeko inprimagailuak aukeratu ditugu, sare bidezkoak, toner bera (TN-3600) dutenak. Horrela, ordezko toner bakarra gorde behar da. Windows-etik eta Linux-etik (CUPS) erabiltzen dira, errubrikaren 4 proba gurutzatuetarako.

| Ekipoa                  | Non                                | Ezaugarriak                                                                                  | BEZ gabe | BEZ barne  |
|-------------------------|------------------------------------|----------------------------------------------------------------------------------------------|----------|------------|
| 2 × Brother MFC-L5710DW | Harrera, Administrazioa            | 4 en 1 (inprimatu, eskaneatu, kopiatu, faxa), 48 orri/min, bi aldeak, 50 orriko ADF, Gigabit | 978,16 € | 1.183,57 € |
| Brother HL-L5210DW      | Erizaintza / kontsulten korridorea | Inprimagailua bakarrik, 48 orri/min, bi aldeak                                               | 256,94 € | 310,90 €   |
| Brother QL-820NWBc      | Harrera                            | Etiketa termikoak (62 mm), gorria eta beltza; eskumuturrekoak eta laginen etiketak           | 153,55 € | 185,80 €   |

Teklatua eta sagua mini PCarekin datoz; webcamak eta entzungailuak Lanpostuak atalean daude. Kolorezko inprimagailurik ez dago: klinika batean ez da beharrezkoa, eta orri bakoitza garestiagoa da.

## Osagai bakoitzak nola funtzionatzen duen

| Osagaia          | Nola funtzionatzen du                                                                                                                    | Gure ekipoetan                                                                                      |
|------------------|------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| PUZa             | Programen aginduak exekutatzen ditu. Nukleo bakoitzak lan bat egin dezake aldi berean; hariek nukleo bakoitza bi lanetan erabiltzen dute | i5-14400T (PCak): 10 nukleo, 35 W. Xeon 6325P (zerbitzaria): 4 nukleo, ECC eta zerbitzari-funtzioak |
| RAM              | Irekita dauden programen datuak gordetzen ditu, PUZak azkar har ditzan. Itzaltzean hustu egiten da                                       | PCak: 16 GB DDR5. Zerbitzaria: 32 GB DDR5 **ECC**, bit okerrak detektatu eta zuzentzen dituena      |
| SSDa             | Sistema eragilea eta fitxategiak gordetzen ditu flash memorian, pieza mugikorrik gabe                                                    | NVMe (PCak): PCIe bidez, ~7 aldiz SATA baino azkarragoa. SATA (zerbitzaria): RAID 1ean bikoiztuta   |
| HDDa             | Plater biribil magnetikoak; merkea GB bakoitzeko, baina motelagoa                                                                        | NASean bakarrik, babeskopietarako (2 × 4 TB RAID 1)                                                 |
| RAID 1           | Bi diskotan gauza bera idazten da (ispilua). Bat hondatzen bada, besteak lanean jarraitzen du                                            | pve01 (PERC H755) eta NASa                                                                          |
| Plaka            | Osagai guztiak lotzen ditu eta energia eta datuak banatzen ditu                                                                          | Fabrikatzailearena, ekipoarekin batera; ez dago aparte erosi beharrik                               |
| TPM 2.0          | Gakoak gordetzen dituen txipa; BitLockerrek diskoa zifratzeko erabiltzen du                                                              | Ekipo guztietan: PCa lapurtzen badute, datuak ezin dira irakurri                                    |
| Txartel grafikoa | Pantailan agertzen dena kalkulatzen du                                                                                                   | Integratua (PUZaren barruan): 2 pantailarako nahikoa                                                |
| Sare-txartela    | Ekipoa sarera konektatzen du (Ethernet edo Wi-Fi)                                                                                        | 1 GbE PCetan; 2 × 1 GbE + iDRAC zerbitzarian                                                        |
| PoE              | Sare-kableak datuak eta elektrizitatea batera eramaten ditu                                                                              | Switchak AP-ak elikatzen ditu (gehienez 30 W portuko)                                               |
| Elikatze-iturria | 230 V-ko korrontea osagaiek behar duten tentsio baxura bihurtzen du                                                                      | PCak: kanpoko 90 W-ko egokigailua. Zerbitzaria: 700 W                                               |
| SAIa             | Bateria batek elektrizitatea ematen du argia joaten denean, eta tentsio-gorabeherak zuzentzen ditu (AVR)                                 | Linea interaktiboa: minutu batzuk zerbitzaria ondo itzaltzeko (PowerChute)                          |
| iDRAC / vPro     | Urruneko kudeaketa-txip bat, sistema eragiletik kanpo                                                                                    | Zerbitzaria edo PCa urrunetik piztu eta konpondu                                                    |
| Monitorea        | Irudia erakusten du; IPS panelak kolore onak ditu angelu guztietatik                                                                     | FHD (1920×1080) arrunta; QHD (2560×1440) Medikuntza eta Informatikan                                |

## Softwarea eta lizentziak

Ordainpeko lizentziak behar direnean bakarrik erabiltzen ditugu (Windows domeinua, errubrikak eskatzen duena). Gainerakoa software librea da, eta horrek 2.194,71 €-tan uzten ditu lizentziak BEZ gabe.

| Softwarea                     | Non                                 | Lizentzia                                                       | BEZ gabe      | BEZ barne     |
|-------------------------------|-------------------------------------|-----------------------------------------------------------------|---------------|---------------|
| Windows 11 Pro                | PC eta eramangarri guztiak          | OEM, ekipoarekin barne                                          | 0 €           | 0 €           |
| Windows Server 2025 Standard  | VM zerbitzariprintzipala            | 16 nukleo + 10 erabiltzaile-CAL (2 VM estaltzen ditu)           | 1.634,71 €    | 1.978,00 €    |
| Windows Server 2025 CAL       | 20 langileetatik gainerako 10ak     | 2 × 5 erabiltzaile-CAL                                          | 440,00 €      | 532,40 €      |
| Proxmox VE                    | pve01                               | Community harpidetza, 1 socket, urtekoa (eguneratze egonkorrak) | 120,00 €/urte | 145,20 €/urte |
| pfSense CE                    | Suebakia                            | Librea                                                          | 0 €           | 0 €           |
| Ubuntu Server 24.04           | Jitsi, CUPS, Samba, GLPI, WordPress | Librea                                                          | 0 €           | 0 €           |
| MariaDB eta MongoDB Community | db01                                | Librea                                                          | 0 €           | 0 €           |
| Synology DSM, Active Backup   | NASa                                | NASarekin barne                                                 | 0 €           | 0 €           |
| Microsoft Defender            | PCak                                | Windows 11 Pro-rekin barne                                      | 0 €           | 0 €           |

**Erabaki gabe:** ofimatika. LibreOffice (0 €) proposatzen dugu, Nextcloud-ekin, pazienteen datuak gure zerbitzarian geratzeko. Microsoft 365 aukeratuz gero, erabiltzaile bakoitzeko hilabeteko kuota bat gehitu beharko litzateke.

## Aurrekontu osoa

Guztira **32.623,37 € BEZ gabe** eta **39.474,28 € BEZ barne** (BEZa %21: 6.850,91 €). Diruaren erdia baino gehiago lanpostuetan eta eramangarrietan doa.

| Kategoria                                                      | BEZ gabe        | BEZ barne       | %       |
|----------------------------------------------------------------|-----------------|-----------------|---------|
| Lanpostuak (15 mini PC, 23 pantaila, webcam eta entzungailuak) | 14.983,02 €     | 18.129,45 €     | 45,9    |
| Zerbitzaria eta CPDa (pve01, NASa, suebakia, SAIak, armairua)  | 6.376,06 €      | 7.715,03 €      | 19,5    |
| Eramangarriak (4 ThinkPad T14)                                 | 5.358,00 €      | 6.483,18 €      | 16,4    |
| Sarea (switcha, 2 AP, kableatzea)                              | 2.322,93 €      | 2.810,75 €      | 7,1     |
| Lizentziak                                                     | 2.194,71 €      | 2.655,60 €      | 6,7     |
| Inprimaketa                                                    | 1.388,65 €      | 1.680,27 €      | 4,3     |
| **Guztira**                                                    | **32.623,37 €** | **39.474,28 €** | **100** |

Kostu errepikakorrak (urtero): Proxmox harpidetza 120 € + hodeiko kopia. Ez daude barne: instalazio-orduak, altzariak eta ofimatika Microsoft 365 aukeratuz gero. Estimazioak (1.800 €) instalatzailearen eskaintzarekin baieztatu behar dira.

## Egoitzaren planoa eta informatika tailerra

CPDa eta informatika tailerra eraikinaren muturrean daude, sarrera publikotik urrun eta elkarren ondoan. Pazienteak harreratik eta korridoretik bakarrik ibiltzen dira, eta ez dira inoiz zona teknikotik pasatzen.

<img width="1344" height="1074" alt="planoa" src="https://github.com/user-attachments/assets/08e29ecf-4242-4943-9597-8cde0f4968eb" />


*BioHealth egoitza · suposatutako planoa, 10 gela + korridorea*

**Tailerra** informatikarien lantokia da: ekipoak konpontzeko mahai antiestatikoa, Windows irudiak sortzeko M70q-a, ordezko piezak eta baja emandako ekipoen txokoa (birziklatze-politika). NASa hemen dago, CPDtik kanpo, sute batean kopiak ez galtzeko. **CPDa** gela itxia da, txartel eta giltzarekin: pve01, db01, rack armairua (switcha, patch panela, suebakia) eta 1500 VA-ko SAIa. Informatika sailak bakarrik du sarbidea; sarrera guztiak erregistratzen dira (segurtasun-planeko arauak).

## Taldearen zirriborroarekiko aldaketak eta hurrengo pausoak

*Biohealth HW.docx* zirriborroak oinarri ona zuen (sailak, osagaien azalpena, birziklatze-politika). Txosten honek mantendu egiten ditu, baina akats hauek zuzentzen ditu:

| Zirriborroan                                      | Arazoa                                                   | Hemen                                    |
|---------------------------------------------------|----------------------------------------------------------|------------------------------------------|
| MSI B550M plaka + "Intel i5 edo Ryzen 5"          | B550M AMDrena da bakarrik; Intelekin ez du funtzionatzen | Markako ekipoa: plaka bateragarria barne |
| ASRock B760M D4 + DDR5                            | D4 plakak DDR4 bakarrik onartzen du                      | DDR5, ekipoarekin batera                 |
| Iturria, kaxa eta Windows lizentzia prezio gabe   | Benetako kostua txikiagoa ageri zen                      | Guztia barne, lanpostuko 829,98 €        |
| Informatika: testuan 32 GB, taulan 16 GB          | Kontraesana                                              | ThinkPad 32 GB                           |
| Erizaintza: 1.190 €, baina lerroen batura 1.172 € | Batuketa okerra                                          | Zenbaki guztiak kodearekin kalkulatuta   |
| Zerbitzaririk, sarerik eta SAIrik ez              | Errubrikak CPDa eta aurrekontua eskatzen ditu            | 4–5 ataletan                             |

### Hurrengo pausoak

- [ ] Taldean berrikusi eta onartu (Gaizka, Alex, Garazi)

- [ ] Ekipoak GLPIn sartu inbentario gisa

- [ ] Ofimatika erabaki: LibreOffice edo Microsoft 365

- [ ] Txostena GitHubeko Hardwarea karpetara igo (Markdown)

- [ ] Planoa segurtasun-planean erabili (errubrikaren sarbide fisikoa)

## Iturriak

Prezioak 2026-10-13an kontsultatuta.

- [Lenovo ThinkCentre M70q Gen 5 — Bechtle España](https://www.bechtle.com/es/shop/product-family/pc-lenovo-thinkcentre-m70q-5-gen-tiny--5850--f)

- [M70q 12TD000GSP datu-orria — Icecat](https://icecat.ro/amp/p/vendorName/mpn/desc-121523236.html)

- [Dell Pro Plus monitoreak — Bechtle España](https://www.bechtle.com/es/shop/product-family/monitores-dell-pro-plus--4744--f)

- [Dell PowerEdge T360 — Bechtle España](https://www.bechtle.com/es/shop/servidores-dell-poweredge-t360--4993540--p)

- [APC Smart-UPS SMT — Bechtle España](https://www.bechtle.com/es/shop/product-family/sai-apc-smart-ups-smt--377--f)

- [Lenovo ThinkPad T14 Gen 6 — Bechtle](https://www.bechtle.com/de-en/finder/product-family/lenovo-thinkpad-t14-gen-6-ultrabooks--6765--f)

- [Synology DS225+ — Bechtle](https://www.bechtle.com/it-en/shop/synology-diskstation-ds225-plus-2-bay-nas--4925809--p)

- [Synology HAT3300 4 TB — Geeknetic](https://www.geeknetic.es/comparador-precios/synology-plus-series-hat3300-3-5-4tb-sata-3/comprar/)

- [Protectli Vault VP2410 — 3mdeb](https://shop.3mdeb.com/product-category/vaults)

- [TP-Link Omada SG3452XP — voelkner](https://www.voelkner.de/products/6145684/TP-LINK-JetStream-TL-SG3452XP-V2.6-Switch-L2-managed-48-x-10-100-1000-PoE-.html)

- [TP-Link Omada EAP650 — Onedirect](https://www.onedirect.de/tp-link/tp-link-omada-eap650-v1-26)

- [Lanberg 12U armairua — PCBox](https://www.pcbox.com/wf01-6412-10b-armario-lanberg-mural-rack-19--12u-600x450-flat-pack-v2-negro/p)

- [Brother MFC-L5710DW — Dateks](https://www.dateks.lv/en/cenas/tintes-un-lazera-printeri/1005152-brother-mfc-l5710dw?vat=0)

- [Brother HL-L5210DW — Inforeco](https://www.inforeco.com/en/p/HLL5210DW/brother-hl-l5210dw-mono-laser-printer)

- [Brother QL-820NWBc — Datafox](https://pood.datafox.ee/brother-ql-820nwbc-ql820nwbc-etikettendrucker)

- [Logitech Brio 100 — Industry-Electronics](https://industry-electronics.de/logitech/960-001585-brio-100-webcam-grafit-lieske_2179508.htm)

- [Jabra Evolve2 30 SE — Shopro](https://www.shopro.lt/444963-jabra-evolve2-30-se-stereo-uc-usb-c-en)

- [Windows Server 2025 Standard — Microsoft Store España](https://www.microsoft.com/es-es/d/windows-server-2025-standard/dg7gmgf0wzrw)

- [Windows Server 2025 5 erabiltzaile-CAL — SHI](https://eu.shi.com/product/49595235/Microsoft-Windows-Server-2025)

- [Proxmox VE harpidetzak — proxmox.com](https://www.proxmox.com/proxmox-ve/pricing)
