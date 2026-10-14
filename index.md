---
title: Hasiera
nav_order: 1
---

# BioHealth – Erronka 1

**BioHealth** (fikziozkoa): kontsulta medikoak eta telekontsulta, ~20 langile, zentro bat.
Pazienteen osasun-datuak kudeatzen ditugu (DBEO 9. art., kategoria berezia), beraz **segurtasuna, pribatutasuna eta erabilgarritasuna** dira erabaki guztien ardatza.

- **Domeinua:** `biohealth.local` (NetBIOS: `BIOHEALTH`)
- **Ingurunea:** IsardVDI (makina birtualak)
- **Taldea:** Gaizka · Alex · Garazi · Suhar

## Dokumentazioa ikasgaika

| Ikasgaia | Edukia | Egoera |
|---|---|---|
| [**Orokorra**](docs/00-orokorra/index.md) | Proposamena vs. inplementazioa · Plangintza | 🔄 |
| [**SEG** – Segurtasuna](docs/SEG-segurtasuna/index.md) | Sarearen diseinua (WAN/LAN/DMZ) · pfSense (arauak, IDS, VPN) · Segurtasun-plana (MAGERIT) · Ziurtagiriak | 🔄 |
| [**SEA** – Sistema eragileak](docs/SEA-sistema-eragileak/index.md) | Active Directory (OU, erabiltzaileak, GPO, prozesuak) ✅ · Inprimaketa (Windows ↔ CUPS) | 🔄 |
| [**SZI** – Sareko zerbitzuak](docs/SZI-sareko-zerbitzuak/index.md) | DNS ✅ · DHCP · Jitsi Meet (audioa eta bideoa) | 🔄 |
| [**DBKSA** – Datu-baseak](docs/DBKSA-datu-baseak/index.md) | MariaDB + MongoDB (instalazioa, ustiapena, erabiltzaileak) | 🔄 |
| [**WAE** – Web aplikazioak](docs/WAE-web-aplikazioak/index.md) | WordPress ✅ · GLPI (kontenedorean) | 🔄 |
| [**SB** – Sistema banatuak](docs/SB-sistema-banatuak/index.md) | Birtualizazioa, kontenedorea (GLPI Docker) eta HA diseinua | ✅ |
| [**HACK** – Hacking etikoa](docs/HACK-hacking-etikoa/index.md) | Pentestinga (faseak, ahuleziak, Metasploitable) | ✅ |
| [**IRAU** – Iraunkortasuna](docs/IRAU-iraunkortasuna/index.md) | Jasangarritasun-plana (GJH, interes-taldeak, IGG, GRI) | ✅ |
| [**HW** – Hardwarea](docs/HW-hardwarea/index.md) | Hardwarea eta lizentziak · LAP plana | ✅ |

✅ eginda · 🔄 martxan · ⏳ egiteko

## Nola lan egiten dugu

Zerbitzu bakoitza eskema berarekin dokumentatzen da:

1. **Aukerak** (2–4) alde on eta txarrekin
2. **Erabakia** justifikatuta (kostua, segurtasuna, HW eskakizunak)
3. **Datuak**: izena, IP, portuak eta protokoloak
4. **Inplementazioa** pausoz pauso, pantaila-argazkiekin
5. **Probak**: baimendutakoa ✅ eta debekatutakoa ❌
6. **Arazoak eta logak**: aurkitutako erroreak eta nola konpondu diren
7. **Plangintza**: GitHub-eko zeregina itxi

Pantaila-argazkiak `irudiak/<IKASGAIA>/` karpetan doaz (adib. `irudiak/SZI/dns-zonak.png`).
