# How to run on the cluster

- Before starting input data generation, you might want to update your libraries by running `make update-renv` (only pik-piam packages) or `update-renv-all` (all CRAN packages). If you want to use other than the latest libraries, manually install the right versions into your renv (see section "Running with with local branches" below).
- Take a look at the settings being used in `config/default.cfg` and make the necessary adjustments (see section "Settings" below).
- To start input data generation, run `Rscript submit_preprocessing.R`.
- Once the process is finished successfully, you will receive an email, the generated files can be found at `/p/projects/rd3mod/inputdata/output_1.27`.

## Settings

You most likely want to adjust `revision` to set a new revision number for your input data archive.
Note that `cfg$revision` may not include characters other than the dot, e.g. `cfg$revision <- "6.607test"` won't work. 

If you want to create input data to test your local changes, set the development suffix `cfg$dev`, e.g. `cfg$dev <- "my-test"`.

The name of the generated input data archive will contain the concatenation of `revision` and `dev`. 

The default settings uses the default cache system (`cfg$cachetype = "def"`), which utilizes the default cache shared by most other madrat processes on the Cluster (`/p/projects/rd3mod/inputdata/cache_1.27`).
If you want to use an existing cache folder other than the default cache folder on the cluster, you can set it using `cfg$cachefolder = "path/to/my/cache"`. 
If this folder is empty, you effectively start from scratch with your input data generation.

If you want to use a separate cache folder starting from scratch for your specific input data revision, set `cfg$cachetype = "rev"` in your config file (`cfg$cachefolder` does not have any effect in this case).

### Details

Currently, the following settings are supported: 

- `cfg$revision`
- `cfg$dev` (development suffix)
- `cfg$cachetype`
- `cfg$renv`
- `cfg$cachefolder`
- `cfg$mappinglist`

`revision`, `dev`, `cachetype` and `renv` will be passed to `madrat::retrieveData`. Please see the documentation of this function `help(retrieveData)` for more info on these parameters.
`cachefolder` sets the madrat cache folder to be used on the cluster.
`mappinglist` contains a set of regional mappings to apply for input data generation. Check to documentation in `config/default.cfg` for more information.

## Running with with local branches

You sometimes need to test input data generation with some unmerged changes in one or more R libraries. In order to do so:
- make sure that you create a development version number when building the R library you are working on (when `lucode2::buildLibrary` succeeds, choose option 4 `4: only for packages in development stage` to get a number consisting of four parts like `0.173.0.9001`)
- do a git check out the version of the library you want to test on the cluster
- open an R session in your pre-processing folder
- install the R package from sources using renv `renv::install("/p/tmp/username/yourpackagefolder")`
- write the installed version to your lock file by running `renv::snapshot()`
- exit the R session and start input data generation

Once the process started, check the beginning of the log file for the installed libraries and make sure that the right version of your R library is being used (i.e. the dev version number you gave it when building the library).

## Useful tools on the cluster

If you need to better understand the difference between two input data archives, there are two tools on the cluster to help you understand which files have changed and to identify commits contributing to these changes:

- `inputdata-comparedata` - Compares the content of two data archives and looks for similarities and differences. Wrapper for `madrat::compareData`. Expects paths to two input data archives.
- `inputdata-commithist` - List all git commits between two input data archives for selected input data libraries. Expects paths to two input data archives, the first must be the older one.
