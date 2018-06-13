library(sf)
library(tidyr)

altrans<-st_read("X:/somefolder/somekml.kml layer = "Specific Layer")

altrans<-altrans %>%
  separate(Description, c("Desc1", "Desc2"), "<br>") %>%
  st_write("X:/somefolder/somekml.geojson")
