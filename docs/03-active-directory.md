---
title: Active Directory
---

[← Hasiera](../index.md)

# 3. Active Directory

## 3.1 Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **Windows Server + AD DS** | Erronkak Windows domeinua eskatzen du; AD DS, DNS, DHCP eta inprimaketa zerbitzari berean; GPOak | Lizentzia ordainpekoa |
| Samba 4 AD DC | Doakoa | GPO kudeaketa mugatuagoa; konplexuagoa |
| FreeIPA / OpenLDAP | Doakoa, Linux | Ez ditu Windows bezeroak GPOekin kudeatzen |
| Microsoft Entra ID | Hodeian | Osasun-datuak kanpoan; ez da instalatzen |

**Erabakia: Windows Server 2019 + AD DS** (ikus [proposamena vs. inplementazioa](00-proposamena-vs-inplementazioa.md)).

## 3.2 Zerbitzaria

| Datua | Balioa |
|---|---|
| Host-izena | `zerbitzariprintzipala` (NetBIOS: `ZERBITZARIPRINT`, 15 karaktereko muga) |
| IP | 192.168.10.1/24 · atebidea 192.168.10.254 · DNS 127.0.0.1 |
| Rolak | AD DS, DNS, DHCP, Inprimaketa eta dokumentu zerbitzuak |
| Basoa / domeinua | `biohealth.local` (baso berria) · NetBIOS `BIOHEALTH` |
| Administrari-kontua | `BIOHEALTH\Administrador` (pasahitza ez da hemen jasotzen) |

## 3.3 OU egitura

```
biohealth.local
└── Departamentuak
    ├── Administrariak   → admin1, admin2, admin3        · taldea: administrariak
    ├── Erizaintza       → erizain1, erizain2, erizain3  · taldea: erizaintza
    ├── Harrera          → harrera1, harrera2, harrera3  · taldea: harrera
    ├── Informatika      → informatika1–3                · taldea: informatika
    └── Medikuntza       → mediku1, mediku2, mediku3     · taldea: medikuntza
```

**Zergatik egitura hau:** OU bat sail bakoitzeko GPOak sailka aplikatzeko; talde bat sail bakoitzeko baimenak (inprimagailuak, karpetak) taldeka emateko, ez erabiltzaileka.

## 3.4 GPOak ⏳

| GPO | Non lotuta | 2 arau gutxienez | Zergatik |
|---|---|---|---|
| Erabiltzaile askorentzat | Departamentuak | *(adib. pasahitz-politika, pantaila-blokeoa 5 min)* | |
| Talde konkretu batentzat | *(adib. Harrera)* | *(adib. Kontrol-panela eta CMD debekatuta)* | |

## 3.5 Bezeroa domeinuan ⏳

- [ ] BEZ-WIN01-en IPa zerbitzariaren tartean (`ipconfig /all`)
- [ ] DNS = 192.168.10.1
- [ ] Domeinura batu eta domeinuko erabiltzaile batekin saioa hasi
- [ ] `gpresult /r` → GPOak aplikatuta

## 3.6 Zerbitzuen kudeaketa eta prozesuak ⏳

- [ ] AD zerbitzuak (`NTDS`, `DNS`, `Netlogon`, `KDC`) gelditu / abiarazi / berrabiarazi eta egoera egiaztatu (`services.msc` eta `Get-Service`)
- [ ] Prozesuak: Task Manager / Process Explorer (grafikoa) eta `Get-Process`, `Stop-Process`, `tasklist`, `taskkill` (komandoak)

## 3.7 Arazoak eta logak

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| NetBIOS izena moztuta | 15 karaktereko muga | Onartu eta dokumentatu |
