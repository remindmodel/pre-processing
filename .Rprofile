# setting RENV_PATHS_LIBRARY ensures packages are installed into renv/library
# for some reason this also has implications for symlinking into the global cache
Sys.setenv(RENV_PATHS_LIBRARY = "renv/library")

# do not check if library and renv.lock are in sync, because normally renv.lock does not exist
options(renv.config.synchronized.check = FALSE)

source("renv/activate.R")

if (!"https://rse.pik-potsdam.de/r/packages" %in% getOption("repos")) {
  options(repos = c(getOption("repos"), pik = "https://rse.pik-potsdam.de/r/packages"))
}

# bootstrapping, will only run once after this repo is freshly cloned
if (isTRUE(rownames(installed.packages(priority = "NA")) == "renv")) {
  message("R package dependencies are not installed in this renv, installing now...")
  renv::hydrate(prompt = FALSE, report = FALSE) # auto-detect and install all dependencies
  message("Finished installing R package dependencies.")
}

# in case bootstrapping fails halfway, install piamenv and rely on requirement auto-fixing
if (tryCatch(utils::packageVersion("piamenv") < "0.5.5", error = function(error) TRUE)) {
  renv::install("piamenv", prompt = FALSE)
}
