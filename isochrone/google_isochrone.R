library(geosphere)
library(ggmap)
library(dplyr)


#distance function (approximates 1 degree of latitude as 69 miles)
crude_distance = function(lat,lon,distance) { 
  output= data.frame(lat=distance/69,lon = 0)
  output$lon = distance/((-0.768578 - 0.00728556 *lat) * (-90. + lat))
  output
}

findDist <- function(lat,lon, drivetime, pts = 5, multiplier=1.0){
  
  #create the upper bound lat and lon using the crude_distance
  #function and then store this upper bound in a data frame
  distance = dt*multiplier
  DeltaDF = crude_distance(lat,lon,distance) 
  lats <- data.frame(lat=seq(from=-DeltaDF$lat,to= DeltaDF$lat, length.out=pts) + lat)
  lons <- data.frame(lon=seq(from=-DeltaDF$lon,to= DeltaDF$lon, length.out=pts) + lon)
  distanceDF <- expand.grid(lats$lat,lons$lon)
  names(distanceDF) <- c("lat","lon")
  distanceDF <- mutate(distanceDF,loc=paste(lat,lon))
  count = 1
  for (i in 1:nrow(lats)){
    tmp <- mapdist(to=distanceDF$loc[count:(count+pts-1)], from = paste(lat,lon))
    distanceDF[count:(count+pts-1),"minutes"] = tmp$minutes
    count = count+pts
  }
  distanceDF
}


#get a google map for Florence, AL
cmb = get_map("123 Main Street Florence, AL 35630", zoom= 12)

#geocode points
geocode_locations = data.frame(place=c("123 Main Street, Florence, AL 35630", "123 Workplace Street, Florence, AL 35630"),names=c("My House", "My Work"),stringsAsFactors = F)
geocode_locations[,c("lon","lat")] = geocode(geocode_locations$place)

#desired drivetime
dt = 10

#call function
distanceDF = findDist(lat = geocode_locations[1,4], lon = geocode_locations[1,3], drivetime = dt, pts=30, multiplier = 0.85 )


#theme for the map
theme_clean <- function(base_size = 8) {
  require(grid)
  theme_grey(base_size) %+replace%
    theme(
      axis.title      =   element_blank(),
      axis.text       =   element_blank(),
      axis.text.y = element_blank(),
      axis.text.x = element_blank(),
      panel.background    =   element_blank(),
      panel.grid      =   element_blank(),
      axis.ticks.length   =   unit(0,"cm"),
      axis.text       =  element_text(margin   =   unit(0,"cm")),
      panel.margin    =   unit(0,"lines"),
      plot.margin     =   unit(c(0,0,0,0),"lines"),
      complete = TRUE
    )
}

#make map
ggmap(cmb)+ stat_contour(data=distanceDF, aes(x=lon,y=lat,z=minutes),breaks=c(0,dt), geom="polygon",size=1, fill="yellow",color="blue", alpha=0.5) + 
  geom_point(data=geocode_locations,aes(lon,lat,color=names),size=6) + 
  scale_color_discrete("") +   
  ggtitle(paste("Isochrone Test of 10 Min Drive"))
