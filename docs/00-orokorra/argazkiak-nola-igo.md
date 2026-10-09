---
title: Argazkiak nola igo
---

[← Hasiera](../../index.md) · [Modulua](index.md)

# Argazkiak nola igo eta dokumentazioan sartu

## 1. Izena jarri argazkiari (igo aurretik)

- Letra xehez, hutsunerik gabe, gidoiekin: `dns-alderantzizko-zona.png`
- **Ez** `Captura de pantalla 2026-10-09 123456.png` (hutsuneek estekak apurtzen dituzte)
- Pasahitzik, IP publikorik edo datu pertsonalik ez dela ageri egiaztatu

## 2. Argazkia igo (GitHub web-etik)

1. Ireki ikasgaiaren karpeta: `irudiak/SZI/`, `irudiak/SEA/`, `irudiak/SEG/`…
2. **Add file → Upload files** → argazkiak arrastatu
3. Commit mezua: `SZI: DNS argazkiak` → **Commit changes**

| Ikasgaia | Argazkien karpeta | Dokumentuen karpeta |
|---|---|---|
| SEG | `irudiak/SEG/` | `docs/SEG-segurtasuna/` |
| SEA | `irudiak/SEA/` | `docs/SEA-sistema-eragileak/` |
| SZI | `irudiak/SZI/` | `docs/SZI-sareko-zerbitzuak/` |
| DBKSA | `irudiak/DBKSA/` | `docs/DBKSA-datu-baseak/` |
| WAE | `irudiak/WAE/` | `docs/WAE-web-aplikazioak/` |
| SB | `irudiak/SB/` | `docs/SB-sistema-banatuak/` |
| HACK | `irudiak/HACK/` | `docs/HACK-hacking-etikoa/` |
| IRAU | `irudiak/IRAU/` | `docs/IRAU-iraunkortasuna/` |
| HW | `irudiak/HW/` | `docs/HW-hardwarea/` |

## 3. Argazkia dokumentuan sartu

Ireki `.md` fitxategia → arkatza (✏️ *Edit*) → dagokion atalean idatzi:

```markdown
![DNS alderantzizko zona](../../irudiak/SZI/dns-alderantzizko-zona.png)
*1. irudia: 192.168.10 alderantzizko zona sortuta*
```

- `../../irudiak/` beti horrela hasten da (`docs/<IKASGAIA>/` karpetatik bi maila gora)
- Azpian lerro bat argazkiak **zer erakusten duen** azaltzeko (irakasleak hori baloratzen du)
- **Commit changes** → 1–2 minututan webgunean ageri da

## 4. Amaitzean

- Dagokion **Issue**-a itxi (edo iruzkin bat utzi zer falta den)
- `docs/00-orokorra/plangintza.md`-n lerro bat gehitu: data, nork, zer
