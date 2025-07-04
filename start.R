#!/usr/bin/env Rscript

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

library(mrremind)
library(mrcommons)
library(mrvalidation)
library(edgeTransport)

print(sessionInfo())

# disable size limit on magpie objects
options(magclass_sizeLimit = -1)

#initialize cfg.file
cfg <- "config/default.cfg"

# load command-line arguments
argv <- commandArgs(trailingOnly = TRUE)

# check if user provided any unknown arguments or cfg files that do not exist
if (length(argv) > 0) {
  file_exists <- file.exists(argv)
  if (sum(file_exists) > 1) stop("You provided more than one file, submit_preprocessing.R can only handle one.")
  if (!all(file_exists)) stop("Unknown parameter provided: ", paste(argv[!file_exists], collapse = ", "))
  # set cfg file to not known parameter where the file actually exists
  cfg <- argv[[1]]
}

# read in configuration
source(cfg)

# use cachefolder from configuration file if exists
if (!is.null(cfg$cachefolder)) {
  madrat::setConfig(cachefolder = cfg$cachefolder)
}

stoppedWithError <- tryCatch({
  for (mapping in cfg$mappinglist) {
    # Produce input data for all regionmappings (ignore extramappings_historic)
    retrieveData(model = "REMIND", regionmapping = mapping[["regionmapping"]],
                 rev = cfg$revision, dev = cfg$dev, cachetype = cfg$cachetype,
                 renv = cfg$renv)

    # Produce historical data for regionmappings and extramappings_historic.
    # The region hash of the historical data file will concatenated from the
    # individual hashes of regionmapping and extramappings_historic.
    retrieveData(model = "VALIDATIONREMIND",
                 regionmapping = mapping[["regionmapping"]],
                 extramappings = mapping[["extramappings_historic"]],
                 rev = cfg$revision, dev = cfg$dev, cachetype = cfg$cachetype,
                 renv = cfg$renv)
  }
  FALSE
}, error = function(error) {
  print(error)
  return(TRUE)
})

today <- format(Sys.time(), "%Y-%m-%d")

# If this is an APT send bot message to mattermost in case the APT produced warnings or errors
if (isTRUE(grepl("APT", cfg$dev))) {
  producedWarnings <- length(warnings()) > 0
  jobid <- Sys.getenv("SLURM_JOB_ID", unset = "")
  logfile <- paste0("/p/projects/rd3mod/APT/preprocessing-remind/", cfg$logPath, "/log-", today, "-", jobid, ".out")
  wordcount <- sum(grepl("WARNING|warning", readLines(logfile)))

  if (stoppedWithError || producedWarnings) {
    mattermostMessage <- paste0("The remind preprocessing ",
                                if (producedWarnings) "produced ", wordcount, " warnings",
                                if (producedWarnings && stoppedWithError) " and ",
                                if (stoppedWithError) "was stopped by an error",
                                ". Please check the log file \`", logfile,"\`")
    writeLines(mattermostMessage, paste0("/p/projects/rd3mod/mattermost_bot/REMIND/APT-", today))
  }
}

if (stoppedWithError) stop("retrieveData stopped due to an error. Search the logfile for 'Error'")

# extract renv.lock file and copy to /p/projects/remind/inputdata/RenvLockFiles
# under the name <revision><dev>.lock
archiveFile <- paste0("rev", cfg$revision, cfg$dev, "_62eff8f7_remind.tgz")
lockFile <- paste0("rev", cfg$revision, cfg$dev, ".lock")
lockFileWritten <- utils::untar(
  tarfile = file.path("/p/projects/rd3mod/inputdata/output_1.27", archiveFile),
  files = "./renv.lock",
  exdir = "/p/projects/remind/inputdata/RenvLockFiles/",
  extras = paste0("--transform='flags=r;s|renv.lock|", lockFile, "|'")
)

if (lockFileWritten == 0) {
  message("Lockfile extracted successfully.\n")
} else {
  warning("Failed to write lock file. Exit status was ", lockFileWritten, ".\n")
}


message(today, " Preprocessing done.\n\n")
