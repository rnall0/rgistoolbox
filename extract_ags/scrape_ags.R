#library(devtools)
#install_github("yonghah/esri2sf")

library(esri2sf)
library(sf)

url<-"https://something.arcgis.com/someid/ArcGIS/rest/services/NamedService/FeatureServer/" #URL to map
laynum<-0 #layer number
df<-esri2sf(paste(url, laynum, sep="")) #returns df and sf object

st_write(df, "extract.geojson") #write it out to directory
