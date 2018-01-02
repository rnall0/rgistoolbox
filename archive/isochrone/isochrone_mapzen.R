#Mapzen Services will turn off in February 1, 2018.
#https://mapzen.com/blog/shutdown/

library(rgdal)
library(rmapzen)
Sys.setenv(MAPZEN_KEY = "mapzen-XXXXX")


address<-"4031 Parkway Dr Florence, AL 35630"
nsideiso <- mz_geocode(address)
nsideisos <- mz_isochrone(
  nsideiso,
  costing_model = mz_costing$auto(),
  contours = mz_contours(c(30, 60, 90)), #30 minutes to 90 minutes
  polygons = TRUE
)

nsideisos_out<-as_sp(nsideisos)
plot(nsidesos_out)
out_name<-"nside_iso"
writeOGR(obj=nsidesos_out, dsn="data/drivetime", layer=out_name, driver="ESRI Shapefile")
