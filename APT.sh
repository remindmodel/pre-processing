#!/bin/bash
source /p/system/modulefiles/defaults/piam/module_load_piam_cronjob

cd /p/projects/rd3mod/APT/preprocessing-remind

find /p/projects/rd3mod/APT/APT_remind_madrat_cache -type f -delete >> /p/projects/rd3mod/APT/cache_delete_remind.log 2>&1

git pull

Rscript -e 'renv::hydrate(sources = c("/p/projects/rd3mod/R/libraries/piam_1.27/4.3.2", "/p/system/packages/tools/R/4.3.2/lib64/R/library"), update = "all")'

Rscript submit_preprocessing.R config/APT.cfg
