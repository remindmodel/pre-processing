

# initialize cfg.file
 cfgFile <- NULL


# load command-line arguments
argv <- commandArgs(trailingOnly = TRUE)
# check if user provided any unknown arguments or cfg files that do not exist
if (length(argv) > 0) {
  file_exists <- file.exists(argv)
  if (sum(file_exists) > 1) stop("You provided more than one file, submit_preprocessing.R can only handle one.")
  if (!all(file_exists)) stop("Unknown parameter provided: ", paste(argv[!file_exists], collapse = ", "))
  # set cfg file to not known parameter where the file actually exists
  cfgFile <- argv[[1]]
}

sbatchCommand <- paste0("sbatch",
                         " --qos=priority",
                         " --job-name=rem-preprocessing",
                         " --nodes=1",
                         " --tasks-per-node=1",
                         " --output=log-`date --iso`.out",
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
                                   " Rscript start.R ", cfgFile, "\""
                        )
message("Submitting " , sbatchCommand, " to cluster")
system(sbatchCommand)




