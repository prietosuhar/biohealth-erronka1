---
title: Plangintza eta jarraipena
parent: "Orokorra"
nav_order: 2
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
| 2026-10-10 | kantonsh | DMZ (OPT1, aliasak, 6 arau, logak, NTP), www DMZn (netplan), DNS DMZ (20.168.192 zona, www, meet) | db01, WordPress |
| 2026-10-10 | kantonsh | db01 (LAN): netplan, MariaDB 10.3 instalatu eta segurtatu, bind-address, wordpress/glpi datu-baseak eta erabiltzaileak, ufw 3306, www-tiko probak; 3 errore interpretatuta (1064, 2002, 1044) | MariaDB ustiapena, WordPress |
| 2026-10-11 | kantonsh | www: Apache 2.4 + PHP 7.4 + WordPress (scripta GitHub-etik), ufw 80/443, web-instalatzailea (bioadmin) | WordPress erabiltzaileak, txantiloiak, CSS, HTTPS; GLPI |
| 2026-10-12 | kantonsh | WordPress: `harrera1` (Editor) + probak; 3 txantiloi konparatuta → Astra; CSS korporatiboa + logoa eta ikonoa; HTTPS (ziurtagiri autosinatua, 80→443); `DISALLOW_FILE_EDIT` | GLPI (Docker); MariaDB ustiapena; DHCP aurreratua |
| 2026-10-13 | kantonsh | Inprimaketa Windows Server-en: INPR-HARRERA, baimenak taldeka, BEZ-WIN01-etik proba; 0x709 errorea GPO-Imprimaketa-RPC bidez konponduta; NTFS baimenak; CUPS scripta db01-erako | CUPS probak |
| 2026-10-13 | Alex | GLPI: instalazioa, LDAP (AD), rolak, inbentarioa eta 2 tiket; hardware-txostenaren eguneraketa | GLPI inbentarioa |
| 2026-10-13 | Garazi | Jitsi: instalazioa eta lehen argazkiak | Audioa/bideoa |
| 2026-10-13 | Gaizka | Hardware-dokumentazioa (lanpostuak) eta fitxategiak igo | — |
| 2026-10-14 | kantonsh | GitHub Pages: Cayman → Just the Docs (alboko menua ikasgaika, bilatzailea, «Editatu GitHub-en»); hiru orriri goiburua jarri; `[cite]` hondarrak kendu | CUPS probak, edukiontzia/HA |
| 2026-10-14 | Alex | CUPS proba gurutzatuak (argazkiak), OpenVPN wizard-a, DHCP erreserba, Jitsi 2 ekipo, MongoDB argazkiak, txostenak WordPress-en, ziurtagiriak | IDS, VPN proba |
| 2026-10-14 | kantonsh | Berrikuspena errubrikaren aurka; GLPI-ko pasahitz argia kendu; IDS Suricata eta VPN atalak; SB (VM + kontenedorea + HA diseinua); Jitsi IE7/IE8; MariaDB ustiapena + MongoDB; MAGERIT; LAP plana; IGG/GRI; IP koherentzia | Laborategiko argazkiak (IDS, VPN, docker, mediku1) |

## Aldaketak plangintzan

| Data | Aldaketa | Arrazoia |
|---|---|---|
| 2026-10-09 | DMZ gehitu (pfSense OPT1); www eta meet DMZra | Errubrikak LAN/WAN/DMZ diseinua eskatzen du |
| 2026-10-09 | IDS (Suricata) eta VPN gehitu | Errubrikan ageri dira (SEG RA2–RA3) |
| 2026-10-14 | Dokumentazio-webgunea Just the Docs gaira aldatu | Nabigazioa eta bilaketa aurkezpenerako; ikus [GitHub Pages](github-pages.md) |
| 2026-10-14 | GLPI kontenedorera (Docker, www) eta MariaDB db01-era | Errubrikak (SB) zerbitzu bat kontenedorean eskatzen du; DB bakarra LANean |
| 2026-10-14 | HA: 3 nodo → 2 nodo + QDevice | Quorum bera kostu txikiagoarekin (ikus [SB](../SB-sistema-banatuak/birtualizazioa.md)) |
| 2026-10-14 | Laborategiko pasahitz partekatua aldatu (domeinua, pfSense, MariaDB, GLPI) | Biltegi publikoan argitaratuta egon zen (`glpi.md`, Git historia) |
