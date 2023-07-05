if (Sys.getenv("SLURM_JOB_ID", unset = "") == "") {
  if (   'TRUE' != Sys.getenv('ignoreRenvUpdates')
      && !getOption("autoRenvUpdates", FALSE)
      && !is.null(piamenv::showUpdates())) {
    message("Consider updating with `piamenv::updateRenv()`.")
    Sys.sleep(1)
  }

  installedPackages <- piamenv::fixDeps(ask = "TRUE" != Sys.getenv("autoRenvFixDeps"))
  piamenv::stopIfLoaded(names(installedPackages))
}

source("run_preprocessing.R")

#initialize cfg.file
cfgFile <- "config/default.cfg"

# load command-line arguments
argv <- commandArgs(trailingOnly = TRUE)
# check if user provided any unknown arguments or cfg files that do not exist
if (length(argv) > 0) {
  file_exists <- file.exists(argv)
  if (sum(file_exists) > 1) stop("You provided more than one file, submit_preprocessing.R can only handle one.")
  if (!all(file_exists)) stop("Unknown parameter provided: ", paste(argv[!file_exists], collapse = ", "))
  # set cfg file to not known parameter where the file actually exists
  cfgFile <- argv[[1]]
}


run_preprocessing(cfgFile)
