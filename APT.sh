#!/bin/bash

source /p/projects/rd3mod/cron_setup.sh

cd /p/projects/rd3mod/APT/preprocessing-remind
git pull
Rscript -e 'renv::hydrate(rownames(installed.packages()), update = "all")'

Rscript submit_preprocessing.R config/APT.cfg
