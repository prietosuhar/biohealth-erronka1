---
title: Active Directory
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Active Directory

## Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **Windows Server + AD DS** | Erronkak Windows domeinua eskatzen du; AD DS, DNS, DHCP eta inprimaketa zerbitzari berean; GPOak | Lizentzia ordainpekoa |
| Samba 4 AD DC | Doakoa | GPO kudeaketa mugatuagoa; konplexuagoa |
| FreeIPA / OpenLDAP | Doakoa, Linux | Ez ditu Windows bezeroak GPOekin kudeatzen |
| Microsoft Entra ID | Hodeian | Osasun-datuak kanpoan; ez da instalatzen |

**Erabakia: Windows Server 2019 + AD DS** (ikus [proposamena vs. inplementazioa](../00-orokorra/proposamena-vs-inplementazioa.md)).

## Zerbitzaria

| Datua | Balioa |
|---|---|
| Host-izena | `zerbitzariprintzipala` (NetBIOS: `ZERBITZARIPRINT`, 15 karaktereko muga) |
| IP | 192.168.10.1/24 · atebidea 192.168.10.254 · DNS 127.0.0.1 |
| Rolak | AD DS, DNS, DHCP, Inprimaketa eta dokumentu zerbitzuak |
| Basoa / domeinua | `biohealth.local` (baso berria) · NetBIOS `BIOHEALTH` |
| Administrari-kontua | `BIOHEALTH\Administrador` (pasahitza ez da hemen jasotzen) |

## OU egitura

```
biohealth.local
└── Departamentuak
    ├── Administrariak   → admin1, admin2, admin3        · taldea: administrariak
    ├── Erizaintza       → erizain1, erizain2, erizain3  · taldea: erizaintza
    ├── Harrera          → harrera1, harrera2, harrera3  · taldea: harrera
    ├── Informatika      → informatika1–3                · taldea: informatika
    └── Medikuntza       → mediku1, mediku2, mediku3     · taldea: medikuntza
```

![OU egitura: Departamentuak](../../irudiak/SEA/ad-ou-departamentuak.png)
*Irudia: `Departamentuak` OUaren barruan sail bakoitzeko OU bat: Administrariak, Erizaintza, Harrera, Informatika eta Medikuntza. ✅*

![Administrariak OUaren edukia](../../irudiak/SEA/ad-ou-administrariak.png)
*Irudia: `Administrariak` OUa: Admin1, Admin2 eta Admin3 erabiltzaileak eta `administrariak` segurtasun-taldea. Gainerako OUek egitura bera dute (3 erabiltzaile + taldea). ✅*

**Zergatik egitura hau:** OU bat sail bakoitzeko GPOak sailka aplikatzeko; talde bat sail bakoitzeko baimenak (inprimagailuak, karpetak) taldeka emateko, ez erabiltzaileka.

## GPOak ⏳

| GPO | Non lotuta | 2 arau gutxienez | Zergatik |
|---|---|---|---|
| Erabiltzaile askorentzat | Departamentuak | *(adib. pasahitz-politika, pantaila-blokeoa 5 min)* | |
| Talde konkretu batentzat | *(adib. Harrera)* | *(adib. Kontrol-panela eta CMD debekatuta)* | |

## Bezeroa domeinuan 🔄

| Datua | Balioa |
|---|---|
| Ekipoa | BEZ-WIN01 · Windows 11 Pro |
| IP | 192.168.10.102 (DHCP, zerbitzariaren tartean) — ikus [DHCP](../SZI-sareko-zerbitzuak/dhcp.md) |
| DNS | 192.168.10.1 (domeinu-kontrolatzailea) |
| Kontu lokala | `uni` (administratzaile lokala) |

**Pausoak:** `sysdm.cpl` → *Aldatu* → Domeinua: `biohealth.local` → domeinuko administratzaile baten kredentzialak → berrabiarazi.

- [x] BEZ-WIN01-en IPa zerbitzariaren tartean
- [x] DNS = 192.168.10.1
- [x] Domeinura batuta eta domeinuko erabiltzaile batekin (`mediku1`) saioa hasita
- [ ] `gpresult /r` → GPOak aplikatuta

![BEZ-WIN01 domeinuan, mediku1 erabiltzailearekin](../../irudiak/SEA/bezeroa-domeinuan-cmd.png)
*Irudia: Medikuntza saileko `mediku1` erabiltzaileak BEZ-WIN01-en saioa hasi du. `whoami` → `biohealth\mediku1`, `hostname` → `BEZ-WIN01` eta `systeminfo` → `Dominio: biohealth.local`. Honek erakusten du bezeroa domeinuan dagoela eta direktorio-zerbitzua erabiltzaileak zentralizatuki egiaztatzeko erabiltzen dela. ✅*

## Zerbitzuen kudeaketa eta prozesuak ⏳

- [ ] AD zerbitzuak (`NTDS`, `DNS`, `Netlogon`, `KDC`) gelditu / abiarazi / berrabiarazi eta egoera egiaztatu (`services.msc` eta `Get-Service`)
- [ ] Prozesuak: Task Manager / Process Explorer (grafikoa) eta `Get-Process`, `Stop-Process`, `tasklist`, `taskkill` (komandoak)

## Arazoak eta logak

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| NetBIOS izena moztuta | 15 karaktereko muga | Onartu eta dokumentatu |
