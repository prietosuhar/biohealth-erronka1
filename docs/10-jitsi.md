---
title: Jitsi Meet
---

[← Hasiera](../index.md)

# 10. Bideokonferentzia eta audioa – Jitsi Meet

## 10.1 Aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **Jitsi (apt pakete ofizialak)** | Librea, komandoz instalatzen da, osagai bakoitza zerbitzu erreal bat | Hainbat zerbitzu ulertu behar dira |
| Jitsi Docker | Azkarra | Osagaiak ezkutatzen ditu |
| BigBlueButton | Oso osatua | 8+ GB RAM, 4 CPU |
| Zoom / Teams | Instalaziorik ez | Ordainpekoa; ez da ezer instalatzen |

**Erabakia: Jitsi apt paketeekin**, `meet.biohealth.local` · 192.168.20.11 (DMZ).

## 10.2 Osagaiak eta protokoloak

| Osagaia | Funtzioa | Protokoloa / portua |
|---|---|---|
| Nginx | Web zerbitzaria eta proxya | HTTP 80 → HTTPS 443/TCP |
| Jitsi Meet (web) | Nabigatzaileko interfazea | WebRTC |
| Prosody | Seinaleztapena (gelak, txata) | XMPP 5222/TCP |
| Jicofo | Konferentziaren «zuzendaria» | XMPP |
| Videobridge | Audio/bideoa birbidali (SFU) | RTP/SRTP 10000/UDP |

Segurtasuna: web-a **TLS**, audio/bideoa **DTLS-SRTP**.

## 10.3 Audioa (IE7) eta bideoa (IE8) ⏳
*(kodekak: Opus audioa, VP8/VP9/H.264 bideoa · kalitate-ezarpenak · banda-zabalera · audio-soileko gelak)*

## 10.4 Instalazioa ⏳

## 10.5 Probak ⏳
- [ ] 2+ ekipo deian (kamera, mikrofonoa, txata, pantaila partekatu)
