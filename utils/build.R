## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## R code for Npuls CEDA (Centre for Educational Data Analytics)
## Web Page: https://edu.nl/twt84
## Contact: corneel.denhartogh@surf.nl
##
##' *INFO*:
## 1) This file runs all scripts to build all datasets.
##
## ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

source("utils/00_set_up_environment.R")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## GENERATE SOURCE DATA DICTIONARY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

source("utils/dev/render_data_dictionary.R")
render_data_dictionary(type = "source", check_changed = TRUE)

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## RUN PIPELINE ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

folders_to_run <- write_config_proj() %>%
  pull(script_dir)

scripts_to_run <- folders_to_run %>%
  map(., ~ paste0(., "/", list.files(.))) %>%
  unlist()

# Create a data frame for script validation
script_validation <- tribble(
  ~script        ,
  scripts_to_run
) %>%
  unnest(c(script))

## Read the Script validation data in
##' *Note*: All scripts are run here, it takes a long time
script_validation <- script_validation %>%
  mutate(
    validation_result = map(
      script,
      possibly(~ vusa::validate_script_proj(.x, TRUE), otherwise = NULL)
    )
  ) %>%
  mutate(validation_success = map_lgl(validation_result, ~ !is.null(.x)))

clear_script_objects()


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## GENERATE END DATA DICTIONARY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

render_data_dictionary(type = "end")
