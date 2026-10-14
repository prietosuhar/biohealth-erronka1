---
title: Laneko arriskuen prebentzioa (LAP)
parent: "HW – Hardwarea"
nav_order: 2
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Laneko arriskuen prebentzio-plana (LAP) – informatika saila

Plan honek BioHealth-eko **informatika-tailerrean, CPDan eta pantailadun lanpostuetan** dauden arriskuak aztertzen ditu, eta bakoitzerako neurriak eta prestakuntza zehazten ditu. Kokapena: ikus [egoitzaren planoa](hardwarea.md#egoitzaren-planoa-eta-informatika-tailerra).

## Lege-esparrua

| Araua | Zer eskatzen du |
|---|---|
| **31/1995 Legea**, Laneko Arriskuen Prebentzioa | Arriskuak ebaluatu, neurriak hartu, langileei prestakuntza eta informazioa eman |
| **488/1997 EED** – Pantailadun lanpostuak (PVD) | Pantaila, aulkia, mahaia eta argiztapena egokiak; atsedenaldiak |
| **487/1997 EED** – Kargen eskuzko manipulazioa | 25 kg-tik gorako kargak ez eskuz; teknika egokia |
| **486/1997 EED** – Lantokiak | Tenperatura, argiztapena, irteerak, ordena |
| **842/2002 EED** – Behe-tentsioko araudia (REBT) | Instalazio elektrikoa, lurrera konexioa, babes diferentziala |

## Ebaluazio-metodoa: aukerak

| Aukera | Alde onak | Alde txarrak |
|---|---|---|
| **INSST-ren ebaluazio orokorra** (probabilitatea × ondorioak) | Ofiziala, sinplea, enpresa txikietarako; Osalanek ere erabiltzen du | Kualitatiboa |
| William T. Fine metodoa | Kuantitatiboa | Konplexuagoa 20 langilerentzat |
| Kanpoko prebentzio-zerbitzua bakarrik | Aditua | Kostua; ez du gure ikaskuntza erakusten |

**Erabakia: INSST metodoa.** Probabilitatea (B baxua · E ertaina · A altua) × ondorioak (AL apur larria · L larria · OL oso larria) → arriskua: **Txikia · Onargarria · Moderatua · Garrantzitsua · Jasanezina**.

## Arriskuak eta neurriak

| # | Arriskua | Non / noiz | Prob. | Ond. | **Maila** | Prebentzio-neurriak |
|---|---|---|---|---|---|---|
| 1 | **Kontaktu elektrikoa** | Tailerra: ekipoak irekitzea; CPDa: rack-a, SAIa | E | OL | **Garrantzitsua** | Ekipoa itzali eta **deskonektatu** irekitzeko aurretik; SAIa deskonektatuta ere tentsioa izan dezake → ez ireki; diferentziala eta lurrera konexioa; kable hondatuak berehala aldatu; zapata elektrikoak ez katean |
| 2 | **Deskarga elektrostatikoak** (ESD) | Tailerra | A | AL | **Moderatua** | Eskumuturreko antiestatikoa eta mahai antiestatikoa; osagaiak poltsa antiestatikoan (ekipoa babesteko ere) |
| 3 | **Kargen eskuzko manipulazioa** | Zerbitzariak (T360 ~20 kg), SAIak (bateriak ~25 kg), monitore-kutxak | E | L | **Moderatua** | Bi pertsonek; orga erabili; belaunak tolestu eta bizkarra zuzen; rack-ean behealdean pisutsuenak |
| 4 | **Ebakiak eta zauriak** | Txasisaren ertzak, rack-aren errailak, kableak mozten | E | AL | **Onargarria** | Eskularruak; tresna egokiak (alikateak, ez labana); lehen sorospenetako kutxa tailerrean |
| 5 | **Sutea** | CPDa (bateriak, berotzea) | B | OL | **Moderatua** | **CO₂ itzalgailua** CPDaren sarreran (ez ura, ez hautsa ekipo elektronikoetan); ke-detektagailua; tenperatura-sentsorea; materialik ez CPDan; larrialdi-plana eta irteerak seinaleztatuta |
| 6 | **Erorketak eta kolpeak** | Lurreko kableak, irekitako rack-atea | E | AL | **Onargarria** | Kableak kanaletan; ordena (5S); rack-a itxita |
| 7 | **Pantailadun lana (PVD)**: ikusmen-nekea, bizkarreko eta eskumuturreko minak | Lanpostu guztiak (14 PC + 4 eramangarri) | A | AL | **Moderatua** | Pantaila begien altueran, 50–70 cm; aulki doigarria; teklatu eta sagu kanpokoak eramangarriekin; argi naturala alboan (ez atzean/aurrean); **atsedenaldi txikiak** (10 min orduko edo 20-20-20 araua) |
| 8 | **Zarata eta beroa** | CPDa (haizagailuak, klimatizazioa) | E | AL | **Onargarria** | CPDan denbora mugatua; aire girotua 18–27 °C; belarri-babesak lan luzeetan |
| 9 | **Estres teknikoa / lan-karga** | Intzidentzia larriak (ransomwarea), guardiak | E | L | **Moderatua** | Kontingentzia-plana idatzita (zer egin jakitea estresa murrizten du); txandak; GLPI bidez lana lehenetsi |

## Prestakuntza eta ardurak

| Nori | Prestakuntza | Noiz |
|---|---|---|
| Informatika saila | Arrisku elektrikoa, ESD, kargak, suteak (CO₂ itzalgailuaren erabilera) | Lanean hastean + urtero |
| Langile guztiak | PVD ergonomia (pantaila, aulkia, atsedenak), larrialdi-plana | Lanean hastean |
| Zuzendaritza | LAP ardurak, ebaluazioa berrikusi | Urtero edo aldaketa bat dagoenean |

- **Arduraduna:** informatika saileko burua (CPDa eta tailerra) + kanpoko prebentzio-zerbitzua (osasun-azterketak).
- **Berrikuspena:** urtero, istripu bat gertatzen denean edo ekipo/lokal berriak daudenean.
- **Adierazlea:** istripu kopurua (GRI 403) → ikus [jasangarritasun-plana](../IRAU-iraunkortasuna/jasangarritasuna.md).
