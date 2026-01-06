## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Inlezen Dec vooropl.R
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## R code voor Student Analytics Vrije Universiteit Amsterdam
## Copyright 2021 VU
## Web Page: http://www.vu.nl
## Contact: vu-analytics@vu.nl
## Verspreiding buiten de VU: Ja
##
## Doel: In dit script wordt het Dec_vooropl.asc omgezet naar RDS en worden
## de kolomnamen omgezet. Dit bestand bevat de uitgebreide vooropleidingscodes.
##
## Afhankelijkheden: Index.R
##
## Datasets: /1cHO/2020/LEESMIJ en reerentietabellen/Dec_vooropl.asc
##
## Opmerkingen:
## 1) Geen
##
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. INLEZEN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Lees alle benodigde bestanden in:
Bestandspad <- paste0(
  config::get("metadata_1cho_decoding_files_dir"), "Dec_vooropl.asc"
)

Dec_vooropl <- read_fwf(Bestandspad,
                        fwf_widths(c(5, 200)),
                        locale = locale(encoding = "windows-1252"))

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. BEWERKEN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Bestandsbeschrijving_Dec-bestanden.txt bevat uitleg voor de inhoud van de kolommen

## Splits kolom X1 in 2 kolommen en geef de juiste kolomnamen
Dec_vooropl <- Dec_vooropl %>%
  ## Verwijderen van accenten
  mutate(across(
    everything(),
    ~ stri_trans_general(str = ., id = "Latin-ASCII")
  )) %>%
  ## Splits kolom X1 in 2 kolommen
  rename(
    from = X1,
    to = X2
  )


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BEWAAR & RUIM OP ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_file_proj(Dec_vooropl,
                name = "Mapping_INS_Vooropleiding_code_INS_Vooropleiding_naam",
                full_dir = Sys.getenv("MAP_TABLE_DIR"),
                extensions = "csv")

clear_script_objects()
