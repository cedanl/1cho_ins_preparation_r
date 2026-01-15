## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## R code for Npuls CEDA (Centre for Educational Data Analytics)
## Web Page: https://edu.nl/twt84
## Contact: corneel.denhartogh@surf.nl
##
##' *INFO*:
## Renders data dictionary for source data or end-of-pipeline data.
## Uses parametrized Quarto template with interactive reactable output.
##
## ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#' Render Data Dictionary
#'
#' Generates an interactive HTML data dictionary for either source data
#' or end-of-pipeline prepared data.
#'
#' @param type Character. Either "source" (raw 1CHO data) or "end" (prepared data).
#' @param config_name Character. Config profile to use. Defaults to R_CONFIG_ACTIVE env var.
#'
#' @return Invisibly returns the path to the generated HTML file.
#'
#' @examples
#' \dontrun{
#' # Source dictionary (for source file analysis)
#' render_data_dictionary(type = "source")
#'
#' # End dictionary (after pipeline)
#' render_data_dictionary(type = "end")
#'
#' # With specific config
#' render_data_dictionary(type = "end", config_name = "vu")
#' }
render_data_dictionary <- function(
    type = c("source", "end"),
    config_name = Sys.getenv("R_CONFIG_ACTIVE", "default")
) {
  type <- match.arg(type)

  cfg <- config::get(config = config_name)
  institution <- cfg$metadata_institution_name
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M")

  output_dir_rel <- switch(type,
    source = "metadata/data_dictionary_source",
    end = "metadata/data_dictionary_end"
  )
  output_dir <- file.path(getwd(), output_dir_rel)
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

  output_file <- sprintf("dictionary_%s_%s_%s.html", type, institution, timestamp)

  cli::cli_alert_info("Rendering {type} dictionary for {institution}...")

  quarto::quarto_render(
    input = "04_export/data_dictionary.qmd",
    output_file = output_file,
    quarto_args = c("--output-dir", output_dir),
    execute_dir = getwd(),
    execute_params = list(type = type)
  )

  output_path <- file.path(output_dir_rel, output_file)
  cli::cli_alert_success("Dictionary created: {output_path}")
  invisible(output_path)
}
