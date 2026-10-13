---
title: Jitsi Meet
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

## Audioa (IE7) eta bideoa (IE8) ⏳
*(kodekak: Opus audioa, VP8/VP9/H.264 bideoa · kalitate-ezarpenak · banda-zabalera · audio-soileko gelak)*

## Instalazioa ⏳
Aurrebaldintzak eta Sistemaren Prestaketa
Instalazioari ekin aurretik, ezinbestekoa da sistema eguneratuta dagoela ziurtatzea eta beharrezkoak diren oinarrizko paketeak instalatzea.
Sistemaren eguneraketa:
sudo apt update && sudo apt upgrade -y

Beharrezko dependientziak instalatzea:
sudo apt install -y gnupg2 curl apt-transport-https openjdk-11-jre-headless nginx

Jitsi Repositorio Ofiziala Gehitzea
Jitsi Meet-en azken bertsio egonkorra lortzeko, GPG gakoa eta biltegi ofiziala gure sistemara gehituko ditugu.
Biltegiaren GPG gakoa gehitzea:
curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'

Repositorioa APT iturburuetan sartzea:
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list

Paketeen zerrenda berriztatzea:
sudo apt update

Jitsi Meet-en Instalazio eta Konfigurazio Interaktiboa
Repositorioak konfiguratuta daudela, Jitsi-ren pakete nagusia instalatzeari ekingo diogu.
sudo apt install -y jitsi-meet

Hurrengo pantalla agertuko zaigu: <img width="1207" height="872" alt="Captura de pantalla 2026-10-13 093755" src="https://github.com/user-attachments/assets/f5484e27-258b-429e-9255-78e45a99a1a1" />

Windows-eko klientean ubuntu zerbitrariaren ip-a bilatu eta hurrengo lehioa zabalduko zaigu:<img width="1182" height="882" alt="Captura de pantalla 2026-10-13 094420" src="https://github.com/user-attachments/assets/35794f19-51fc-4554-8bf2-bb9f4d3c004f" />
 Dana prestatu eta hasi erabiltzen: <img width="1183" height="877" alt="Captura de pantalla 2026-10-13 094732" src="https://github.com/user-attachments/assets/2c6bd09a-f293-4a3e-96f6-12f4a082c4f8" />


## Probak ⏳
- [ ] 2+ ekipo deian (kamera, mikrofonoa, txata, pantaila partekatu)
