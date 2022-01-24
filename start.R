library(mrremind)
library(mrcommons)
library(mrvalidation)
library(edgeTransport)
library(tibble)

# Data frame with the names of the files containing the ISO-to-region mapping to which the data should be aggregated.
# First column "regionmapping": region mapping used for the aggregatin of the input data
# Second column "extramapping": mapping with regions to which only the historic data are aggregated in addition to the normal region mapping

mappings <- tribble(~regionmapping,              ~extramapping,
                    "regionmappingH12.csv",      "",
                    "regionmapping_21_EU11.csv", "missingH12.csv")


# Current input data revision (<mainrevision>.<subrevision>) ####
revision <- "6.278-david"   # should be a number with two decimal places for production

sessionInfo()

for (i in 1:nrow(mappings)){

  # Produce input data for all regionmappings (ignore extramappings)  
  retrieveData(model = "REMIND", regionmapping = mappings$regionmapping[i], rev = revision)
  
  # Produce historical data for regionmappings and extramappings
  retrieveData(model="ValidationREMIND", regionmapping = mappings$regionmapping[i], extramapping = mappings$extramapping[i], rev = revision)
}
