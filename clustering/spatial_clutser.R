library(rgdal)
library(fields)
library(fpc)

result<-readOGR("Geodata/shp/upload/Addresses_3mi.shp")

#plot(result)

#head(result@data)

coors<-data.frame(result@data$Latitude, result@data$Longitude)


#determine number of clusters
TheVariance=apply(TheData,2,var)
WithinClusterSumOfSquares = (nrow(TheData)-1)*sum(TheVariance)
for (i in 2:15) {
  ClusterInfo=kmeans(TheData, centers=i)
  WithinClusterSumOfSquares[i] = sum(ClusterInfo$withinss)
}
plot(1:15, WithinClusterSumOfSquares, type="b", xlab="Number of Clusters",ylab="Within groups sum of squares")

#perform
TheData<-scale(coors)
ClusterInfo<-kmeans(TheData, 5) #insert k value
result@data$cluster<-ClusterInfo$cluster
writeOGR(result, "Geodata/shp/upload/Addresses_3mi_test.shp", "result", driver = "ESRI Shapefile")
