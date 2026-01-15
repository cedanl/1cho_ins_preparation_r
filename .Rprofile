Sys.setenv(
  RENV_CONFIG_STARTUP_QUIET = TRUE,
  RENV_CONFIG_SYNCHRONIZED_CHECK = FALSE,
  RENV_PATHS_RENV = file.path("utils/renv"),
  RENV_PATHS_LOCKFILE = file.path("utils/proj_settings/renv.lock")
)
source("utils/renv/activate.R")

# --- SETUP INSTRUCTIONS ---
if (interactive() && file.exists("utils/00_setup.R")) {
  # 1. Print the visual message (Safe in all IDEs)
  message("\n", rep("-", 60))
  message("🚀  Setup script detected: 'utils/00_setup.R'")
  message("👉  To initialize your environment, run:")
  message("\n    source(\"utils/00_setup.R\")\n")
  message(rep("-", 60))
}
