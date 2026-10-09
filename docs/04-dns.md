---
title: DNS
---

[← Hasiera](../index.md)

# 4. DNS

## 4.1 Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **Windows DNS (AD-n integratua)** | ADk behar du; DHCPrekin DNS dinamikoa; replikazio automatikoa | Windows-en menpe |
| BIND9 bakarrik | Librea, estandarra | ADrekin integratzeko lan handiagoa |
| pfSense DNS Resolver | Zerbitzu bat gutxiago | Domeinuko SRV erregistroak ez ditu kudeatzen |

**Erabakia: Windows DNS AD-n integratua.**

### Kanpoko izenak ebazteko

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| pfSense-ra birbidali | Irteera-puntu bakarra | Proposamenean baztertua |
| **9.9.9.9 + 1.1.1.1 birbidaltzaileak** | Fidagarriak; Quad9-k malware domeinuak blokeatzen ditu (osasun-datuak) | Kanpoko zerbitzuen menpe |
| Erro-iradokizunak soilik | Inoren menpe ez | Motelagoa |

**Erabakia: 9.9.9.9 eta 1.1.1.1.**

## 4.2 Zonak

| Zona | Mota | Oharrak |
|---|---|---|
| `biohealth.local` | Zuzena, nagusia, AD-n integratua | Domeinua sortzean automatikoki |
| `10.168.192.in-addr.arpa` | Alderantzizkoa, AD-n integratua | LAN |
| `20.168.192.in-addr.arpa` | Alderantzizkoa, AD-n integratua | DMZ |

Eguneraketa dinamikoak: **seguruak soilik**.

## 4.3 Erregistroak

| Izena | Mota | Balioa | PTR |
|---|---|---|---|
| zerbitzariprintzipala | A | 192.168.10.1 | ✅ |
| pfsense | A | 192.168.10.254 | ✅ |
| db01 | A | 192.168.10.3 | ✅ |
| www | A | 192.168.20.10 | ✅ |
| meet | A | 192.168.20.11 | ✅ |
| web | CNAME | www.biohealth.local | — |
| glpi | CNAME | www.biohealth.local | — |
| BEZ-WIN01 | A (dinamikoa) | DHCP | ✅ (DHCPk) |

`web` eta `glpi` CNAME dira: zerbitzari batek (www) izen bat baino gehiago erantzuten ditu Apache-ren VirtualHost-en bidez.

## 4.4 Pausoak (DNS Kudeatzailea)

1. Zerbitzaria → *Propietateak* → *Birbidaltzaileak* → 9.9.9.9 eta 1.1.1.1
2. *Alderantzizko bilaketa-zonak* → *Zona berria* → Nagusia, AD-n gordeta → domeinuko DNS guztiei → IPv4 → `192.168.10` (eta gero `192.168.20`) → eguneraketa dinamiko seguruak
3. `biohealth.local` → *Host berria (A)* → «Sortu PTR erregistroa» markatuta
4. *Alias berria (CNAME)* → `web` eta `glpi`

## 4.5 Probak (PowerShell)

```powershell
Get-DnsServerForwarder
Get-DnsServerZone
Get-DnsServerResourceRecord -ZoneName "biohealth.local"
Resolve-DnsName www.biohealth.local        # ✅ 192.168.20.10
Resolve-DnsName 192.168.20.10              # ✅ PTR → www
Resolve-DnsName glpi.biohealth.local       # ✅ CNAME → www
Resolve-DnsName google.com                 # ✅ birbidaltzaileak
Resolve-DnsName ezdago.biohealth.local     # ❌ DNS name does not exist
nslookup -type=SRV _ldap._tcp.biohealth.local   # ✅ ADren SRV erregistroak
```

## 4.6 Arazoak eta logak

*Gertaeren ikustailea → Aplikazioen eta zerbitzuen erregistroak → DNS Server*

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| | | |
