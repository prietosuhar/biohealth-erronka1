---
title: Suebakia – pfSense
---

[← Hasiera](../index.md)

# 2. Suebakia – pfSense

## 2.1 Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **pfSense CE** | Doakoa, web GUI, stateful, Suricata eta OpenVPN/WireGuard paketeak; erronkako baliabidea | FreeBSD (Linux ez den sistema) |
| OPNsense | pfSense-ren antzekoa, interfaze modernoa | Klasean ez da landu |
| UFW / nftables | Arina | Zerbitzari bakarra babesten du, ez sare osoa |
| FortiGate | Profesionala | Ordainpekoa |

**Erabakia: pfSense CE** – kostua 0 €, sare osoa babesten du eta IDS + VPN gehitu daitezke makina berean.

## 2.2 Interfazeak

| Interfazea | Gailua | IP | Oharrak |
|---|---|---|---|
| WAN | vtnet0 | DHCP (IsardVDI Default) | Internetera irteera |
| LAN | vtnet1 | 192.168.10.254/24 | pfSense-ren DHCPa **desgaituta** (Windows Server-ek ematen du) |
| DMZ (OPT1) | vtnet2 | 192.168.20.254/24 | ⏳ |

Egindakoa (✅):
1. WAN = Default (DHCP), LAN = Pertsonala1 192.168.10.254/24
2. LAN-eko DHCPa desgaituta
3. Konektibitate-proba: `ping 8.8.8.8` OK

## 2.3 Arauak

### DMZ interfazea (goitik behera aplikatzen dira)

| # | Jatorria | Helburua | Portua | Ekintza | Arrazoia |
|---|---|---|---|---|---|
| 1 | www (20.10) | db01 (10.3) | 3306/TCP | ✅ Pasa | WordPress-ek bere datu-basea behar du |
| 2 | DMZ net | DC (10.1) | 53 TCP/UDP | ✅ Pasa | Domeinuko izenak ebatzi |
| 3 | meet (20.11) | DC (10.1) | 636/TCP | ✅ Pasa | LDAPS autentifikaziorako (hobekuntza) |
| 4 | DMZ net | LAN net | edozein | ❌ Blokeatu + log | DMZ erasotuz gero, LANera ez iristeko |
| 5 | DMZ net | edozein | 80, 443/TCP | ✅ Pasa | Eguneraketak (`apt`) |

### WAN (NAT – port forward)

| Kanpoko portua | Barneko helburua | Arrazoia |
|---|---|---|
| 443/TCP | www 192.168.20.10 | Web korporatiboa |
| 443/TCP (beste IP/portu bat) | meet 192.168.20.11 | Telekontsulta |
| 10000/UDP | meet 192.168.20.11 | Jitsi audio/bideoa (SRTP) |

> IsardVDIn ezin da Internetetik benetako proba egin; NATa konfiguratu eta argazkia ateratzen da, muga hori azalduz.

## 2.4 IDS – Suricata ⏳

*(aukerak · erabakia · instalazioa · proba: `nmap` eskaneatze bat detektatzen du)*

## 2.5 VPN – urruneko sarbidea ⏳

*(aukerak: OpenVPN / WireGuard / IPsec · erabakia · konfigurazioa · proba)*

## 2.6 Probak

| Proba | Nondik | Espero dena |
|---|---|---|
| `nc -zv 192.168.10.3 3306` | www | ✅ (1. araua) |
| `ping 192.168.10.1` | www | ❌ (4. araua) |
| `https://meet.biohealth.local` | BEZ-WIN01 | ✅ |
| *Status → System Logs → Firewall* | pfSense | Blokeatutako ping-a ageri da |

## 2.7 Arazoak eta logak

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| | | |
