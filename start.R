library(moinput)

#### list of region mappings to create input data ####
regionmappinglist <- c('regionmappingREMIND.csv',
                       "regionmappingH12.csv","regionmapping_21_EU11.csv","regionmapping_22_EU11.csv","regionmappingH12_Aus.csv")


#### Current input data revision (<mainrevision>.<subrevision>) ####
revision <- 5.8491

for (regionmapping in regionmappinglist){
   retrieveData(model="REMIND",regionmapping=regionmapping,rev=revision)
}
