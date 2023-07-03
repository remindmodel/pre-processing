local({
# setting RENV_PATHS_LIBRARY ensures packages are installed into renv/library
# for some reason this also has implications for symlinking into the global cache
Sys.setenv(RENV_PATHS_LIBRARY = "renv/library")

source("renv/activate.R")

renvVersion <- "0.16.0"
if (packageVersion("renv") != renvVersion) {
  renvLockExisted <- file.exists(renv::paths$lockfile())
  renv::upgrade(version = renvVersion, reload = TRUE, prompt = FALSE)
  if (!renvLockExisted) {
    unlink(renv::paths$lockfile())
  }
}

if (!"https://rse.pik-potsdam.de/r/packages" %in% getOption("repos")) {
  options(repos = c(getOption("repos"), pik = "https://rse.pik-potsdam.de/r/packages"))
}

# bootstrapping, will only run once after remind is freshly cloned
if (isTRUE(rownames(installed.packages(priority = "NA")) == "renv")) {
  message("R package dependencies are not installed in this renv, installing now...")
  renv::hydrate() # auto-detect and install all dependencies
  message("Finished installing R package dependencies.")
}
})
