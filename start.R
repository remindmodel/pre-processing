library(moinput)

#### list of region mappings to create input data ####
regionmappinglist <- c("regionmappingH12.csv","regionmapping_16_EU6.csv","regionmapping_21_EU11.csv","regionmappingH12_Aus.csv")


#### Current input data revision (<mainrevision>.<subrevision>) ####
revision <- 5.835

for (regionmapping in regionmappinglist){
   retrieveData(model="REMIND",regionmapping=regionmapping,rev=revision)
}
