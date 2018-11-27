library(moinput)

cfg <- list()

#### region mapping ####
cfg$regionmapping <- "regionmappingH12.csv"

#### Current input data revision (<mainrevision>.<subrevision>) ####
cfg$revision <- 5.808

retrieveData(model="REMIND",regionmapping=cfg$regionmapping,rev=cfg$revision)
 
