.PHONY: help update-renv update-renv-all archive-renv restore-renv
.DEFAULT_GOAL := help

# extracts the help text and formats it nicely
HELP_PARSING = 'm <- readLines("Makefile");\
				m <- grep("\#\#", m, value=TRUE);\
				command <- sub("^([^ ]*) *\#\#(.*)", "\\1", m);\
				help <- sub("^([^ ]*) *\#\#(.*)", "\\2", m);\
				cat(sprintf("%-18s%s", command, help), sep="\n")'

help: ## Show this help.
	@Rscript -e $(HELP_PARSING)

update-renv: ## Upgrade all pik-piam packages in your renv to the respective
             ## latest release and write renv.lock to archive.
	Rscript -e 'piamenv::updateRenv()'

update-renv-all: ## Upgrade all packages (including CRAN packages) in your renv
                 ## to the respective latest release and write renv.lock to archive.
	Rscript -e 'renv::update(exclude = "renv"); piamenv::archiveRenv()'

revert-dev-packages: ## All PIK-PIAM packages that are development versions, i.e.
                     ## that have a non-zero fourth version number component, are
                     ## reverted to the highest version lower than the
                     ## development version.
	@Rscript -e 'piamenv::revertDevelopmentVersions()'

archive-renv: ## Write renv.lock to archive.
	Rscript -e 'piamenv::archiveRenv()'

restore-renv:    ## Restore renv to the state described in interactively
                 ## selected renv.lock from the archive or a run folder.
	Rscript -e 'piamenv::restoreRenv()'

stow-logs:       ## Store all log-*.out files in ./archive/
	@mkdir -p archive/ && mv -iv log-*.out archive/
