library(moinput)

#### list of region mappings to create input data ####
regionmappinglist <- c("regionmappingH12.csv","regionmapping_16_EU5.csv","regionmapping_22_EU11.csv","regionmappingH12_Aus.csv")


#### Current input data revision (<mainrevision>.<subrevision>) ####
revision <- 5.901

for (regionmapping in regionmappinglist){
   retrieveData(model="REMIND",regionmapping=regionmapping,rev=revision)
}
