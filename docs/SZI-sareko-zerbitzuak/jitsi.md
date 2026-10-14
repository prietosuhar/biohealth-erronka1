---
title: Jitsi Meet
parent: "SZI – Sareko zerbitzuak"
nav_order: 3
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Bideokonferentzia eta audioa – Jitsi Meet

## Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **Jitsi (apt pakete ofizialak)** | Librea, komandoz instalatzen da, osagai bakoitza zerbitzu erreal bat | Hainbat zerbitzu ulertu behar dira |
| Jitsi Docker | Azkarra | Osagaiak ezkutatzen ditu |
| BigBlueButton | Oso osatua | 8+ GB RAM, 4 CPU |
| Zoom / Teams | Instalaziorik ez | Ordainpekoa; ez da ezer instalatzen |

**Erabakia: Jitsi apt paketeekin**, `meet.biohealth.local` · 192.168.20.11 (DMZ).

## Osagaiak eta protokoloak

| Osagaia | Funtzioa | Protokoloa / portua |
|---|---|---|
| Nginx | Web zerbitzaria eta proxya | HTTP 80 → HTTPS 443/TCP |
| Jitsi Meet (web) | Nabigatzaileko interfazea | WebRTC |
| Prosody | Seinaleztapena (gelak, txata) | XMPP 5222/TCP |
| Jicofo | Konferentziaren «zuzendaria» | XMPP |
| Videobridge | Audio/bideoa birbidali (SFU) | RTP/SRTP 10000/UDP |

Segurtasuna: web-a **TLS**, audio/bideoa **DTLS-SRTP**.

## Zerbitzaria

| Datua | Balioa |
|---|---|
| Izena | `meet.biohealth.local` (DNS: A + PTR, ikus [DNS](dns.md)) |
| IP / zona | `192.168.20.11` · DMZ · atebidea `192.168.20.254` · DNS `192.168.10.1` |
| Sistema | Ubuntu Server 24.04 LTS · 2 vCPU · 4 GB RAM |
| Ziurtagiria | AD CS-k sinatua (`biohealth-ZERBITZARIPRINT-CA`) → domeinuko bezeroek konfiantzazkotzat dute ([ziurtagiriak](../SEG-segurtasuna/zertifikatuak.md)) |
| Kostua | 0 € (Apache 2.0 lizentzia) |

## Instalazioa

### 1. Sistema prestatu

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y gnupg2 curl apt-transport-https nginx
sudo hostnamectl set-hostname meet.biohealth.local
echo "192.168.20.11 meet.biohealth.local meet" | sudo tee -a /etc/hosts
```

### 2. Suebakia (ufw)

```bash
sudo ufw allow 22/tcp      # SSH (LANetik bakarrik iristen da, pfSense)
sudo ufw allow 80/tcp      # HTTP → HTTPS birbideratzea
sudo ufw allow 443/tcp     # HTTPS (web-a + XMPP websocket)
sudo ufw allow 10000/udp   # audioa eta bideoa (JVB)
sudo ufw enable && sudo ufw status numbered
```

### 3. Jitsi biltegi ofiziala

```bash
curl -sL https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list
sudo apt update
```

### 4. Jitsi Meet instalatu

```bash
sudo apt install -y jitsi-meet
```

Instalatzaileak galdetzen du: **hostname** → `meet.biohealth.local` · **SSL** → *Generate a new self-signed certificate* (gero AD CS-ren ziurtagiriarekin ordezkatua).

<img width="1207" height="872" alt="Captura de pantalla 2026-10-13 093755" src="https://github.com/user-attachments/assets/f5484e27-258b-429e-9255-78e45a99a1a1" />
*Irudia: instalatzailearen pantaila (hostname).*

Windows bezerotik zerbitzariaren helbidera sartuta, Jitsi-ren hasiera-orria agertzen da:

<img width="1182" height="882" alt="Captura de pantalla 2026-10-13 094420" src="https://github.com/user-attachments/assets/35794f19-51fc-4554-8bf2-bb9f4d3c004f" />

<img width="1183" height="877" alt="Captura de pantalla 2026-10-13 094732" src="https://github.com/user-attachments/assets/2c6bd09a-f293-4a3e-96f6-12f4a082c4f8" />
*Irudia: gela sortuta, kamera eta mikrofonoa baimenduta.*

### 5. Zerbitzuak egiaztatu

```bash
systemctl status prosody jicofo jitsi-videobridge2 nginx --no-pager
sudo ss -tulpn | grep -E ':443|:10000|:5222'
```

## Audioa (IE7)

| Ezaugarria | BioHealth-en | Zergatik |
|---|---|---|
| Kodeka | **Opus** (48 kHz) | WebRTC-ren derrigorrezko kodeka; ahotsa 6–510 kbit/s, sare txarrean kalitatea egokitzen du |
| Banda-zabalera | ~40 kbit/s parte-hartzaile bakoitzeko | Telekontsultarako nahikoa; mugikorretik ere bai |
| FEC eta DTX | Gaituta (lehenetsia) | FEC: galdutako paketeak berreraiki; DTX: isilik dagoenean ez bidali (banda aurreztu) |
| Oihartzun- eta zarata-kentzea | Gaituta (`disableAP: false`) | Kontsultetan bozgorailu eta mikrofono irekiak |
| Mikrofono zaratatsua detektatu | `enableNoisyMicDetection: true` | Erabiltzaileari abisatzen dio |
| **Audio-soileko gelak** | `startAudioOnly` aukera | Pazienteak banda-zabalera gutxi badu edo kamerarik nahi ez badu (pribatutasuna) |
| Garraioa | **SRTP** (DTLS-SRTP), 10000/UDP | Ahotsa zifratuta (osasun-datuak) |

## Bideoa (IE8)

| Ezaugarria | BioHealth-en | Zergatik |
|---|---|---|
| Kodekak | **VP8** (lehenetsia), VP9, AV1, H.264 | VP9/AV1 kalitate bera banda erdiarekin; H.264 hardware-azelerazioa mugikorretan |
| Bereizmena | **720p** gehienez (`resolution: 720`) | Medikuak pazientea argi ikusteko (larruazala, zauriak); 1080p-k banda bikoitza |
| Banda-zabalera | ~1,5–2,5 Mbit/s bidaltzen 720p-n | Simulcast-ekin JVB-k bezero bakoitzari bere sarera egokitutako geruza bidaltzen dio |
| **Simulcast** | Gaituta | Bezero bakoitzak 3 kalitate bidaltzen ditu (180p/360p/720p); JVB-k (SFU) egokiena aukeratzen du |
| Last N | `channelLastN: 4` | Bilera handietan hitz egiten ari diren 4ak bakarrik HDn → CPU eta banda aurreztu |
| Pantaila partekatzea | Bai | Medikuak emaitzak (analitikak) erakusteko |
| Garraioa | **SRTP** 10000/UDP · SFU (ez du nahasten, birbidali) | Zerbitzariak ez du bideoa deskodetzen → 2 vCPU nahikoa |

### Konfigurazioa

Fitxategia: `/etc/jitsi/meet/meet.biohealth.local-config.js`

```js
resolution: 720,
constraints: { video: { height: { ideal: 720, max: 720, min: 240 } } },
channelLastN: 4,
disableAP: false,
enableNoisyMicDetection: true,
videoQuality: { preferredCodec: 'VP9' },
prejoinConfig: { enabled: true },   // sartu aurretik kamera/mikrofonoa probatu
```

```bash
sudo systemctl restart nginx jicofo jitsi-videobridge2
```

## Probak

| # | Proba | Nola egiaztatu | Emaitza |
|---|---|---|---|
| 1 | 2 ekipo gela berean (BEZ-WIN01 + beste bat) | Elkar ikusi eta entzun | ✅ (ikus irudia) |
| 2 | Audioa: kodeka eta bit-tasa | Parte-hartzailearen txartelean *Connection status* (ⓘ) → *Audio: opus* · bit-tasa | ⏳ |
| 3 | Bideoa: bereizmena eta kodeka | Bera → *Resolution 1280x720* · *Codecs: VP9* | ⏳ |
| 4 | Audio-soileko modua | *Más acciones → Modo solo audio* → bideoaren bit-tasa 0 | ⏳ |
| 5 | Txata eta pantaila partekatzea | — | ⏳ |
| 6 | Zifraketa eta portua | `chrome://webrtc-internals` → `dtlsState: connected`, `srtpCipher`, `udp 192.168.20.11:10000` | ⏳ |

<img width="1238" height="729" alt="image9" src="https://github.com/user-attachments/assets/e6c72594-b1ad-4413-b57b-32cffeae602a" />
*Irudia: bideokonferentzia bi ekipoekin.*

## Arazoak eta logak

| Arazoa | Kausa | Konponbidea |
|---|---|---|
| Kamera/mikrofonoa ez du uzten | `http://` edo IP bidez sartuta | Nabigatzaileek HTTPS eskatzen dute → `https://meet.biohealth.local` |
| Gelan sartu baina audio/bideorik ez | 10000/UDP itxita edo JVB-k IP okerra iragartzen du | `sudo ufw status`; `/etc/jitsi/videobridge/jvb.conf` |
| Logak | — | `sudo tail -f /var/log/jitsi/jvb.log /var/log/jitsi/jicofo.log /var/log/prosody/prosody.log` |
