## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## R code for Npuls CEDA (Centre for Educational Data Analytics)
## Web Page: https://edu.nl/twt84
## Contact: corneel.denhartogh@surf.nl
##
##' *INFO*:
## Update Documentatie_enrollments.csv with new column names from the new source file
##
## ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library(readr)
library(dplyr)
library(stringr)

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. READ FILES ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Read current documentation
documentatie <- read_delim(
  "metadata/assertions/Documentatie_enrollments.csv",
  delim = ";",
  show_col_types = FALSE
)

# Read the mapping rapport
mapping <- read_csv2(
  "utils/dev/kolom_mapping_rapport.csv",
  show_col_types = FALSE
)

cat("Documentatie rows:", nrow(documentatie), "\n")
cat("Mapping rows:", nrow(mapping), "\n")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. CREATE LOOKUP TABLE ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Create lookup: old export name -> new export name
lookup <- mapping |>
  select(oude_kolom, nieuwe_kolom) |>
  distinct()

cat("\nLookup table created with", nrow(lookup), "entries\n")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3. UPDATE DOCUMENTATIE ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Join and update Veldnaam_export
documentatie_updated <- documentatie |>
  left_join(lookup, by = c("Veldnaam_export" = "oude_kolom")) |>
  mutate(
    Veldnaam_export_old = Veldnaam_export,
    Veldnaam_export = coalesce(nieuwe_kolom, Veldnaam_export)
  ) |>
  select(-nieuwe_kolom)

# Count updates
updates <- documentatie_updated |>
  filter(Veldnaam_export != Veldnaam_export_old | is.na(Veldnaam_export_old))

cat("\nUpdated", nrow(updates), "Veldnaam_export values\n")

# Show some updates
cat("\n=== SAMPLE UPDATES ===\n")
updates |>
  select(Veldnaam, Veldnaam_export_old, Veldnaam_export) |>
  head(10) |>
  print()

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 4. WRITE OUTPUT ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Remove temporary column and write
documentatie_final <- documentatie_updated |>
  select(-Veldnaam_export_old)

# Create backup
file.copy(
  "metadata/assertions/Documentatie_enrollments.csv",
  "metadata/assertions/Documentatie_enrollments_backup.csv",
  overwrite = TRUE
)
cat("\nBackup created: Documentatie_enrollments_backup.csv\n")

# Write updated file
write_delim(
  documentatie_final,
  "metadata/assertions/Documentatie_enrollments.csv",
  delim = ";"
)

cat("Updated Documentatie_enrollments.csv written\n")
