library(mrremind)
library(mrcommons)
library(mrvalidation)
library(edgeTransport)

#### List of region mappings to create input data ####
regionmappinglist <- c("regionmappingH12.csv",
                       "regionmappingREMIND.csv",
		       "regionmapping_21_EU11.csv",
                       "regionmappingH12_Aus.csv")


#### Current input data revision (<mainrevision>.<subrevision>) ####
revision <- 6.00   # should be a number with two decimal places for production

sessionInfo()

for (regionmapping in regionmappinglist){
   retrieveData(model="REMIND",regionmapping=regionmapping,rev=revision)
}
