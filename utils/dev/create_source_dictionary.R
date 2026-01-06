## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## R code for Npuls CEDA (Centre for Educational Data Analytics)
## Web Page: https://edu.nl/twt84
## Contact: corneel.denhartogh@surf.nl
##
##' *INFO*:
## Creates a dataReporter dictionary of the source file.
## Output is timestamped with source filename for comparison with other sources.
##
## ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

source("utils/00_set_up_environment.R")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. CONFIGURATION ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

source_file <- config::get("data_1cho_enrollments_file_path")
source_filename <- tools::file_path_sans_ext(basename(source_file))
timestamp <- format(Sys.time(), "%Y%m%d_%H%M")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. READ SOURCE DATA ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

source_data <- read_delim(source_file,
                          delim = ";",
                          n_max = 1000,
                          show_col_types = FALSE)

cat("Source file:", source_file, "\n")
cat("Columns:", ncol(source_data), "\n")
cat("Rows (sample):", nrow(source_data), "\n")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3. CREATE DICTIONARY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

output_dir <- "metadata/data_dictionary_source"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

output_file <- file.path(output_dir,
                         paste0("dictionary_", source_filename, "_", timestamp, ".html"))

dataReporter::makeDataReport(source_data,
                             output = "html",
                             file = output_file,
                             replace = TRUE)

cat("\n=== OUTPUT ===\n")
cat("Dictionary created:", output_file, "\n")
