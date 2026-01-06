## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## R code for Npuls CEDA (Centre for Educational Data Analytics)
## Web Page: https://edu.nl/twt84
## Contact: corneel.denhartogh@surf.nl
##
##' *INFO*:
## Compare old and new 1CHO source files to identify column differences
## Output: kolom_mapping_rapport.csv for review before updating assertions
##
## ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

library(readr)
library(dplyr)
library(tidyr)
library(stringr)

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. CONFIGURATION ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

old_file <- "data/00_raw/2023/CEDA_1CHO_raw_synthetic_new.csv"
new_file <- "data/00_raw/2023/EV299XX24_1cijferho_main_export.csv"
output_file <- "utils/dev/kolom_mapping_rapport.csv"

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. READ HEADERS ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Read only first few rows to get column info
old_data <- read_delim(old_file, delim = ";", n_max = 5, show_col_types = FALSE)
new_data <- read_delim(new_file, delim = ";", n_max = 5, show_col_types = FALSE)

old_cols <- names(old_data)
new_cols <- names(new_data)

cat("Old file columns:", length(old_cols), "\n")
cat("New file columns:", length(new_cols), "\n")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3. CREATE MAPPING ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Function to convert PascalCase to snake_case
pascal_to_snake <- function(x) {
  x |>
    str_replace_all("([a-z])([A-Z])", "\\1_\\2") |>
    str_to_lower()
}

# Create mapping dataframe
mapping <- tibble(
  positie = seq_along(old_cols),
  oude_kolom = old_cols,
  oude_kolom_snake = pascal_to_snake(old_cols),
  nieuwe_kolom = new_cols[seq_along(old_cols)]
)

# Check if snake conversion matches new column
mapping <- mapping |>
  mutate(
    match_type = case_when(
      oude_kolom == nieuwe_kolom ~ "exact_match",
      oude_kolom_snake == nieuwe_kolom ~ "snake_case_match",
      TRUE ~ "different"
    )
  )

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 4. ANALYZE DATA TYPES ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Get column types
old_types <- sapply(old_data, function(x) class(x)[1])
new_types <- sapply(new_data, function(x) class(x)[1])

mapping <- mapping |>
  mutate(
    oude_type = old_types[positie],
    nieuwe_type = new_types[positie],
    type_changed = oude_type != nieuwe_type
  )

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 5. IDENTIFY DIFFERENCES ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Summary statistics
cat("\n=== SUMMARY ===\n")
cat("Total columns:", nrow(mapping), "\n")
cat("Exact matches:", sum(mapping$match_type == "exact_match"), "\n")
cat("Snake case matches:", sum(mapping$match_type == "snake_case_match"), "\n")
cat("Different names:", sum(mapping$match_type == "different"), "\n")
cat("Type changes:", sum(mapping$type_changed), "\n")

# Show columns that are different (not just snake_case conversion)
different_cols <- mapping |>
  filter(match_type == "different")

if (nrow(different_cols) > 0) {
  cat("\n=== COLUMNS WITH DIFFERENT NAMES ===\n")
  print(different_cols |> select(positie, oude_kolom, nieuwe_kolom))
}

# Show type changes
type_changes <- mapping |>
  filter(type_changed)

if (nrow(type_changes) > 0) {
  cat("\n=== COLUMNS WITH TYPE CHANGES ===\n")
  print(type_changes |> select(positie, oude_kolom, oude_type, nieuwe_type))
}

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 6. CHECK FOR NEW/REMOVED COLUMNS ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if (length(new_cols) > length(old_cols)) {
  extra_new <- new_cols[(length(old_cols) + 1):length(new_cols)]
  cat("\n=== NEW COLUMNS IN NEW FILE ===\n")
  print(extra_new)
}

if (length(old_cols) > length(new_cols)) {
  removed <- old_cols[(length(new_cols) + 1):length(old_cols)]
  cat("\n=== REMOVED COLUMNS IN NEW FILE ===\n")
  print(removed)
}

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 7. WRITE OUTPUT ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_csv2(mapping, output_file)
cat("\n=== OUTPUT ===\n")
cat("Mapping rapport geschreven naar:", output_file, "\n")
