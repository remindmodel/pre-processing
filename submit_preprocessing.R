

# sleep 1  # give ssh time to set up th proxy before starting anything else

#############################################################################
#source(\"run_preprocessing.R\")

#run_preprocessing("default.cfg")

sbatchCommand <- paste0("sbatch",
                         " --qos=priority",
                         " --job-name=rem-preprocessing",
                         " --output=log-%j.out",
                         " --mail-type=END",
                         " --mem=32000",
                  # During preprocessing we need internet access (e.g. for generating the renv).
                  # To get internet access on the compute nodes we need to set up an ssh proxy
                  # and set the necessary environment variables to use the proxy.
                         " --wrap=\"(ssh -N -D 1080 $USER@login01 &);",
                                   " https_proxy=socks5://127.0.0.1:1080",
                                   " SSL_CERT_FILE=/p/projects/rd3mod/ssl/ca-bundle.pem_2022-02-08",
                            # The standard temporary directory location /tmp is pretty small on the compute nodes and
                            # local storage is not available there.
                            # Therefore, we use a temporary directory on the cluster file system.
                                   " TMPDIR=/p/projects/rd3mod/inputdata/tmp/",
                            # run preprocessing
                                   " Rscript run_preprocessing.R \""
                        )

system(sbatchCommand)




