library(rgdal)
library(tools)

lau<-readOGR("geodata\\area_of_interest.shp")
plot(lau)

loc<-"C:/some/aoi"

sources.files  <- as.data.frame(list.files(path=loc, recursive=T, pattern="*.shp", full.names=T))
colnames(sources.files)[1]<-"files"
sources.files<-as.data.frame(sources.files[!grepl(".xml", sources.files$files),])
colnames(sources.files)[1]<-"files"

counter<-0
total<-nrow(sources.files)
get_ins<-function(file.name){
  print(file.name)
  split<-strsplit((as.character(file.name)),'/',fixed=TRUE)
  shp<-tryCatch(readOGR(file.name), error=function(s) NA)
  shp<-tryCatch(shp[lau, ], error=function(sj) NA)
  shp.df<-as.data.frame(shp)
  #shp.df$source<-split[[1]][6]
  if(dir.exists(paste("geodata/clipped/", split[[1]][5], sep=""))){
    } else {
      dir.create(paste("geodata/clipped/", split[[1]][5], sep=""))
    }
  write.csv(shp.df, paste("geodata/clipped/", split[[1]][5], "/", file_path_sans_ext(split[[1]][6]), ".csv", sep=""), row.names = F, quote = FALSE)
  counter <<- counter + 1
  message(paste(counter, "of", total))
}

system.time(do.call(rbind,lapply(as.character(sources.files$files),get_ins)))
