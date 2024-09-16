.PHONY: help update-renv update-renv-all archive-renv
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

archive-renv: ## Write renv.lock to archive.
	Rscript -e 'piamenv::archiveRenv()'
