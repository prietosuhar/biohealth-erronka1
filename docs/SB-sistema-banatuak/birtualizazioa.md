---
title: Birtualizazioa eta HA
parent: "SB – Sistema banatuak"
nav_order: 1
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Birtualizazioa, kontenedoreak eta erabilgarritasun handia (HA)

## 1. Sistema banatu baten beharra

BioHealth-ek **telekontsulta** eta **pazienteen datuak** kudeatzen ditu: zerbitzu bat erortzen bada, medikuek ezin dute kontsultarik egin. Helburua **% 99,9eko erabilgarritasuna** da lan-orduetan → urtean gehienez **~8,8 ordu** geldialdi.

Gaur egungo azpiegituran zerbitzu bakoitza makina **bakar** batean dago. Hauek dira **SPOF-ak** (*Single Point of Failure*, hutsegite-puntu bakarrak):

| SPOF | Erortzen bada | Eragina |
|---|---|---|
| **zerbitzariprintzipala** (DC) | Ez dago saio-hasierarik, DNSrik, DHCPrik, inprimaketarik | 🔴 Enpresa osoa geldi |
| **db01** | WordPress eta GLPI gabe; pazienteen datuak eskuraezin | 🔴 Oso larria |
| **pfSense** | Ez dago Internetik, VPNrik, telekontsultarik | 🔴 Oso larria |
| **www** | Web korporatiboa eta laguntza-mahaia (GLPI) behera | 🟠 Ertaina |
| **meet** | Telekontsulta behera | 🟠 Altua lan-orduetan |
| **Ostalari fisikoa** (produkzioan pve01) | **Makina birtual GUZTIAK** batera erortzen dira | 🔴 Larriena |

## 2. Birtualizazio-tresna

### Aukerak

| Aukera | Mota | Kostua | Alde onak | Alde txarrak |
|---|---|---|---|---|
| **Proxmox VE** | 1. motako hipervisorea (KVM) + LXC | 0 € (harpidetza aukerakoa) | VM **eta** kontenedoreak; cluster-a, HA eta babeskopiak (vzdump) doan; web GUI | Komunitate-laguntza (harpidetzarik gabe) |
| VMware vSphere | 1. motakoa | Lizentzia garestia (Broadcom) | Industria-estandarra | 20 langilerentzat kostu handiegia |
| Hyper-V | 1. motakoa (Windows) | Windows Server lizentzian | AD-rekin integrazioa | Linux kontenedorerik ez; HAk Windows cluster-a eskatzen du |
| VirtualBox | 2. motakoa | 0 € | Erraza | Mahaigainerako; ez du HArik |

**Erabakia: Proxmox VE** produkzioan (HW txostenean proposatutako `pve01`). Laborategian **IsardVDI** erabiltzen da (ikastetxeak emandako KVM plataforma bera, Proxmox-en oso antzekoa): makina birtual bakoitza IsardVDIko mahaigain bat da.

| Datua | Laborategia | Produkzioa (proposamena) |
|---|---|---|
| Tresna | IsardVDI (KVM) | Proxmox VE 9 |
| Ostalaria | Ikastetxeko zerbitzariak | `pve01` · Dell PowerEdge T360 ([HW](../HW-hardwarea/hardwarea.md)) |
| Sareak | Default (WAN) · Pertsonala1 (LAN) · Pertsonala2 (DMZ) | `vmbr0` WAN · `vmbr1` LAN · `vmbr2` DMZ (Linux bridge-ak) |
| VMak | pfsense, zerbitzariprintzipala, db01, www, meet, BEZ-WIN01, bez-lnx01 | berdinak |
| Kontenedoreak | GLPI (Docker, www-n) | GLPI eta Nextcloud (LXC) |

## 3. Zerbitzu bat makina birtualean eta beste bat kontenedorean

### VM ala kontenedorea?

| | Makina birtuala (VM) | Kontenedorea (Docker / LXC) |
|---|---|---|
| Zer birtualizatzen du | Hardware osoa: kernel propioa | Prozesuak: ostalariaren kernela partekatzen du |
| Isolamendua | Handia (beste SE bat izan daiteke: Windows) | Txikiagoa (Linux bakarrik, kernel berdina) |
| Abiarazte-denbora / RAM | Minutuak · GBak | Segundoak · MBak |
| Noiz erabili | Zerbitzu kritikoak, Windows, isolamendu handia | Web aplikazioak, mikrozerbitzuak, bertsio-aldaketa azkarrak |

### 3.1. VM batean: WordPress (www) eta Jitsi (meet)

`www` (192.168.20.10, DMZ) IsardVDIko makina birtual bat da: Ubuntu Server + Apache + PHP + WordPress, zuzenean SE-an instalatuta. Ikus [WordPress](../WAE-web-aplikazioak/wordpress.md). `meet` ere VM bat da (Jitsi-k hainbat zerbitzu eta UDP portuak behar ditu; VM batean errazago kudeatzen da). Ikus [Jitsi](../SZI-sareko-zerbitzuak/jitsi.md).

### 3.2. Kontenedore batean: GLPI (Docker)

**Aukerak:**

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **Docker www-n (GLPI)** | Ez du makina berririk behar; irudi ofiziala `glpi/glpi`; db01-eko `glpi` DB berrerabiltzen du; WAE (GLPI) eta SB (kontenedorea) batera betetzen ditu | Docker-ek ufw saihesten du portuak argitaratzean → 127.0.0.1-era lotu |
| LXC Proxmox habiaratuan | Produkzioko diseinuarekin berdina | Proxmox IsardVDI barruan (habiaratutako birtualizazioa) astuna eta motela |
| Uptime Kuma Docker-en | Oso erraza; zerbitzuen monitorizazioa (HArekin lotuta) | Ez du errubrikako beste atalik betetzen |

**Erabakia: GLPI 10 Docker kontenedorean, www-n.**

| Parametroa | Balioa |
|---|---|
| Irudia | `glpi/glpi:10.0.x` (GLPI 11-k MariaDB ≥ 10.6 behar du; db01-ek 10.3) |
| Kontenedorea | `glpi`, `--restart unless-stopped` (ostalaria berrabiaraztean bera abiarazten da) |
| Portua | `127.0.0.1:8080 → 80` (kanpotik ezin da zuzenean sartu) |
| Bolumena | `glpi_data` → `/var/glpi` (datuak kontenedorea ezabatuta ere geratzen dira) |
| Datu-basea | db01 `192.168.10.3:3306`, `glpi` DB, `glpi_user`@`192.168.20.10` |
| Sarrera | Apache alderantzizko proxya → `https://glpi.biohealth.local` |
| Scripta | [`scripts/www-glpi-docker.sh`](../../scripts/www-glpi-docker.sh) |

```
BEZ-WIN01 ──HTTPS 443──► www: Apache (proxy) ──► 127.0.0.1:8080 ──► [kontenedorea: glpi]
                                                                         │ 3306 (pfSense 1. araua)
                                                                         ▼
                                                                  db01: MariaDB `glpi`
```

**Kudeaketa-komandoak (errubrika: zerbitzua martxan jarri, gelditu, egoera):**

```bash
sudo docker ps                              # egoera
sudo docker stop glpi && sudo docker ps -a  # gelditu → Exited
sudo docker start glpi                      # abiarazi
sudo docker logs --tail 30 glpi             # logak
sudo docker stats --no-stream glpi          # RAM / CPU kontsumoa (VM batekin alderatzeko)
sudo docker volume inspect glpi_data
```

### Ebidentziak ⏳
- [ ] `docker ps` (glpi *Up*, `127.0.0.1:8080->80/tcp`)
- [ ] `docker stop` / `start` eta `docker stats` (kontenedoreak ~100–200 MB RAM vs VM batek 2 GB)
- [ ] `https://glpi.biohealth.local` BEZ-WIN01-etik
- [ ] `ss -tlnp`: 8080 `127.0.0.1`-en bakarrik

## 4. HA arkitektura (diseinua)

### Aukerak

| Aukera | Nodoak | Kostu gehigarria* | RTO ostalaria erortzean | Iruzkina |
|---|---|---|---|---|
| A. Ostalari bakarra + babeskopiak | 1 | 0 € | 2–4 h (berrezarri NASetik) | Gaur egungoa; ez da HA |
| **B. Proxmox cluster 2 nodo + QDevice** | 2 + NAS | ~4.000 € (2. zerbitzaria) | **~2–3 min** (VMak beste nodoan berrabiarazten dira) | **Aukeratua** |
| C. Proxmox cluster 3 nodo + Ceph | 3 | ~8.000 € + 10 GbE | ~2 min, biltegiratze banatua | Enpresa ertain-handientzat |

\* HW txostenean pve01-en prezioan oinarritutako estimazioa.

**Erabakia: B.** Proposamenean 3 nodo aipatzen ziren; azterketa egitean ikusi dugu Proxmox-ek **quorum**-a lortzeko hirugarren boto bat bakarrik behar duela, eta hori **QDevice** batek eman dezakeela (NASean exekutatzen den zerbitzu txiki bat). Horrela 3. zerbitzariaren kostua aurrezten da eta % 99,9 helburua betetzen da 20 langileko enpresa batentzat.

### Diseinua

```
                 Internet
                    │
          ┌─────────┴─────────┐
          │ pfSense-1 │ pfSense-2 │  CARP: IP birtual partekatua (.254)
          └─────────┬─────────┘  pfsync: egoera-taulak sinkronizatuta
                    │ LAN / DMZ (switch-a)
     ┌──────────────┼──────────────┐
 ┌───┴────┐                   ┌────┴───┐        ┌──────────────┐
 │ pve01  │◄── corosync ─────►│ pve02  │        │ NAS          │
 │ dc01   │   ZFS erreplika   │ dc02   │        │ QDevice (3. boto)
 │ db01   │   (15 min)        │ (www)  │        │ babeskopiak  │
 │ www    │                   │ (meet) │        └──────────────┘
 └────────┘                   └────────┘
```

| Geruza | Erredundantzia | Nola |
|---|---|---|
| Ostalariak | **pve01 + pve02** cluster-a + QDevice | Proxmox HA: nodo bat erortzen bada, bere VMak beste nodoan automatikoki berrabiarazten dira |
| Biltegiratzea | ZFS erreplikazioa nodoen artean (15 min) | Ceph baino merkeagoa; RPO ≤ 15 min |
| Domeinua | **dc02** (bigarren domeinu-kontrolatzailea) | AD eta DNS bi DCtan erreplikatuta; DHCP *failover* (bakoitzak % 50) |
| Datu-basea | MariaDB **primary → replica** (db01 → db02) | Erreplika asinkronoa; db01 erortzen bada db02 sustatu |
| Web | Proxmox HA (www berrabiarazi beste nodoan) | 20 langilerentzat ez da balantzatzailerik behar |
| Suebakia | **pfSense CARP** (2 instantzia) | IP birtual partekatua; bat erortzen bada bestea segundotan |
| Elektrizitatea | 2 SAI, iturri bikoitzeko zerbitzariak | — |

### Erabilgarritasunaren kalkulua

| Diseinua | Ostalari baten hutsegitea (urtean 1, adib.) | Geldialdia |
|---|---|---|
| A (gaur) | Berrezarri NASetik | 2–4 h hutsegite bakoitzeko → 3 hutsegiterekin % 99,9-tik behera |
| B (HA) | VMak automatikoki beste nodoan | ~3 min → % 99,9 helburua gainditzen da |

### Laborategiko frogak (aukerakoa) ⏳
- [ ] Kontenedorearen berrabiaratze automatikoa: `sudo reboot` www-n → itzultzean `docker ps`-ek GLPI *Up* erakusten du inork abiarazi gabe (`--restart unless-stopped`).
- [ ] VM bat geldiarazi (www) eta pfSense-ren logetan zerbitzua eskuraezin dagoela ikusi → HA zergatik behar den frogatzen du.
