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
1. Requisitos Previos y Preparación del Sistema

Antes de iniciar la instalación, es necesario asegurarse de que el sistema esté actualizado e instalar los paquetes básicos necesarios.

Actualizar el sistema:

sudo apt update && sudo apt upgrade -y


Instalar dependencias necesarias:

sudo apt install -y gnupg2 curl apt-transport-https openjdk-11-jre-headless nginx


2. Configuración del Repositorio Oficial de Jitsi

Para obtener la última versión estable de Jitsi Meet, agregamos la clave GPG y el repositorio oficial a nuestro sistema.

Añadir la clave GPG del repositorio:

curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'


Añadir el repositorio a las fuentes de APT:

echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list


Actualizar la lista de paquetes:

sudo apt update


3. Instalación de Jitsi Meet y Configuración Interactiva

Con los repositorios configurados, procedemos a la instalación del paquete principal de Jitsi.

sudo apt install -y jitsi-meet

## Probak ⏳
- [ ] 2+ ekipo deian (kamera, mikrofonoa, txata, pantaila partekatu)
