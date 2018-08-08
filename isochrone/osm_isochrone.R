library(osrm)
library(cartography)

laylox<-subset(location, select=c("lon", "lat"))
spdf <- SpatialPointsDataFrame(coords = laylox, data = location,
                               proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
iso <- osrmIsochrone(loc = spdf[1,], breaks = seq(from = 0,to = 30, by = 5))
#pre.iso<-osrmIsochrone(laylox)
#iso <- osrmIsochrone(loc = src2[0,], breaks = seq(from = 0,to = 30, by = 5))
#iso <- osrmIsochrone(loc, breaks = seq(from = 0,to = 30, by = 5))

if(require("cartography")){
  osm <- getTiles(spdf = iso, crop = TRUE, type = "osmtransport")
  tilesLayer(osm)
  breaks <- sort(c(unique(iso$min), max(iso$max)))
  pal <- paste(carto.pal("taupe.pal", length(breaks)-1), "95", sep="")
  cartography::choroLayer(spdf = iso, df = iso@data,
                          var = "center", breaks = breaks,
                          border = "grey50", lwd = 0.5, col = pal,
                          legend.pos = "topleft",legend.frame = TRUE, 
                          legend.title.txt = "Driving Time\nto Renescure\n(min)", 
                          add = TRUE)
  plot(src[6,], cex = 2, pch = 20, col ="red", add=T)
  text(src[6,], label = "Renescure", pos = 3)
