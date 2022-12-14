library(mrremind)
library(mrcommons)
library(mrvalidation)
library(edgeTransport)

# List with the names of the files containing the ISO-to-region mapping to which the data should be aggregated. 
# Each list element is a named vector with:
# - the first element "regionmapping": region mapping used for the aggregation of the input data
# - the second element "extramappings_historic": mapping with regions to which only the historic data are aggregated in addition to the normal region mapping

mappinglist <- list(c(regionmapping = "regionmappingH12.csv",      extramappings_historic = ""),
                    c(regionmapping = "regionmapping_21_EU11.csv", extramappings_historic = "extramapping_EU27.csv"))

# Current input data revision (<mainrevision>.<subrevision>) ####
revision <- "6.323"   # should be a number with two decimal places for production
dev <- ""             # development suffix
cachetype <- "def"
puc <- identical(dev, '')
renv <- TRUE

sessionInfo()

for (mapping in mappinglist) {

  # Produce input data for all regionmappings (ignore extramappings_historic)  
  retrieveData(model = "REMIND", regionmapping = mapping[["regionmapping"]], 
               rev = revision, dev = dev, cachetype = cachetype, puc = puc,
               renv = renv)
  
  # Produce historical data for regionmappings and extramappings_historic.
  # The region hash of the historical data file will concatenated from the individual hashes of regionmapping and extramappings_historic.
  retrieveData(model = "VALIDATIONREMIND", 
               regionmapping = mapping[["regionmapping"]], 
               extramappings = mapping[["extramappings_historic"]], 
               rev = revision, dev = dev, cachetype = cachetype, puc = puc,
               renv = renv)
}
