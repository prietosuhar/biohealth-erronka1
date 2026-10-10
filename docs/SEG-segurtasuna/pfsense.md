---
title: Suebakia – pfSense
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Suebakia – pfSense

## Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **pfSense CE** | Doakoa, web GUI, stateful, Suricata eta OpenVPN/WireGuard paketeak; erronkako baliabidea | FreeBSD (Linux ez den sistema) |
| OPNsense | pfSense-ren antzekoa, interfaze modernoa | Klasean ez da landu |
| UFW / nftables | Arina | Zerbitzari bakarra babesten du, ez sare osoa |
| FortiGate | Profesionala | Ordainpekoa |

**Erabakia: pfSense CE** – kostua 0 €, sare osoa babesten du eta IDS + VPN gehitu daitezke makina berean.

## Interfazeak

| Interfazea | Gailua | IP | Oharrak |
|---|---|---|---|
| WAN | vtnet0 | DHCP (IsardVDI Default) | Internetera irteera |
| LAN | vtnet1 | 192.168.10.254/24 | pfSense-ren DHCPa **desgaituta** (Windows Server-ek ematen du) |
| DMZ (OPT1) | vtnet2 (Pertsonala2) | 192.168.20.254/24 | DHCPrik gabe: DMZko zerbitzariek IP finkoa dute ✅ |

Egindakoa:
1. WAN = Default (DHCP), LAN = Pertsonala1 192.168.10.254/24 ✅
2. LAN-eko DHCPa desgaituta ✅
3. Konektibitate-proba: `ping 8.8.8.8` OK ✅
4. IsardVDIn hirugarren sare-txartela gehitu → kontsolan *1) Assign Interfaces*: `vtnet2` = OPT1 → *2) Set interface IP address*: 192.168.20.254/24, DHCPrik gabe ✅
5. Web GUI-n OPT1 → **DMZ** izena ✅
6. `admin` kontuaren pasahitz lehenetsia aldatuta (pfSense-k abisua ematen zuen) ✅

![OPT1 esleitu](../../irudiak/SEG/pfsense-opt1-esleitu.png)
*Irudia: kontsolan interfazeak esleitzen: WAN → vtnet0, LAN → vtnet1, OPT1 → vtnet2.*

![Hiru interfazeak](../../irudiak/SEG/pfsense-3-interfazeak.png)
*Irudia: pfSense-ren hiru interfazeak: WAN (DHCP), LAN 192.168.10.254/24 eta OPT1 192.168.20.254/24.*

![DMZ izena](../../irudiak/SEG/pfsense-dmz-interfazea.png)
*Irudia: Interfaces → OPT1: gaituta eta «DMZ» deskribapenarekin.*

## Aliasak

Arauak irakurterrazagoak izateko eta IP bat aldatzen bada leku bakarrean aldatzeko, aliasak erabili dira:

| Alias | Mota | Balioa | Deskribapena |
|---|---|---|---|
| `WWW` | Host | 192.168.20.10 | Web zerbitzaria (WordPress + GLPI) |
| `MEET` | Host | 192.168.20.11 | Jitsi Meet |
| `DB01` | Host | 192.168.10.3 | Datu-base zerbitzaria |
| `DC` | Host | 192.168.10.1 | Domeinu-kontrolatzailea (DNS) |
| `WEB_PORTAK` | Port | 80, 443 | HTTP eta HTTPS |

![IP aliasak](../../irudiak/SEG/pfsense-aliasak-ip.png)
*Irudia: IP aliasak.*

![Portu aliasa](../../irudiak/SEG/pfsense-aliasak-portuak.png)
*Irudia: WEB_PORTAK portu aliasa.*

## Arauak

### DMZ interfazea (goitik behera aplikatzen dira; lehen bat datorrenak irabazten du)

| # | Ekintza | Protokoloa | Jatorria | Helburua | Portua | Log | Arrazoia |
|---|---|---|---|---|---|---|---|
| 1 | ✅ Pass | TCP | WWW | DB01 | 3306 | | WordPress-ek eta GLPIk datu-basea behar dute (salbuespena 3. arauaren aurretik) |
| 2 | ✅ Pass | TCP/UDP | DMZ subnets | DC | 53 (DNS) | | DMZko zerbitzariek domeinuko izenak ebatzi |
| 3 | ❌ Block | Any | DMZ subnets | LAN subnets | — | ☑ | DMZko zerbitzari bat erasotzen badute, ezin da LANera iritsi (pazienteen datuak) |
| 4 | ✅ Pass | UDP | DMZ subnets | This Firewall | 123 (NTP) | | DMZko zerbitzariek ordua pfSense-tik hartzen dute (logetan NTP blokeoak aurkitu ondoren gehitua; ikus «Suebakiaren logak») |
| 5 | ❌ Block | Any | DMZ subnets | This Firewall | — | ☑ | DMZtik pfSense-ren kudeaketa-webera (192.168.20.254:443) sarbidea ukatu; bestela 6. arauak baimenduko luke |
| 6 | ✅ Pass | TCP | DMZ subnets | any | WEB_PORTAK | | Eguneraketak (`apt`) eta kanpoko webguneak; LAN eta pfSense aurreko arauek blokeatu dituzte → Internet bakarrik |
| — | ❌ (inplizitua) | | | | | | Baimendu ez den guztia ukatuta (pfSense-ren lehenetsitako portaera) |

**Aldaketak proposamenarekiko:** LDAPS araua (meet → DC 636) ez da sortu, Jitsi-k oraindik ez duelako ADrekin autentifikatzen (sortuko da hori konfiguratzen bada); 5. araua (pfSense blokeoa) gehitu da, diseinua berrikustean pfSense-ren kudeaketa DMZtik irekita geratzen zela ikusi zelako.

![DMZ arauak](../../irudiak/SEG/pfsense-dmz-arauak.png)
*Irudia: DMZ interfazearen lehen 5 arauak. Block arauek (✖) log-a gaituta dute (☰ ikonoa).*

![DMZ arauak NTPrekin](../../irudiak/SEG/pfsense-dmz-arauak-ntp.png)
*Irudia: azken bertsioa (6 arau): NTP araua pfSense-ren blokeoaren **gainean** kokatu da, bestela blokeoak lehenago bat egingo luke. States zutabean ikusten da arauek trafikoa jasotzen dutela (DNS 6 KiB, eguneraketak 71 MiB, blokeoak 252 B / 180 B).*

### WAN (NAT – port forward)

| Kanpoko portua | Barneko helburua | Arrazoia |
|---|---|---|
| 443/TCP | www 192.168.20.10 | Web korporatiboa |
| 443/TCP (beste IP/portu bat) | meet 192.168.20.11 | Telekontsulta |
| 10000/UDP | meet 192.168.20.11 | Jitsi audio/bideoa (SRTP) |

> IsardVDIn ezin da Internetetik benetako proba egin; NATa konfiguratu eta argazkia ateratzen da, muga hori azalduz.

## IDS – Suricata ⏳

*(aukerak · erabakia · instalazioa · proba: `nmap` eskaneatze bat detektatzen du)*

## VPN – urruneko sarbidea ⏳

*(aukerak: OpenVPN / WireGuard / IPsec · erabakia · konfigurazioa · proba)*

## Probak (www-tik, 192.168.20.10)

| Araua | Proba | Espero dena | Emaitza |
|---|---|---|---|
| 2 – DNS | `nslookup db01.biohealth.local 192.168.10.1` | ✅ ebazten da | ✅ `Address: 192.168.10.3` |
| 6 – web irteera | `sudo apt update` | ✅ deskargatzen du | ✅ 21,1 MB es.archive.ubuntu.com-etik |
| 3 – DMZ → LAN | `ping -c 3 192.168.10.1` | ❌ blokeatuta | ✅ `100% packet loss` |
| 5 – DMZ → pfSense | `curl -k -m 5 https://192.168.20.254` | ❌ blokeatuta | ✅ `Connection timed out` |
| inplizitua | `ping -c 3 8.8.8.8` (ICMP Internetera) | ❌ baimendu gabe | ✅ `100% packet loss` |
| 1 – www → db01:3306 | `nc -zv 192.168.10.3 3306` | ✅ | ✅ `succeeded` (db01-en ufw-an ere 3306 www-ri ireki ondoren; ikus [DBKSA](../DBKSA-datu-baseak/datu-baseak.md)) |

![DNS eta apt](../../irudiak/SEG/proba-dmz-dns-apt.png)
*Irudia: DMZtik domeinuko izenak ebazten dira DCaren bidez (2. araua) eta `apt update`-ek Internetetik deskargatzen du 80 portutik (6. araua). ✅*

![Blokeoak](../../irudiak/SEG/proba-dmz-blokeoak.png)
*Irudia: DMZtik LANera (DC, 192.168.10.1) ping-ak huts egiten du (3. araua), pfSense-ren kudeaketa-webera ezin da sartu (5. araua) eta baimendu gabeko trafikoa (ICMP Internetera) ukatuta dago (arau inplizitua). ✅*

### Suebakiaren logak

*Status → System Logs → Firewall* → iragazkia: Source IP `192.168.20.10`

![Logak 1](../../irudiak/SEG/pfsense-log-dmz-1.png)
*Irudia: www-ren ping-ak DCra **«DMZ LAN ukatu»** arauak blokeatuta (ICMP → 192.168.10.1).*

![Logak 2](../../irudiak/SEG/pfsense-log-dmz-2.png)
*Irudia: `curl` pfSense-ra (TCP SYN → 192.168.20.254:443) **«DMZ-tik pfSense kudeaketa ukatu»** arauak blokeatuta; ping-a 8.8.8.8-ra **Default deny rule**-ak blokeatuta. Log-ek erakusten dute zein arauk blokeatu duen paketea. ✅*

**Logetan aurkitutakoa:** www-k etengabe **UDP 123 (NTP)** bidaltzen du Interneteko denbora-zerbitzarietara (185.125.190.x = ntp.ubuntu.com) eta *Default deny*-k blokeatzen ditu → zerbitzariak ezin du ordua sinkronizatu. Ordu okerrak HTTPS ziurtagiriak eta logen datak hondatzen ditu; konponbidea: 4. araua (NTP → pfSense) eta www-n `NTP=192.168.20.254` (`/etc/systemd/timesyncd.conf`).

![timesyncd.conf](../../irudiak/SEG/www-timesyncd-conf.png)
*Irudia: www-n `/etc/systemd/timesyncd.conf` → `NTP=192.168.20.254`.*

![NTP sinkronizazioa](../../irudiak/SEG/www-ntp-journal.png)
*Irudia: `journalctl -u systemd-timesyncd`: lehenik ntp.ubuntu.com-erako saiakerak (*Timed out*, suebakiak blokeatuta); gero pfSense-ra, eta arauen ordena gorde eta aplikatu ondoren: **«Initial synchronization to time server 192.168.20.254:123»**. ✅*

## Arazoak eta logak

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| OPT1 ez zen kontsolako menuan agertzen IsardVDIn txartela gehitu ondoren | pfSense-k ez ditu txartel berriak automatikoki esleitzen | *1) Assign Interfaces* → vtnet2 = OPT1 |
| Kontsolan `3` sakatu zen *2) Set interface IP*-ren ordez | 3. aukera *Reset webConfigurator password* da | `n` erantzun (aldaketarik ez); `2` sakatu eta gero interfazearen zenbakia `3` |
| NTP arauaren ondoren www-k ez zuen ordua sinkronizatzen (*Packet count: 0*, *Timed out*) | Araua arrastatuz mugitu zen, baina ordena berria ez zen gorde (**Save**) ez aplikatu (**Apply Changes**); NTP araua blokeoaren azpian zegoen | Zerrendaren azpiko **Save** botoia eta gero **Apply Changes**; minutu batera sinkronizatu zen |
| 2. arauak jatorrian `! DMZ subnets` zuen | *Invert match* nahi gabe markatuta → «DMZ ez dena» | Araua editatu, *Invert match* desmarkatu. Ikasgaia: arau bakoitza sortu ondoren zerrendan berrikusi |

![Invert match errorea](../../irudiak/SEG/pfsense-arau2-invert-errorea.png)
*Irudia: 2. araua zuzendu aurretik: `! DMZ subnets` (alderantzizkatuta).*
