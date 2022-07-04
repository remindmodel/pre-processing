#!/bin/bash

#SBATCH --qos=priority
#SBATCH --job-name=rem-preprocessing
#SBATCH --output=log-%j.out
#SBATCH --mail-type=END
#SBATCH --mem=32000

# During preprocessing we need internet access (e.g. for generating the renv).
# To get internet access on the compute nodes we need to set up an ssh proxy
# and set the necessary environment variables to use the proxy.
(ssh -N -D 1080 ${USER}@login01 &)
sleep 1  # give ssh time to set up th proxy before starting anything else
export https_proxy="socks5://127.0.0.1:1080"
export SSL_CERT_FILE="/p/projects/rd3mod/ssl/ca-bundle.pem_2022-02-08"

# The standard temporary directory location /tmp is pretty small on the compute nodes and
# local storage is not available there.
# Therefore, we use a temporary directory on the cluster file system.
export TMPDIR="/p/projects/rd3mod/inputdata/tmp/"

Rscript start.R
