---
title: Active Directory
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Active Directory

## Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **Windows Server + AD DS** | Erronkak Windows domeinua eskatzen du; AD DS, DNS, DHCP eta inprimaketa zerbitzari berean; GPOak | Lizentzia ordainpekoa |
| Samba 4 AD DC | Doakoa | GPO kudeaketa mugatuagoa; konplexuagoa |
| FreeIPA / OpenLDAP | Doakoa, Linux | Ez ditu Windows bezeroak GPOekin kudeatzen |
| Microsoft Entra ID | Hodeian | Osasun-datuak kanpoan; ez da instalatzen |

**Erabakia: Windows Server 2019 + AD DS** (ikus [proposamena vs. inplementazioa](../00-orokorra/proposamena-vs-inplementazioa.md)).

## Zerbitzaria

| Datua | Balioa |
|---|---|
| Host-izena | `zerbitzariprintzipala` (NetBIOS: `ZERBITZARIPRINT`, 15 karaktereko muga) |
| IP | 192.168.10.1/24 · atebidea 192.168.10.254 · DNS 127.0.0.1 |
| Rolak | AD DS, DNS, DHCP, Inprimaketa eta dokumentu zerbitzuak |
| Basoa / domeinua | `biohealth.local` (baso berria) · NetBIOS `BIOHEALTH` |
| Administrari-kontua | `BIOHEALTH\Administrador` (pasahitza ez da hemen jasotzen) |

## OU egitura

```
biohealth.local
└── Departamentuak
    ├── Administrariak   → admin1, admin2, admin3        · taldea: administrariak
    ├── Erizaintza       → erizain1, erizain2, erizain3  · taldea: erizaintza
    ├── Harrera          → harrera1, harrera2, harrera3  · taldea: harrera
    ├── Informatika      → infor1, infor2, infor3        · taldea: informatika
    └── Medikuntza       → mediku1, mediku2, mediku3     · taldea: medikuntza
```

![OU egitura: Departamentuak](../../irudiak/SEA/ad-ou-departamentuak.png)
*Irudia: `Departamentuak` OUaren barruan sail bakoitzeko OU bat: Administrariak, Erizaintza, Harrera, Informatika eta Medikuntza. ✅*

![Administrariak OUaren edukia](../../irudiak/SEA/ad-ou-administrariak.png)
*Irudia: `Administrariak` OUa: Admin1, Admin2 eta Admin3 erabiltzaileak eta `administrariak` segurtasun-taldea. Gainerako OUek egitura bera dute (3 erabiltzaile + taldea). ✅*

**Zergatik egitura hau:** OU bat sail bakoitzeko GPOak sailka aplikatzeko; talde bat sail bakoitzeko baimenak (inprimagailuak, karpetak) taldeka emateko, ez erabiltzaileka.

## GPOak ✅

### Aukerak

| Aukera | Erabiltzaile askorentzat | Talde konkretu batentzat | Balorazioa |
|---|---|---|---|
| A. Taldearen hasierako GPOak bakarrik | Panel_Blokeatu + Itzali_ez (arau 1 bakoitza) | — | Errubrikak 2 arau eta talde konkretu baterako GPO bat eskatzen ditu |
| **B. Lehendik daudenak osatu + Harrerarentzat bat** | **Panel_Blokeatu**: Kontrol-panela + CMD, Informatika kanpoan | **GPO-Harrera**: pantaila-blokeoa 5 min + USB debekatuta | ✅ Ez da ezer berriz egiten; arau bakoitzak arrazoi erreala du |
| C. GPO berri guztiak | — | — | Taldearen lana bikoiztu |

**Erabakia: B.** Langileek ezin dute sistemaren konfigurazioa aldatu (Kontrol-panela, CMD); Informatika kanpoan dago, ekipoak mantentzen dituelako. Harrera publikoarekin dagoen postua da (pazienteak aurrean): pantaila bakarrik blokeatu behar da eta datuak ezin dira USB batean atera.

| GPO | Lotuta | Arauak | Iragazkia | Errubrika |
|---|---|---|---|---|
| **Panel_Blokeatu** | Departamentuak (15 erabiltzaile) | 1) Kontrol-panela eta PC konfigurazioa debekatuta · 2) CMD debekatuta (scriptak bai) | `informatika` taldeari **Ukatu** «Aplicar directiva de grupo» | Erabiltzaile askorentzat ✅ |
| **Itzali_ez** | Departamentuak | Itzali, berrabiarazi, eseki eta hibernatu komandoak kendu | — | Gehigarria: ekipoak piztuta eguneraketa eta babeskopietarako |
| **GPO-Harrera** | Harrera (3 erabiltzaile) | 1) Pantaila-babeslea pasahitzarekin 300 s · 2) USB biltegiratzea debekatuta | — | Talde konkretu batentzat ✅ |

### Panel_Blokeatu

![Panel_Blokeatu hasieran](../../irudiak/SEA/gpo-panel-blokeatu-araua-hasiera.png)
*Irudia: hasieran arau bakarra zuen: «Prohibir el acceso a Configuración de PC y a Panel de control».*

![CMD debekatu](../../irudiak/SEA/gpo-panel-blokeatu-cmd.png)
*Irudia: bigarren araua gehituta: «Impedir el acceso al símbolo del sistema» → Habilitada. Scripten prozesamendua **ez** da desaktibatzen, saio-hasierako scriptek funtziona dezaten.*

![Informatika kanpoan](../../irudiak/SEA/gpo-panel-blokeatu-informatika-ukatu.png)
*Irudia: segurtasun-iragazkia: `informatika` taldeari «Aplicar directiva de grupo» baimena **ukatuta**; GPOa ez zaie aplikatzen Informatikako langileei.*

### Itzali_ez

![Itzali_ez araua](../../irudiak/SEA/gpo-itzali-ez-araua.png)
*Irudia: «Quitar y evitar el acceso a los comandos Apagar, Reiniciar, Suspender e Hibernar» → Habilitado.*

### GPO-Harrera

`Departamentuak/Harrera` OUari lotuta (harrera1, harrera2, harrera3).

![GPO-Harrera konfigurazioa](../../irudiak/SEA/gpo-harrera-konfigurazioa.png)
*Irudia: GPO-Harrera-ren laburpena. **1. araua – pantaila-blokeoa:** pantaila-babeslea gaituta, pasahitzarekin babestuta eta 300 segundoren (5 min) ondoren aktibatzen da. **2. araua – USBa:** «Todas las clases de almacenamiento extraíble: denegar acceso a todo» → gaituta.*

![Itxaron-denbora 300 s](../../irudiak/SEA/gpo-harrera-denbora.png)
*Irudia: pantaila-babeslearen itxaron-denbora: 300 segundo.*

![Pantaila-babesle zehatza](../../irudiak/SEA/gpo-harrera-scrnsave.png)
*Irudia: «Aplicar un protector de pantalla específico» → `scrnsave.scr` (pantaila beltza). Windows 11-k ez du pantaila-babeslerik lehenetsita; hau gabe, beste arauak gaituta egon arren, pantaila ez litzateke blokeatuko.*

![USB debekatuta](../../irudiak/SEA/gpo-harrera-usb.png)
*Irudia: biltegiratze aldagarri guztiei sarbidea ukatuta (USB memoriak, disko kanpokoak, CD/DVD…), pazienteen datuak ez ateratzeko.*

### Probak (BEZ-WIN01) ✅

| Erabiltzailea | Proba | Espero dena | Emaitza |
|---|---|---|---|
| `mediku1` | `Win+R` → `cmd` | ❌ debekatuta | ✅ «El administrador ha deshabilitado el símbolo del sistema» |
| `mediku1` | `Win+R` → `control` | ❌ debekatuta | ✅ «Restricciones» leihoa |
| `mediku1` | Hasiera → itzali botoia | Aukerarik ez | ✅ «No hay disponibles opciones de inicio/apagado» |
| `mediku1` | `gpresult /r` (PowerShell) | Panel_Blokeatu + Itzali_ez | ✅ biak aplikatuta |
| `infor1` | `Win+R` → `cmd` | ✅ irekitzen da (iragazkia) | ✅ CMD irekita |
| `infor1` | `gpresult /r` | Panel_Blokeatu iragazita | ✅ «Denegado (Seguridad)»; Itzali_ez bai aplikatuta |
| `harrera1` | `gpresult /r` | GPO-Harrera + Panel_Blokeatu + Itzali_ez | ✅ hirurak aplikatuta |
| `harrera1` | Pantaila-babeslearen balioak erregistroan (`reg query`) | 1 · 1 · 300 · scrnsave.scr | ✅ lau balioak |
| `harrera1` | USB bat konektatu | ❌ ukatuta | IsardVDIn ezin da probatu (USB fisikorik ez); konfigurazioaren argazkiarekin justifikatuta |

![mediku1: CMD debekatuta](../../irudiak/SEA/proba-mediku1-cmd.png)
*Irudia: `mediku1`-ek CMD irekitzean: «El administrador ha deshabilitado el símbolo del sistema» → Panel_Blokeatu-ren 2. araua funtzionatzen du. ✅*

![mediku1: Kontrol-panela debekatuta](../../irudiak/SEA/proba-mediku1-kontrol-panela.png)
*Irudia: `control` exekutatzean «Restricciones» leihoa → Panel_Blokeatu-ren 1. araua funtzionatzen du. ✅*

![mediku1: itzaltzeko aukerarik ez](../../irudiak/SEA/proba-mediku1-itzali.png)
*Irudia: Hasierako itzali botoiak «En este momento no hay disponibles opciones de inicio/apagado» erakusten du → Itzali_ez funtzionatzen du. ✅*

![Informatika: CMD irekitzen da](../../irudiak/SEA/proba-informatika-cmd.png)
*Irudia: Informatikako erabiltzaileak (`C:\Users\infor1`) CMD ireki dezake: segurtasun-iragazkiak (`informatika` taldeari «Aplicar directiva de grupo» ukatuta) Panel_Blokeatu ez aplikatzea eragiten du. ✅*

![Informatika: gpresult](../../irudiak/SEA/proba-informatika-gpresult.png)
*Irudia: `infor1` (`OU=Informatika`) erabiltzailearen `gpresult /r`: **Itzali_ez** aplikatuta, eta **Panel_Blokeatu** «Filtrar: Denegado (Seguridad)» → Windows-ek berak erakusten du segurtasun-iragazkiak GPOa blokeatu duela. ✅*

![harrera1: gpresult](../../irudiak/SEA/proba-harrera1-gpresult.png)
*Irudia: `harrera1`-en `gpresult /r`: **GPO-Harrera**, Panel_Blokeatu eta Itzali_ez aplikatuta; erabiltzailea `harrera` taldekoa da. GPO-Harrera Harrera OUan bakarrik dagoenez, beste sailetako erabiltzaileei ez zaie aplikatzen (ikus mediku1). ✅*

![harrera1: erregistroa](../../irudiak/SEA/proba-harrera1-erregistroa.png)
*Irudia: `HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop`: GPOak idatzitako balioak: `ScreenSaveActive = 1` (gaituta), `ScreenSaverIsSecure = 1` (pasahitza), `ScreenSaveTimeOut = 300` (5 min) eta `SCRNSAVE.EXE = scrnsave.scr`. Honek erakusten du GPO-Harrera-ren 1. araua bezeroan indarrean dagoela, 5 minutu itxaron gabe. ✅*

![mediku1: gpresult](../../irudiak/SEA/proba-mediku1-gpresult.png)
*Irudia: `gpresult /r`: `CN=Mediku1,OU=Medikuntza,OU=Departamentuak` erabiltzaileari **Panel_Blokeatu** eta **Itzali_ez** aplikatu zaizkio, zerbitzariprintzipala.biohealth.local-etik. ✅*

## Bezeroa domeinuan 🔄

| Datua | Balioa |
|---|---|
| Ekipoa | BEZ-WIN01 · Windows 11 Pro |
| IP | 192.168.10.102 (DHCP, zerbitzariaren tartean) — ikus [DHCP](../SZI-sareko-zerbitzuak/dhcp.md) |
| DNS | 192.168.10.1 (domeinu-kontrolatzailea) |
| Kontu lokala | `uni` (administratzaile lokala) |

**Pausoak:** `sysdm.cpl` → *Aldatu* → Domeinua: `biohealth.local` → domeinuko administratzaile baten kredentzialak → berrabiarazi.

- [x] BEZ-WIN01-en IPa zerbitzariaren tartean
- [x] DNS = 192.168.10.1
- [x] Domeinura batuta eta domeinuko erabiltzaile batekin (`mediku1`) saioa hasita
- [x] `gpresult /r` → GPOak aplikatuta (mediku1, infor1, harrera1)

![BEZ-WIN01 domeinuan, mediku1 erabiltzailearekin](../../irudiak/SEA/bezeroa-domeinuan-cmd.png)
*Irudia: Medikuntza saileko `mediku1` erabiltzaileak BEZ-WIN01-en saioa hasi du. `whoami` → `biohealth\mediku1`, `hostname` → `BEZ-WIN01` eta `systeminfo` → `Dominio: biohealth.local`. Honek erakusten du bezeroa domeinuan dagoela eta direktorio-zerbitzua erabiltzaileak zentralizatuki egiaztatzeko erabiltzen dela. ✅*

## Zerbitzuen kudeaketa eta prozesuak 🔄

### AD zerbitzuak ✅

| Zerbitzua (`Name`) | Izena | Funtzioa |
|---|---|---|
| `NTDS` | Servicios de dominio de Active Directory | Direktorioaren datu-basea (erabiltzaileak, taldeak, OUak, GPOak) |
| `Kdc` | Centro de distribución de claves Kerberos | Autentifikazioa (saio-hasiera, txartelak) |
| `Netlogon` | Net Logon | Erabiltzaileak eta ekipoak egiaztatu, SRV erregistroak erregistratu |
| `DNS` | Servidor DNS | Izenak ebatzi; ADren zonak gordetzen ditu |
| `DFSR` | Replicación DFS | SYSVOL karpeta (GPOak, scriptak) erreplikatu |
| `IsmServ` | Mensajería entre sitios | Gune desberdinen arteko erreplikazioa |

#### Modu grafikoa (`services.msc`)

![NTDS gelditu: mendekotasunak](../../irudiak/SEA/zerbitzuak-ntds-gelditu-mendekotasunak.png)
*Irudia: «Servicios de dominio de Active Directory» gelditzean, Windows-ek ohartarazten du mendeko zerbitzuak ere geldituko direla: Kerberos (KDC), Mensajería entre sitios, Servidor DNS eta Replicación DFS.*

![NTDS berriro martxan](../../irudiak/SEA/zerbitzuak-ntds-martxan.png)
*Irudia: zerbitzua berriro abiarazita: «En ejecución»; DNS zerbitzaria «Iniciando» egoeran.*

#### Komandoak (PowerShell)

```powershell
Get-Service NTDS, Kdc, IsmServ, DNS, DFSR, Netlogon | Format-Table Name, DisplayName, Status
Stop-Service NTDS -Force
Start-Service NTDS, Kdc, IsmServ, DNS, DFSR
Restart-Service NTDS -Force
```

![Mendeko zerbitzuak geldituta](../../irudiak/SEA/zerbitzuak-mendekotasunak-geldituta.png)
*Irudia (arazoa): NTDS berriro abiarazi ondoren `IsmServ` eta `Kdc` **Stopped** geratu ziren.*

![Zerbitzu guztiak martxan](../../irudiak/SEA/zerbitzuak-denak-martxan.png)
*Irudia (konponbidea): `Start-Service Kdc, IsmServ` → sei zerbitzuak **Running**.*

![Gelditu eta efektua](../../irudiak/SEA/zerbitzuak-ps-gelditu.png)
*Irudia: `Stop-Service NTDS -Force` → egoera **Stopped**. Ondoren `Get-ADUser mediku1` huts egiten du: «No se pudo encontrar ningún servidor… Servicios web de Active Directory» (`ADServerDownException`) → AD gabe direktorioa ezin da kontsultatu. ❌ (espero zena)*

![Abiarazi](../../irudiak/SEA/zerbitzuak-ps-abiarazi.png)
*Irudia: `Start-Service NTDS, Kdc, IsmServ, DNS, DFSR` → DNS zerbitzariak segundo batzuk behar ditu («Esperando a que se inicie…»); azkenean lau zerbitzuak **Running**. (Lehen `Format-Table`-ak zutabea hutsik erakusten du `Statu` gaizki idatzi zelako.)*

![Get-ADUser berriro](../../irudiak/SEA/zerbitzuak-ps-getaduser-ok.png)
*Irudia: AD berriro martxan dagoenean `Get-ADUser mediku1`-ek erabiltzailearen datuak itzultzen ditu (DN: `CN=Mediku1,OU=Medikuntza,OU=Departamentuak,DC=biohealth,DC=local`, UPN: `Mediku1@biohealth.local`). ✅*

![Berrabiarazi](../../irudiak/SEA/zerbitzuak-ps-berrabiarazi.png)
*Irudia: `Restart-Service NTDS -Force` → NTDS, Kdc eta IsmServ **Running**. ✅*

### Prozesuak 🔄

Adibide gisa **Bloc de notas** (`notepad.exe`) erabili da, amaitzeak sistemari eragiten ez diolako.

#### Modu grafikoa

![Task Manager: Xehetasunak](../../irudiak/SEA/prozesuak-taskmgr-xehetasunak.png)
*Irudia: Administrador de tareas → **Detalles**: prozesu bakoitzaren izena, **PID**a (notepad.exe = 3412), egoera, erabiltzailea, CPU eta memoria. ADren prozesuak ere ikusten dira: `lsass.exe` (AD DS eta Kerberos honen barruan exekutatzen dira), `dns.exe`, `ismserv.exe`, `dfsrs.exe`, `Microsoft.ActiveDirectory.WebServices`.*

![Lehentasuna aldatu](../../irudiak/SEA/prozesuak-taskmgr-lehentasuna.png)
*Irudia: notepad.exe → *Establecer prioridad* → **Alta**. Lehentasunak zehazten du prozesadorearen denbora zenbat ematen zaion prozesuari (Baja → Tiempo real).*

![Prozesua amaitu](../../irudiak/SEA/prozesuak-taskmgr-amaitu.png)
*Irudia: *Finalizar tarea* → Windows-ek berrespena eskatzen du, gorde gabeko datuak gal daitezkeelako eta sistema-prozesu bat bada sistema ezegonkor geratu daitekeelako. (PID 4708: Bloc de notas berriro ireki zen, PIDa exekuzio bakoitzean aldatzen da.)*

![Resource Monitor](../../irudiak/SEA/prozesuak-resmon.png)
*Irudia: Monitor de recursos (`resmon`) → **CPU**: prozesuak (PID, hari-kopurua, CPU erabilera), zerbitzuak eta CPU bakoitzaren grafikoak denbora errealean.*

#### Komandoak ⏳

## Arazoak eta logak

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| NetBIOS izena moztuta | 15 karaktereko muga | Onartu eta dokumentatu |
| `reg query "HKCU\Software\Policies\Microsoft\Control Panel\Desktop"` → *no ha podido encontrar la clave* | Bidean `Windows\` falta zen | Bide zuzena: `HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop` |
| NTDS berriro abiaraztean, `Kdc` eta `IsmServ` **Stopped** geratu ziren → domeinuko saio-hasierak huts egingo luke | NTDS gelditzean mendeko zerbitzuak ere gelditzen dira, baina NTDS abiaraztean **ez dira automatikoki abiarazten** | `Start-Service Kdc, IsmServ` eta `Get-Service`-rekin egiaztatu; aurrerantzean `Start-Service NTDS, Kdc, IsmServ, DNS, DFSR` batera |
| Ekipoa ezin itzali `mediku1`-en saiotik (behartu egin behar izan zen) | Itzali_ez GPOak erabiltzailearen saioan itzaltzeko aukerak kentzen ditu (nahita) | **Saioa itxi** eta saio-hasierako pantailako itzali botoia erabili (han ez dago erabiltzailearen GPOrik); edo administratzaile batekin |
