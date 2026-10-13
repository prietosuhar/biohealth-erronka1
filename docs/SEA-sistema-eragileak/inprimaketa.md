---
title: Inprimaketa
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Inprimaketa (Windows ↔ Linux) 🔄

## Aukerak eta erabakia

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **Windows Server inprimaketa-zerbitzaria (Print Server rola)** | Domeinuarekin integratua: AD taldeen baimenak, AD-n argitaratzea, GPO bidezko banaketa; Windows bezeroek driverra zerbitzaritik jasotzen dute | Lizentzia (Windows Server-en barne) |
| **CUPS (Linux)** | Doakoa; IPP estandarra (631); web kudeaketa; Linux eta Windows bezeroentzat | Ez dago AD-rekin integratuta lehenetsiz |
| Inprimagailu bakoitza zuzenean (zerbitzaririk gabe) | Ez da zerbitzaririk behar | Ez dago baimen-kontrolik, ilararik ezta erregistro zentralizaturik |

**Erabakia: biak.** Windows Server-a domeinuko langileentzat (baimenak AD taldeen arabera) eta **CUPS db01-en** Linux ekipoentzat. Bi zerbitzarien arteko proba gurutzatuek erakusten dute sistema eragile desberdinen artean inprimatu daitekeela (errubrika: SEA IE5).

**Inprimagailu fisikorik gabe probatzeko:** Windows-en *Generic / Text Only* driverra **tokiko ataka** batekin (`C:\Imprimaketak\harrera.prn`): lan bakoitza fitxategi batean idazten da eta fitxategia irekita ikusten da nork eta zer inprimatu duen. Linux-en *CUPS-PDF* inprimagailu birtuala (PDF bat lan bakoitzeko).

## Portuak eta protokoloak

| Sistema | Protokoloa | Portua | Erabilera BioHealth-en |
|---|---|---|---|
| Windows | SMB (partekatutako inprimagailuak, `\\zerbitzaria\inprimagailua`) | 445/TCP | Bezeroak `INPR-HARRERA`-ra konektatzeko |
| Windows | RPC (Print Spooler) — *named pipes* (SMB gainean) edo TCP | 135/TCP + dinamikoak | Bezeroa ↔ zerbitzariaren spooler-a |
| Linux (CUPS) | IPP | 631/TCP | db01-eko inprimagailua; CUPS web kudeaketa |
| Sare-inprimagailua | RAW / JetDirect | 9100/TCP | Inprimagailu fisiko baterako (produkzioan) |
| Sare-inprimagailua | LPD | 515/TCP | Inprimagailu zaharretarako |

## Inprimagailuak, kokapena eta baimenak

| Inprimagailua | Kokapena | Zerbitzaria | Ataka / driverra | Baimenak (taldea) |
|---|---|---|---|---|
| `INPR-HARRERA` | Harrera – beheko solairua | `ZERBITZARIPRINT` (192.168.10.1) | `C:\Imprimaketak\harrera.prn` · Generic / Text Only | `harrera`, `administrariak`: Imprimir · `informatika`: Imprimir + Administrar documentos + Administrar impresoras · **Todos kenduta** |
| CUPS-PDF ⏳ | Informatika | `db01` (192.168.10.3) | IPP 631 · CUPS-PDF | ⏳ |

**Zergatik baimen hauek:** harrerak eta administrazioak inprimatzen dute (hitzorduak, fakturak); informatikak inprimagailua kudeatzen du (ilarak, driverrak). Medikuntza eta erizaintza ez dira inprimagailu honetara iristen: **Todos** taldea kendu da, bestela domeinuko edonork inprimatu zezakeen.

## Windows Server: inprimaketa-zerbitzaria ✅

1. Rola: *Servicios de impresión y documentos → Servidor de impresión* (lehendik instalatuta).
2. *Administración de impresión → Servidores de impresión → ZERBITZARIPRINT → Impresoras → Agregar impresora*.
3. *Crear un puerto nuevo → Local Port* → `C:\Imprimaketak\harrera.prn` (karpeta lehenago sortu behar da).
4. Driverra: *Instalar un nuevo controlador → Generic → Generic / Text Only*.
5. Izena eta partekatzea: `INPR-HARRERA`, kokapena eta iruzkina.
6. *Propiedades → Seguridad*: taldeen baimenak (goiko taula).

![Administración de impresión](../../irudiak/SEA/print-management.png)
*Irudia: Administración de impresión kontsola (Print Server rola instalatuta).*

![Datuak](../../irudiak/SEA/print-harrera-datuak.png)
*Irudia: izena, partekatze-izena, kokapena eta iruzkina.*

![Laburpena](../../irudiak/SEA/print-harrera-laburpena.png)
*Irudia: laburpena: Generic / Text Only, tokiko ataka `c:\Imprimaketak\harrera.prn`.*

![Segurtasuna](../../irudiak/SEA/print-harrera-segurtasuna.png)
*Irudia: Seguridad fitxa: `harrera` eta `informatika` (Imprimir + Administrar esta impresora + Administrar documentos); **Todos** kenduta. ✅*

### Proba zerbitzaritik bertatik ✅

![Fitxategia](../../irudiak/SEA/print-harrera-prn-karpeta.png)
*Irudia: *Imprimir página de prueba* ondoren `C:\Imprimaketak\harrera.prn` sortu da. ✅*

![Proba-orria](../../irudiak/SEA/print-harrera-proba-zerbitzaria.png)
*Irudia: fitxategia Bloc de notas-ekin: «Instaló correctamente su Generic / Text Only en ZERBITZARIPRINT», `BIOHEALTH\Administrador`, `INPR-HARRERA`. Sistema eragilearen berezko tresnekin egiaztatuta. ✅*

## Probak (errubrika)

| # | Proba | Emaitza |
|---|---|---|
| 1 | Windows Server: inprimagailua instalatu eta bertatik proba | ✅ |
| 2 | Windows Server: partekatu domeinuko talde batzuekin | ✅ |
| 3 | Windows bezeroa (BEZ-WIN01) → Windows Server-eko inprimagailua | 🔄 |
| 4 | Baimenik gabeko erabiltzailea (`mediku1`) → ukatuta | ⏳ |
| 5 | Linux: CUPS-ekin instalatu eta bertatik proba | ⏳ |
| 6 | Linux: CUPS-ekin sarean partekatu | ⏳ |
| 7 | Linux bezeroa → Linux-eko inprimagailua | ⏳ |
| 8 | Windows → Linux-eko inprimagailua | ⏳ |
| 9 | Linux → Windows Server-eko inprimagailua | ⏳ |

![Bezeroa: partekatutakoak](../../irudiak/SEA/print-bezeroa-partekatuak.png)
*Irudia: BEZ-WIN01-etik `\\zerbitzariprintzipala`: `INPR-HARRERA` inprimagailu partekatua ikusten da (SMB 445 ✅).*

## Arazoak

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| Server Manager ez da ireki: «error en un archivo de configuración del usuario… 0x00, carácter no válido» | Erabiltzailearen `user.config` hondatuta, makina bat-batean itzaltzeagatik | *Aceptar* → konfigurazio lehenetsia berreskuratzen du (leihoaren hobespenak bakarrik). Prebentzioa: Windows *Inicio → Apagar* bidez itzali IsardVDI itxi aurretik |
| *Local Port*: «El sistema no puede encontrar la ruta especificada» | Atakaren bidea karpetaren izenarekin bat ez zetorren (`l` / `I` nahastuta; karpeta `Imprimaketak` izenarekin sortuta) | Karpetaren izen zehatza erabili: `C:\Imprimaketak\harrera.prn`. Windows-ek ez du karpeta sortzen, lehenago egon behar du |
| BEZ-WIN01-en inprimagailura konektatzean **0x00000709** | Windows 11 22H2-tik aurrera bezeroak *RPC over TCP* erabiltzen du inprimagailu partekatuetara konektatzeko; Windows Server 2019-ko spooler-ak *named pipes* espero ditu | Bezeroan: `reg add "HKLM\Software\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f` + `net stop spooler && net start spooler`. Produkzioan GPO bidez: *Plantillas administrativas → Impresoras → Configurar opciones de conexión RPC → RPC sobre canalizaciones con nombre* |

![0x709](../../irudiak/SEA/print-bezeroa-0x709.png)
*Irudia: 0x00000709 errorea BEZ-WIN01-en.*

![Server Manager errorea](../../irudiak/SEA/servermanager-userconfig-errorea.png)
*Irudia: Server Manager-en `user.config` errorea.*
