---
title: Proposamena vs. inplementazioa
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Proposamena vs. inplementazioa

Proposamena 2026/09/30ean aurkeztu genuen. Inplementatzean aldaketa batzuk egin behar izan ditugu. Hemen jasotzen dira, bakoitza bere arrazoiarekin: proiektu erreal batean bezala, desbideratze guztiak dokumentatu eta justifikatzen ditugu.

| Elementua | Proposamenean | Inplementazioan | Arrazoia |
|---|---|---|---|
| Windows Server | 2025 | **2019** | IsardVDIn eskuragarri zegoen ISOa; AD DS, DNS, DHCP eta inprimaketa-funtzioak berdinak dira erronkarako |
| pfSense | CE 2.9 | **2.7.2** | IsardVDIko txantiloia / ISOa |
| Suebakiaren LAN IPa | 192.168.10.1 | **192.168.10.254** | Atebidea tartearen azken helbidean jarri dugu; .1 zerbitzari nagusiarentzat |
| Domeinu-kontrolatzailea | dc01 · 192.168.10.10 | **zerbitzariprintzipala** · **192.168.10.1** | Taldearen dokumentazioarekin bat etortzeko |
| NetBIOS izena | — | **ZERBITZARIPRINT** | NetBIOS izenek 15 karaktere gehienez; Windowsek automatikoki moztu zuen |
| DMZ atebidea | 192.168.20.1 | **192.168.20.254** | LAN-eko irizpide bera (atebidea = .254) |
| db01 | Windows 11 Pro · .10.30 | Ubuntu Server 22.04 · **192.168.10.3** | *(taldearekin berretsi)* |
| DNS birbidaltzaileak | 9.9.9.9 + 1.1.1.1 | **pfSense (192.168.10.254)** | Kanpoko DNS trafiko guztia suebakitik pasatzeko eta han kontrolatzeko; pfSense-k Quad9-ra birbidal dezake |
| www | DMZ · 192.168.20.10 | **DMZ · 192.168.20.10** | Taldearen dokumentuan LAN-ean zegoen (.10.4); errubrikak LAN/WAN/DMZ diseinua eskatzen du eta Internetera irekitako zerbitzariak DMZn egon behar dute |
| meet (Jitsi) | DMZ · 192.168.20.11 | **DMZ · 192.168.20.11** | Proposamenarekin bat |
| Proxmox / Nextcloud (LXC) | Bai | *(erabakitzeko)* | Errubrikak (SB IE3) zerbitzu bat kontenedore batean eskatzen du |
| Bezeroa | pc-* | **BEZ-WIN01** (Windows 11, DHCP) | — |

> Taula hau eguneratzen joango gara aldaketa berri bat dagoen bakoitzean.
