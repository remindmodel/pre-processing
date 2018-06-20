#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=rem-preprocessing
#SBATCH --output=log-%j.out
#SBATCH --mail-type=END
#SBATCH --mem=32000

Rscript start.R
