---
title: Plangintza eta jarraipena
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Plangintza eta jarraipena

Plangintza GitHub-eko **Issues / Projects** taulan egiten da (zeregin bat pauso bakoitzeko). Orri honetan eguneroko laburpena jasotzen da.

## Kronograma

| Data | Fasea |
|---|---|
| Ira 30 – Urr 1 | Proposamena aurkeztu, feedbacka |
| Urr 2 – 8 | Oinarrizko azpiegitura: pfSense, domeinu-kontrolatzailea, db01, GitHub |
| Urr 9 – 13 | Zerbitzuak eta planak: DNS, DHCP, GPO, inprimaketa, Jitsi, WordPress, GLPI, txostenak |
| Urr 14 | Aurkezpena prestatu |
| Urr 15 | Azken aurkezpena |

## Eguneroko erregistroa

| Data | Nork | Egindakoa | Hurrengoa |
|---|---|---|---|
| 2026-10-0x | kantonsh | pfSense (WAN/LAN), Windows Server 2019, AD DS + DNS + DHCP rolak, `biohealth.local` basoa | DNS zonak |
| 2026-10-08 | kantonsh | BEZ-WIN01 sortuta (DHCP) | Domeinura batu |
| 2026-10-09 | kantonsh | Errubrika aztertuta; GitHub biltegia eta Pages sortuta; BEZ-WIN01 domeinuan (mediku1); DNS LAN amaituta (birbidaltzailea, zonak, erregistroak, probak) | OUak/GPOak, DMZ |
| 2026-10-09 | kantonsh | GPOak: Panel_Blokeatu osatuta (CMD + informatika iragazkia), GPO-Harrera sortuta; probak mediku1, infor1 eta harrera1-ekin | AD zerbitzuak eta prozesuak, DMZ |
| 2026-10-10 | kantonsh | AD zerbitzuak (gelditu/abiarazi/berrabiarazi, GUI + PowerShell) eta prozesuak (Task Manager, resmon, PowerShell, CMD) | DMZ, db01 |

## Aldaketak plangintzan

| Data | Aldaketa | Arrazoia |
|---|---|---|
| 2026-10-09 | DMZ gehitu (pfSense OPT1); www eta meet DMZra | Errubrikak LAN/WAN/DMZ diseinua eskatzen du |
| 2026-10-09 | IDS (Suricata) eta VPN gehitu | Errubrikan ageri dira (SEG RA2–RA3) |
