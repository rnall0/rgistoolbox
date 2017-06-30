library (rgdal)
library(sp)
library(raster)

sj_otm<-function(polygon.name){
  print(polygon.name)
  indv.poly<-poly[poly@data$NAME == polygon.name, ]
  inter<- intersect(line_shp, indv.poly)
  inter2<-as.data.frame(inter)
}

result<- do.call(rbind,lapply(as.character(poly@data$NAME),sj_otm))
