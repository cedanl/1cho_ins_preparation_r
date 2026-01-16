<div align="center">
  <h1>1CijferHO Preparation</h1>

  <p>📊 Bereid 1CijferHO data voor op visualisatie</p>

  <p>
    <img src="https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white" alt="R">
    <img src="https://img.shields.io/badge/renv-Reproducible-blue" alt="renv">
    <img src="https://badgen.net/github/last-commit/cedanl/1cho_ins_preparation_r" alt="Last Commit">
    <img src="https://badgen.net/github/contributors/cedanl/1cho_ins_preparation_r" alt="Contributors">
  </p>
</div>

## 📋 Overzicht

> [!NOTE]
> Dit project bevat synthetische testdata, zodat je direct aan de slag kunt zonder eigen data.

**Transformeer het 1CijferHO instellingsbestand naar een dataproduct dat geschikt is voor visualisatie in dashboards.**

Dit is een CEDA-repository voor het voorbereiden van 1CijferHO inschrijvingsdata. Voor een voorbeeld van een dashboard gebouwd op deze data, zie de [1cho_ins_visualisation_tableau repository](https://github.com/ed2c/1cho_ins_visualisation_tableau).

### Waarom 1CijferHO?

- **Vergelijkbaarheid** - Landelijke uniformiteit maakt vergelijking met andere instellingen eenvoudig
- **Hoge kwaliteit** - Gevalideerd door DUO én instellingen zelf
- **Uitgebreide documentatie** - Meer dan 100 variabelen, inclusief CBS en DUO data
- **Niet intern beschikbaar** - Bevat gegevens die niet in interne datasets voorkomen

<br>

## 🚀 Snel Starten

> [!WARNING]
> Volg deze stappen bij het eerste gebruik. Het project werkt niet zonder deze setup.

### 0. Data Voorbereiden (indien nodig)

Heb je ruwe 1CijferHO data in ASCII-formaat? Gebruik dan eerst de [1cijferho tool](https://github.com/cedanl/1cijferho/tree/avans-feature-requests) om:
- Het instellingsbestand om te zetten van ASCII naar CSV
- Automatisch decoderingbestanden te koppelen

### 1. Repository Clonen

```bash
git clone https://github.com/cedanl/1cho_ins_preparation_r.git
cd 1cho_ins_preparation_r
```

### 2. Project Openen in RStudio

Open het `.Rproj` bestand. Bij het openen wordt `renv` automatisch geactiveerd.

### 3. Omgeving Initialiseren

> [!IMPORTANT]
> Dit script moet je **bij iedere opstart** van het project uitvoeren om packages, systeemvariabelen en functies te laden.

```r
source("utils/00_set_up_environment.R")
```

### 4. Configuratie Aanpassen (optioneel)

Pas `config.yml` aan voor je eigen instelling:

```r
# Bekijk huidige configuratie
Sys.getenv("R_CONFIG_ACTIVE")  # default = synthetische data

# Activeer andere configuratie (bijv. voor VU)
Sys.setenv(R_CONFIG_ACTIVE = "vu")
```

> [!TIP]
> De `default` configuratie gebruikt synthetische data, zodat je direct kunt testen zonder eigen data.

### 5. Pipeline Uitvoeren

```r
# Voer de complete pipeline uit
source("utils/build.R")
```

### 6. Data Dictionaries Bekijken

De build maakt automatisch data dictionaries aan:

- **Source dictionary** (`metadata/data_dictionary_source/`) - Beschrijft de ruwe inputdata. Wordt alleen opnieuw gegenereerd als de brondata is gewijzigd.
- **End dictionary** (`metadata/data_dictionary_end/`) - Beschrijft de verrijkte outputdata na de pipeline.

Deze dictionaries documenteren alle variabelen, datatypes en waardebereiken.

<br>

## 📁 Mappenstructuur

```
├── 00_download/     # Download CROHO referentiedata
├── 01_audit/        # Valideer ruwe data integriteit
├── 02_prepare/      # Transformeer en verrijk data (3 stappen)
├── 03_combine/      # Integreer datasets en voeg berekende velden toe
├── 04_export/       # Genereer outputbestanden
├── data/            # Data directories (raw, audited, prepared, combined, exported)
├── metadata/        # Mapping tabellen, data dictionaries, assertions
├── utils/           # Gedeelde utilities en helperfuncties
└── test/            # Test- en verkenningsscripts
```

<br>

## 🎯 Doel en Activiteiten

Het doel is data voorbereiden voor visualisatie: kolomnamen en waarden moeten begrijpelijk zijn, met categorische variabelen die beperkt genoeg zijn om als kleurgroep in grafieken te gebruiken.

### Afgeleide Variabelen

1. **Verrijking met karakterwaarden** - Ruwe data bevat codes; ondersteunende bestanden leveren de bijbehorende tekstwaarden

2. **Nieuwe variabelen**:
   - Studiejaar (Student in opleiding)
   - Uitval eerste jaar vóór 1 februari
   - Aantal inschrijvingen bij instelling in gegeven jaar (dubbele studie)
   - VO-profielen
   - Tussenjaren
   - Aansluiting (instroom)

3. **CROHO-verrijking** - Opleidingsdata met EC's en nominale studieduur

4. **Prestatie-indicatoren** - Nominaal studiesucces en uitval

<br>

## ⚙️ Configuratie

### config.yml

Instellingsspecifieke settings zoals jaar, paden en mapping tabellen:

```yaml
default:
  year: 2023
  metadata_institution_name: "synthetic"
  data_1cho_enrollments_file_name: "EV299XX24_1cijferho_main_export_synthetic.csv"
  add_faculty: TRUE
  add_internal_programme_name: TRUE

vu:
  metadata_institution_name: "VU"
  metadata_institution_BRIN: "21PL"
  # Overige settings worden geërfd van default
```

Voeg je eigen instelling toe door een nieuwe sectie aan te maken. Settings die niet gespecificeerd worden, worden geërfd van `default`.

<br>

## 🔗 Afhankelijkheden

Dit project gebruikt packages van de [vusaverse](https://github.com/vusaverse/):

- **vvauditor** - Data auditing
- **vvconverter** - Waarden mappen en basis aanpassingen
- **vvmover** - Dynamisch opslaan en laden

<br>

## ✅ CEDA Checklist

<details>
<summary>Bekijk status</summary>

| Item | Status |
|------|--------|
| Code draait succesvol | ✅ |
| Config bestand voor instellingsspecifieke settings | ✅ |
| Build bestand | ✅ |
| Instructiebestand met doel en context | ✅ |
| Duidelijke structuur volgens best practices | ✅ |
| Data dictionaries bij start en eind | ✅ |
| Gestijlde code ([tidyverse guide](https://style.tidyverse.org/)) | ✅ |
| Machine-leesbare bestanden (.R, .csv, .yaml, .md, .qmd) | ✅ |
| Automatische validatie van databestanden | ⏳ |
| Synthetische of dummy startdata | ✅ |
| Engelse taal voor code en documentatie | ✅ |
| Glossary met kolomnamen en uitleg | ⏳ |

</details>

<br>

## 🤝 Bijdragen

Bijdragen zijn welkom! Als je bugs vindt, feature requests hebt, of code-verbeteringen wilt bijdragen, open dan een issue of pull request op de GitHub repository.

<br>

## 📚 Meer Informatie

- [how_to.qmd](how_to.qmd) - Uitgebreide handleiding
- [renv documentatie](https://rstudio.github.io/renv/articles/renv.html)
- [config documentatie](https://rstudio.github.io/config/)
- [DUO 1CijferHO pagina](https://duo.nl/zakelijk/hoger-onderwijs/studentenadministratie/bron-controleren/deelnames-en-resultaten-duo-registers.jsp)
