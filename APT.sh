#!/bin/bash

source /p/projects/rd3mod/cron_setup.sh

git pull
make update-renv

Rscript submit_preprocessing.R config/APT.cfg
