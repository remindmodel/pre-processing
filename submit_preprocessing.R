#!/usr/bin/env Rscript

if (   'TRUE' != Sys.getenv('ignoreRenvUpdates')
    && !getOption("autoRenvUpdates", FALSE)
    && !is.null(piamenv::showUpdates())) {
  message("Consider updating with `piamenv::updateRenv()`.")
  Sys.sleep(1)
}

installedPackages <- piamenv::fixDeps(ask = "TRUE" != Sys.getenv("autoRenvFixDeps"))
piamenv::stopIfLoaded(names(installedPackages))

# initialize cfg.file
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

# read in configuration
source(cfgFile)

# create log folder if provided
if (! is.null(cfg$logPath) && ! file.exists(cfg$logPath)) {
  message("Creating folder: ", cfg$logPath)
  dir.create(cfg$logPath, recursive = TRUE, showWarnings = FALSE)
}

sbatchCommand <- paste0("sbatch",
                         " --qos=priority",
                         " --partition=priority",
                         " --job-name=rem-preprocessing",
                         " --nodes=1",
                         " --tasks-per-node=1",
                         " --output=", paste0(c(cfg$logPath, "log-`date --iso`-%j.out"), collapse = "/"),
                         " --mail-type=END",
                         " --mem=32000",
                  # During preprocessing we need internet access (e.g. for generating the renv).
                  # To get internet access on the compute nodes we need to set up an ssh proxy
                  # and set the necessary environment variables to use the proxy.
                         " --wrap=\"(ssh -N -D 1080 $USER@login01 &);",
                                   " https_proxy=socks5://127.0.0.1:1080",
                                   " SSL_CERT_FILE=/p/projects/rd3mod/ssl/ca-bundle.pem_2022-02-08",
                            # run preprocessing
                                   " Rscript start.R ", cfgFile, "\""
                        )
message("Submitting " , sbatchCommand, " to cluster")
system(sbatchCommand)
