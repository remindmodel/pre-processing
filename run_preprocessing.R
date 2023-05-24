
run_preprocessing <- function(cfg) {

  library(mrremind)
  library(mrcommons)
  library(mrvalidation)
  library(edgeTransport)

  message(sessionInfo())
  
  # disable size limit on magpie objects
  options(magclass_sizeLimit = -1)
  
  # read in configuration
  cfg <- gms::check_config(cfg, modulepath = NULL)
  
  # use cachefolder from configuration file if exists
  if (!is.null(cfg$cachefolder)) {
    madrat::setConfig(cachefolder = cfg$cachefolder)
  }
  
  for (mapping in cfg$mappinglist) {
  
    # Produce input data for all regionmappings (ignore extramappings_historic)  
    retrieveData(model = "REMIND", regionmapping = mapping[["regionmapping"]], 
                 rev = cfg$revision, dev = cfg$dev, cachetype = cfg$cachetype,
                 renv = cfg$renv)
    
    # Produce historical data for regionmappings and extramappings_historic.
    # The region hash of the historical data file will concatenated from the individual hashes of regionmapping and extramappings_historic.
    retrieveData(model = "VALIDATIONREMIND", 
                 regionmapping = mapping[["regionmapping"]], 
                 extramappings = mapping[["extramappings_historic"]], 
                 rev = cfg$revision, dev = cfg$dev, cachetype = cfg$cachetype,
                 renv = cfg$renv)
  }
}

