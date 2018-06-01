library(rgdal)
library(sf)

#import spatial data

coord<-"CRSstring" #ex:"+proj=utm +zone=16 +ellps=WGS84 +datum=WGS84 +units=m +no_defs" #set coordinate system
shp_project<-spTransform(shp, CRS(coord)) #apply CRS to new object

#do stuff.......

#using sf package (much easier)
shp<-shp %>% st_transform(4326) #or whatever EPSG code

#do stuff......
