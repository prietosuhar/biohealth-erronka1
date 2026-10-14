---
title: Dokumentazio-webgunea (GitHub Pages)
parent: "Orokorra"
nav_order: 4
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Dokumentazio-webgunea (GitHub Pages) ✅

Errubrikak (WAE) dokumentazioa **GitHub biltegi batean, GitHub Pages-ekin eta Markdown-ez** eskatzen du. Biltegia `prietosuhar/biohealth-erronka1` da, eta webgunea hemen argitaratzen da:

**<https://prietosuhar.github.io/biohealth-erronka1/>**

`main` adarrean egiten den commit bakoitzak webgunea automatikoki berreraikitzen du (*pages build and deployment* ekintza, ~1 min).

## 1. Aukerak

| # | Aukera | Alde onak | Alde txarrak |
|---|---|---|---|
| A | Dagoen bezala utzi (Cayman gaia) | Arriskurik ez | Alboko menurik eta bilatzailerik ez; aurkezpenean nabigatzea zaila |
| B | Biltegia `prietosuhar.github.io` izenera aldatu | URL laburragoa | Irakasleak eta taldeak dituzten estekak hausten dira; kontu pertsonaleko webgune nagusia ikasgelako lan batean gastatzen da |
| C | **URL bera mantendu + Just the Docs gaia** | Dokumentazio-webgune profesionala: alboko menua ikasgaika, bilatzailea, «Editatu GitHub-en», ainguratutako izenburuak | Orri guztien goiburua (*front matter*) ukitu behar da |

## 2. Erabakia: C

- **URLa ez da aldatzen** → irakasleari emandako esteka berak balio du.
- **Just the Docs** dokumentazio teknikorako diseinatutako gaia da (librea, MIT lizentzia). GitHub Pages-ek `remote_theme` bidez onartzen du, GitHub Actions edo zerbitzaririk gabe.
- Ikasgai bakoitza menuko atal bat da, eta bere orriak azpiatalak → errubrikaren egitura berarekin aurkezten dugu.
- Bilatzaileak (adib. «Suricata», «GPO», «3306») defentsan edozein ataletara segundotan joateko balio du.
- Bertsioa finkatuta (`v0.10.1`) → gaiak bertsio berri bat ateratzen badu ere, gure webgunea ez da aldatzen.

## 3. Nola egin da

1. `_config.yml`: `theme: jekyll-theme-cayman` → `remote_theme: just-the-docs/just-the-docs@v0.10.1` eta pluginak (`jekyll-remote-theme`, `jekyll-relative-links`…), logoa, bilatzailea, «Editatu GitHub-en» esteka eta oina.
2. `_sass/custom/setup.scss`: BioHealth-en kolorea (`#0f766e`) esteketan eta botoietan.
3. Ikasgai bakoitzaren `index.md`-ri `nav_order` eta `has_children: true` gehitu.
4. Orri bakoitzari `parent:` (ikasgaiaren izenburua) eta `nav_order` gehitu.
5. Goibururik ez zuten hiru orriri (`hacking.md`, `zertifikatuak.md`, `jasangarritasuna.md`) izenburua jarri.
6. Segurtasun-orrietatik AA tresnek utzitako `[cite: N]` hondarrak kendu.
7. Bikoiztutako HW fitxategiak (`irudiak/HW/Biohealth_HW.md`, `docs/HW-hardwarea/HW-txostena`) eta `README.md` webgunetik kanpo utzi (`exclude`).

## 4. Orri berri bat nola gehitu (taldekideentzat)

Ikasgaiaren karpetan `.md` fitxategia sortu eta **goiburu hau** jarri lehen lerroetan. `parent` ikasgaiaren `index.md`-ko `title` berdin-berdina izan behar da (marratxo luzea `–` barne); bestela orria ez da menuan agertuko.

```yaml
---
title: CUPS
parent: "SEA – Sistema eragileak"
nav_order: 3
---
```

| Ikasgaia | `parent` |
|---|---|
| Orokorra | `"Orokorra"` |
| SEG | `"SEG – Segurtasuna"` |
| SEA | `"SEA – Sistema eragileak"` |
| SZI | `"SZI – Sareko zerbitzuak"` |
| DBKSA | `"DBKSA – Datu-baseak"` |
| WAE | `"WAE – Web aplikazioak"` |
| SB | `"SB – Sistema banatuak"` |
| HACK | `"HACK – Hacking etikoa"` |
| IRAU | `"IRAU – Iraunkortasuna"` |
| HW | `"HW – Hardwarea"` |

Gogoratu ikasgaiaren `index.md`-ko taulan ere esteka gehitzea. Argazkiak: ikus [Argazkiak nola igo](argazkiak-nola-igo.md).

## 5. Egiaztapena

| Proba | Emaitza espero dena |
|---|---|
| GitHub → *Actions* → *pages build and deployment* | ✅ berdea commit-aren ondoren |
| Webgunea ireki | Alboko menua 10 ikasgaiekin, logoa eta bilatzailea |
| Bilatzailean «DHCP» idatzi | SZI › DHCP orria agertzen da |
| Orri baten behealdean «Editatu orri hau GitHub-en» | GitHub-eko editorea irekitzen da |
| Orrien arteko esteka erlatiboak (`../../index.md`) | `.html` orrietara bideratzen dira |

## 6. Arazoak

| Sintoma | Kausa eta konponbidea |
|---|---|
| Orria ez da menuan agertzen | `parent` gaizki idatzita (marratxoa, maiuskulak) edo goibururik ez → 4. atala |
| *pages build* gorria | `_config.yml`-n YAML akatsa, edo testuan Liquid etiketak (giltza bikoitzak, giltza + ehuneko ikurra) → `raw` blokean sartu. Eraikitzeak huts egiten badu, aurreko bertsioa geratzen da argitaratuta |
| Aldaketak ez dira ikusten | Itxaron ~1 min eta orria freskatu (Ctrl+F5) |
