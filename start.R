

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







