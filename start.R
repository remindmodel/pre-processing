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
revision <- 5.968

sessionInfo()

for (regionmapping in regionmappinglist){
   retrieveData(model="REMIND",regionmapping=regionmapping,rev=revision)
}
