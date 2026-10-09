---
title: Hasiera
---

# BioHealth – Erronka 1

**BioHealth** (fikziozkoa): kontsulta medikoak eta telekontsulta, ~20 langile, zentro bat.
Pazienteen osasun-datuak kudeatzen ditugu (DBEO 9. art., kategoria berezia), beraz **segurtasuna, pribatutasuna eta erabilgarritasuna** dira erabaki guztien ardatza.

- **Domeinua:** `biohealth.local` (NetBIOS: `BIOHEALTH`)
- **Ingurunea:** IsardVDI (makina birtualak)
- **Taldea:** [Kide 1] · [Kide 2] · [Kide 3] · kantonsh

## Nola lan egiten dugu

Zerbitzu bakoitza eskema berarekin dokumentatzen da:

1. **Aukerak** (2–4) alde on eta txarrekin
2. **Erabakia** justifikatuta (kostua, segurtasuna, HW eskakizunak)
3. **Datuak**: izena, IP, portuak eta protokoloak
4. **Inplementazioa** pausoz pauso, pantaila-argazkiekin
5. **Probak**: baimendutakoa ✅ eta debekatutakoa ❌
6. **Arazoak eta logak**: aurkitutako erroreak eta nola konpondu diren
7. **Plangintza**: GitHub-eko zeregina itxi

## Dokumentazioa

| # | Atala | Egoera |
|---|---|---|
| 0 | [Proposamena vs. inplementazioa](docs/00-proposamena-vs-inplementazioa.md) | 🔄 |
| 1 | [Sarearen diseinua (WAN · LAN · DMZ)](docs/01-sarea.md) | 🔄 |
| 2 | [Suebakia – pfSense (arauak, IDS, VPN)](docs/02-pfsense.md) | 🔄 |
| 3 | [Active Directory (OU, erabiltzaileak, taldeak, GPO)](docs/03-active-directory.md) | 🔄 |
| 4 | [DNS](docs/04-dns.md) | ⏳ |
| 5 | [DHCP](docs/05-dhcp.md) | ⏳ |
| 6 | [Inprimaketa (Windows ↔ Linux)](docs/06-inprimaketa.md) | ⏳ |
| 7 | [Datu-baseak (MariaDB + MongoDB)](docs/07-datu-baseak.md) | ⏳ |
| 8 | [WordPress](docs/08-wordpress.md) | ⏳ |
| 9 | [GLPI](docs/09-glpi.md) | ⏳ |
| 10 | [Bideokonferentzia eta audioa – Jitsi Meet](docs/10-jitsi.md) | ⏳ |
| 11 | [Birtualizazioa eta erabilgarritasun handia](docs/11-birtualizazioa.md) | ⏳ |
| 12 | [Segurtasun-plana (fisikoa, pasahitzak, kontingentzia)](docs/12-segurtasun-plana.md) | ⏳ |
| 13 | [Hacking etikoa](docs/13-hacking.md) | ⏳ |
| 14 | [Jasangarritasun-plana](docs/14-jasangarritasuna.md) | ⏳ |
| 15 | [Hardwarea eta lizentziak](docs/15-hardwarea.md) | ⏳ |
| — | [Plangintza eta jarraipena](docs/plangintza.md) | 🔄 |

✅ eginda · 🔄 martxan · ⏳ egiteko
