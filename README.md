# How to run on the cluster

- Check out this repository on the cluster.
- Before starting input data generation, you might want to update your libraries by running `make update-renv` (only pik-piam packages) or `update-renv-all` (all CRAN packages). If you want to use other than the latest libraries, manually install the right versions into your renv (see section "Running with local branches" below).
- Take a look at the settings being used in `config/default.cfg` and make the necessary adjustments (see section "Settings" below).
- To start input data generation, run `Rscript submit_preprocessing.R`.
- Once the process is finished successfully, you will receive an email, the generated files can be found at `/p/projects/rd3mod/inputdata/output_1.27`.

## Settings

You most likely want to adjust `revision` to set a new revision number for your input data archive.
Note that `cfg$revision` may not include characters other than the dot, e.g. `cfg$revision <- "6.607test"` won't work. 

If you want to create input data to test your local changes, set the development suffix `cfg$dev`, e.g. `cfg$dev <- "my-test"`.

The name of the generated input data archive will contain the concatenation of `revision` and `dev`. 

The default settings use the default cache system (`cfg$cachetype = "def"`), which utilizes the default cache shared by most other madrat processes on the cluster (`/p/projects/rd3mod/inputdata/cache_1.27`).
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

## Running with local branches

You sometimes need to test input data generation with some unmerged changes in one or more R libraries. In order to do so:
- make sure that you create a development version number when building the R library you are working on (when `lucode2::buildLibrary` succeeds, choose option 4 `4: only for packages in development stage` to get a number consisting of four parts like `0.173.0.9001`)
- do a git check out the version of the library you want to test on the cluster
- open an R session in your pre-processing folder
- install the R package from sources using renv `renv::install("/p/tmp/username/yourpackagefolder")`
- exit the R session and start input data generation

Once the process started, check the beginning of the log file for the installed libraries and make sure that the right version of your R library is being used (i.e. the dev version number you gave it when building the library).

## Testing selected parts of input data generation

If you made adjustments to only a few functions in mrremind or other madrat packages that contribute to the input data (e.g. mrindustry), it might be overkill to run the entire input data generation. 

In order to decide, you can get a list of functions affected by your change in a madrat function as follows:

```
madrat::getDependencies("<MadratFunction>", direction = "dout")
madrat::getDependencies("<MadratFunction>", direction = "out")
```

`dout` lists madrat functions that directly use your function and `out` all the functions that may potentially be affected by changes in your function.

If your change affects only a limited number of functions, you can just test your affected functions as follows.

- Open an R session in your pre-processing folder and make sure all the packages are up-to date and your changes are loaded as well (see section "Running with local branches" for details).
- Decide which input data files are affected by your changes using `madrat::getDependencies`. 
- Selectively create the input files that are affected by your change. Look up the exact function calls in `mrremind::fullREMIND.R` used to generate these files and then run them in your R session. For example:

```
library(mrcommons)
library(mrremind)
calcOutput("DiffInvestCosts", round = 4, file = "p_inco0.cs4r")
```

- If you did not change any madrat settings, this will use the caching files shared on the cluster and if nothing crashes the output file can be found in `/p/projects/rd3mod/inputdata/output_1.27`.
- You can compare two magpie objects using the helper `piamutils::compareMagpieObject` to see how data differs due to your changes. In order to do so, you need a cs3r/cs4r before and after your code adjustment. In your R session, use

```
> library(magclass)
> library(piamutils)
> after <- read.magpie("/path/to/new/file/")
> before <- read.magpie("/path/to/old/file/")
> compareMagpieObject(before, after)

# Dimensions are identical (/)
# All dimension names are identical (/)
# Number of NAs is identical
# Maximum value difference in common values: 65.45
## Variables with differences: windon
# Largest differences
     V2    V1     V3        x        y    diff    factor
CHA CHA y2015 windon 1281.177 1215.723 65.4537 0.9489113
LAM LAM y2015 windon 2063.501 2050.927 12.5741 0.9939064

```


## Useful tools on the cluster

If you need to better understand the difference between two input data archives, there are two tools on the cluster to help you understand which files have changed and to identify commits contributing to these changes:

- `inputdata-comparedata` - Compares the content of two data archives and looks for similarities and differences. Wrapper for `madrat::compareData`. Expects paths to two input data archives.
- `inputdata-commithist` - List all git commits between two input data archives for selected input data libraries. Expects paths to two input data archives, the first must be the older one.
